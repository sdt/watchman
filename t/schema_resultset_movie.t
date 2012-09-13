use 5.12.0;
use Test::Most;
use Time::Fake;

my $timenow = 1_000_000;
Time::Fake->offset($timenow);

use App::Watchman::Schema;

my $schema = App::Watchman::Schema->new(filename => ':memory:');

my @watchlist = movies(qw( movieA/2001 movieB/2002 movieB/2000 movieC/1999 ));
my @sorted_watchlist = sort_movies(@watchlist);

note 'Populate the movie table with an initial watchlist';
my ($added, $removed) = movie_rs()->update_watchlist(\@watchlist);
eq_or_diff($added, \@watchlist, 'Added the whole watchlist');
eq_or_diff($removed, [ ], 'No movies removed');

my @inactive  = grep { $_->{year} > 2000  } @sorted_watchlist;
@watchlist = grep { $_->{year} <= 2000 } @sorted_watchlist;

note 'Remove some movies from the watchlist and update again';
($added, $removed) = movie_rs()->update_watchlist(\@watchlist);
eq_or_diff($added, [ ], 'No movies added');
eq_or_diff($removed, \@inactive, 'Two movies removed');

note 'Fetch a searchlist';
my $searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, \@watchlist, 'All movies in searchlist');
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, [ ], 'No movies in repeat searchlist');

note 'Wait until tomorrow and fetch the searchlist again';
Time::Fake->offset($timenow += 25 * 60 * 60);
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, \@watchlist, 'All movies in searchlist');
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, [ ], 'No movies in repeat searchlist');

note 'Reactivate some movies';
push(@watchlist, @inactive);
($added, $removed) = movie_rs()->update_watchlist(\@watchlist);
eq_or_diff($added, \@inactive, 'Two movies added');
eq_or_diff($removed, [ ], 'No movies removed');
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, \@inactive, 'New movies in searchlist');
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, [ ], 'No movies in repeat searchlist');

movie_rs()->find({ tmdb_id => 2 })->update({ last_nzbid => 12345 });

done_testing();

#------------------------------------------------------------------------------

sub movie_rs {
    $schema->resultset('Movie')
}

sub movie {
    state $next_id = 1;
    my ($ty) = @_;
    my ($title, $year) = split('/', $ty);
    return {
        tmdb_id     => $next_id++,
        title       => $title,
        year        => $year,
        last_nzbid  => 0,
    };
}

sub movies {
    map { movie($_) } @_;
}

sub sort_movies {
    sort { $a->{title} cmp $b->{title} || $a->{year} <=> $b->{year} } @_;
}
