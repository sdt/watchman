use 5.12.0;
use warnings;
use Test::Most;
use Time::Fake;

my $timenow = 1_000_000;
Time::Fake->offset($timenow);

use App::Watchman::Schema;

my $schema = App::Watchman::Schema->new(filename => ':memory:');

my @keys = qw( tmdb_id title year );
my @watchlist = movies(qw( movieA/2001 movieB/2002 movieB/2000 movieC/1999 ));
my @sorted_watchlist = sort_movies(@watchlist);

note 'Populate the movie table with an initial watchlist';
my ($added, $removed) = movie_rs()->update_watchlist(\@watchlist);
eq_or_diff(strip($added, \@watchlist), 'Added the whole watchlist');
eq_or_diff($removed, [ ], 'No movies removed');

my @inactive  = grep { $_->{year} > 2000  } @sorted_watchlist;
@watchlist = grep { $_->{year} <= 2000 } @sorted_watchlist;

note 'Remove some movies from the watchlist and update again';
($added, $removed) = movie_rs()->update_watchlist(\@watchlist);
eq_or_diff($added, [ ], 'No movies added');
eq_or_diff(strip($removed, \@inactive), 'Two movies removed');

note 'Fetch a searchlist';
my $searchlist = movie_rs()->fetch_searchlist;
eq_or_diff(strip($searchlist, \@watchlist),
    'All movies in searchlist');
update_last_searched($searchlist, $timenow);
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff($searchlist, [ ], 'No movies in repeat searchlist');

note 'Wait until tomorrow and fetch the searchlist again';
Time::Fake->offset($timenow += 24 * 60 * 60);
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff(strip($searchlist, \@watchlist),
    'All movies in searchlist');

note 'Reactivate some movies';
push(@watchlist, @inactive);
($added, $removed) = movie_rs()->update_watchlist(\@watchlist);
eq_or_diff(strip($added, \@inactive), 'Two movies added');
eq_or_diff($removed, [ ], 'No movies removed');
update_last_searched($searchlist, $timenow);
$searchlist = movie_rs()->fetch_searchlist;
eq_or_diff(strip($searchlist, \@inactive), 'New movies in searchlist');

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
    };
}

sub update_last_searched {
    my ($searchlist, $time) = @_;
    movie_rs()->search({
        tmdb_id => { -in => [ map { $_->{tmdb_id} } @$searchlist ] },
    })->update({
        last_searched => $time,
    });
}

sub tmdb_ids {
    my ($searchlist) = @_;
    [ map { $_->{tmdb_id} } @$searchlist ];
}

sub movies {
    map { movie($_) } @_;
}

sub sort_movies {
    sort { $a->{title} cmp $b->{title} || $a->{year} <=> $b->{year} } @_;
}

sub strip {
    subhashes(\@keys, @_);
}

sub subhashes {
    # Takes any amount of listref-of-hashrefs, and returns the same
    # data-structures, but with only the specified keys.
    # This is so we can use eq_or_diff, and ignore 'noise' k/v pairs.
    my ($keys, @loloh) = @_;

    my @ret;
    for my $loh (@loloh) {
        my @subhashes;
        for my $hash (@$loh) {
            my %subhash;
            @subhash{@$keys} = @{$hash}{@$keys};
            push(@subhashes, \%subhash);
        }
        push(@ret, \@subhashes);
    }
    return @ret;
}
