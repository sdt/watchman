use 5.12.0;
use warnings;
use Test::Most;
use Time::Fake;
use Test::Builder;

my $TB = Test::Builder->new;

BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }

my $timenow = 1_000_000;
Time::Fake->offset($timenow);

{
    package Local::Mock::Base;
    use Method::Signatures;

    method new($class:, %h)     { bless { res => [ ], die => 0, %h }, $class }
    method stuff(@a)            { @{ $self->{res} } = @a }
    method die_next($count = 1) { $self->{die} = $count }
    method get()                {
        die if $self->{die}-- > 0;
        shift @{ $self->{res} }
    }
}

{
    package Local::Mock::NZBMatrix;
    use base 'Local::Mock::Base';
    use Method::Signatures;

    method new($class:)         { $class->SUPER::new( rem => 100 ) }
    method search($term)        { $self->{rem}--; $self->get // [ ] }
    method searches_remaining   { $self->{rem} }
}

{
    package Local::Mock::TMDB;
    use base 'Local::Mock::Base';
    use Method::Signatures;

    method new($class:)         { $class->SUPER::new( arg => [] ) }
    method _get($a)             { push(@{ $self->{arg} }, $a);
                                  $self->get // [] }
    method get_watchlist()      { $self->_get('wl') }
    method get_movie_info($id)  { $self->_get($id) }
    method args                 { my $a = $self->{arg}; $self->{arg} = []; $a }
}

use App::Watchman;

my $config    = { dbfile => ':memory:', email => { to => 'me@example.com' } };
my $nzbmatrix = Local::Mock::NZBMatrix->new;
my $tmdb      = Local::Mock::TMDB->new;
my $searches  = 100;

is($nzbmatrix->searches_remaining, $searches, "$searches searches remaining");

my $wm = App::Watchman->new(
    config    => $config,
    nzbmatrix => $nzbmatrix,
    tmdb      => $tmdb,
);

my @movies = movies(4);
my %tmdbs = map { $_->{tmdb_id} => $_ } @movies;
my %nzbs  = map { $_->{tmdb_id} => [ results($_, 4) ] } @movies;
my @keys = keys $movies[0];
my $stash;
my $age = 1000;

#------------------------------------------------------------------------------
note 'Add two movies to watchlist';
$tmdb->stuff(@tmdbs{1, 2});

$wm->_update_watchlist($stash = {}, [ 1, 2 ]);

eq_or_diff($tmdb->args, [ 1, 2 ], 'get_movie_info called twice');
eq_or_diff(delete $stash->{added}, [ @tmdbs{1, 2} ], 'two movies added');
eq_or_diff($stash, { }, 'no extras in stash');
eq_or_diff([ searchlist_ids($wm) ], [ 1, 2 ], 'searchlist contains 1, 2');

#------------------------------------------------------------------------------
note 'Add one movie, remove one movie';
$tmdb->stuff($tmdbs{3});

$wm->_update_watchlist($stash = {}, [ 1, 3 ]);

eq_or_diff($tmdb->args, [ 3 ], 'get_movie_info called once');
eq_or_diff(delete $stash->{added}, [ $tmdbs{3} ], 'one movie added');
eq_or_diff(movie_hashes(delete $stash->{deactivated}), [ $tmdbs{2} ],
    'one movie deactivated');
eq_or_diff($stash, { }, 'no extras in stash');
eq_or_diff([ searchlist_ids($wm) ], [ 1, 3 ], 'searchlist contains 1, 3');

#------------------------------------------------------------------------------
note 'Add one movie, reactivate one movie';
$tmdb->stuff($tmdbs{4});

$wm->_update_watchlist($stash = {}, [ 1, 2, 3, 4 ]);

eq_or_diff($tmdb->args, [ 4 ], 'get_movie_info called once');
eq_or_diff(delete $stash->{added}, [ $tmdbs{4} ], 'one movie added');
eq_or_diff(movie_hashes(delete $stash->{reactivated}), [ $tmdbs{2} ],
    'one movie reactivated');
eq_or_diff($stash, { }, 'no extras in stash');
eq_or_diff([ searchlist_ids($wm) ], [ 1 .. 4, ], 'searchlist contains 1 .. 4');

#------------------------------------------------------------------------------
note 'Update searchlist for one movie';
$nzbmatrix->stuff([ $nzbs{1}->[0], $nzbs{1}->[1] ]);

$wm->_run_searches($stash = {}, $wm->movies->search_rs({ tmdb_id => 1 }));

searches_made_is(1);
is(@{ $stash->{search_hits} }, 1, '1 movie with search hits');
is(@{ $stash->{search_hits}->[0]->{results} }, 2, '2 search hits');
delete $stash->{search_hits};
eq_or_diff($stash, { }, 'no extras in stash');

#------------------------------------------------------------------------------
note 'Re-run search with no extra hits';
$nzbmatrix->stuff([ $nzbs{1}->[0], $nzbs{1}->[1] ]);

$wm->_run_searches($stash = {}, $wm->movies->search_rs({ tmdb_id => 1 }));
searches_made_is(1);
eq_or_diff($stash, { }, 'no extras in stash');

#------------------------------------------------------------------------------
note 'Update searchlist with two movies';
$nzbmatrix->stuff([ $nzbs{1}->[2] ], [ $nzbs{2}->[0], $nzbs{2}->[1] ]);

$wm->_run_searches($stash = {}, $wm->movies->search_rs(
    { tmdb_id => { -in => [ 1, 2 ] } }, { order_by => 'tmdb_id' }));

searches_made_is(2);
is(@{ $stash->{search_hits} }, 2, '2 movies with search hits');
is(@{ $stash->{search_hits}->[0]->{results} }, 1, '1 search hit for movie 1');
is(@{ $stash->{search_hits}->[1]->{results} }, 2, '2 search hits for movie 2');
delete $stash->{search_hits};
eq_or_diff($stash, { }, 'no extras in stash');

#------------------------------------------------------------------------------
note 'First search fails';
$nzbmatrix->stuff([ $nzbs{2}->[2] ]);
$nzbmatrix->die_next;

$wm->_run_searches($stash = {}, $wm->movies->search_rs(
    { tmdb_id => { -in => [ 1, 2 ] } }, { order_by => 'tmdb_id' }));

searches_made_is(2);
is(@{ $stash->{search_hits} }, 1, '1 movies with search hits');
is(@{ $stash->{search_hits}->[0]->{results} }, 1, '1 search hit for movie 2');
delete $stash->{search_hits};
is(@{ $stash->{errors} }, 1, '1 error in stash');
like($stash->{errors}->[0], qr/search.*failed/, 'One search failure');
contains($stash->{errors}->[0], $movies[0]->{title}, 'Right movie failed');
delete $stash->{errors};
eq_or_diff($stash, { }, 'no extras in stash');

#------------------------------------------------------------------------------
note 'Fetch a watchlist';
$tmdb->stuff([ 0 .. 3 ]);

my $watchlist = $wm->_fetch_watchlist($stash = {});
eq_or_diff($watchlist, [0 .. 3], 'Watchlist as expected');
eq_or_diff($stash, { }, 'no extras in stash');

#------------------------------------------------------------------------------
note 'Fail while fetching a watchlist';
$tmdb->stuff([ 0 .. 3 ]);
$tmdb->die_next;

$watchlist = $wm->_fetch_watchlist($stash = {});
eq_or_diff($watchlist, undef, 'Watchlist is undef');
is(@{ $stash->{errors} }, 1, '1 error in stash');
like($stash->{errors}->[0], qr/watchlist failed/, 'One search failure');
delete $stash->{errors};
eq_or_diff($stash, { }, 'no extras in stash');

done_testing();
#------------------------------------------------------------------------------

sub subhashref {
    my ($hash, $keys) = @_;
    return { map { $_ => $hash->{$_} } @$keys };
}

sub movie_hashes {
    my ($movies) = @_;
    my @keys = qw( title year tmdb_id );
    return [ map { subhashref($_, \@keys) } @$movies ];
}

sub searches_made_is {
    my ($num_searches) = @_;
    my $msg = $num_searches == 1 ? 'search was' : 'searches were';
    my $new_searches = $nzbmatrix->searches_remaining;
    $TB->is_num($searches - $new_searches, $num_searches,
        "$num_searches $msg performed");
    $searches = $new_searches;
}

sub count_occurances {
    my ($string, $regex) = @_;
    my $count =()= $string =~ /$regex/g;
}

sub movie {
    state $next_id = 1;
    my $id = $next_id++;
    return {
        tmdb_id => $id,
        title   => sprintf("movie%03d", $id),
        year    => 1990 + $id,
    };
}

sub movies {
    my ($n) = @_;
    map { movie() } (1 .. $n);
}

sub result {
    my ($movie) = @_;
    state $next_nzbid = 1;
    my $id = $next_nzbid++;
    return {
        nzbid   => $id,
        nzbname => sprintf("%s (%d) %d", $movie->{title}, $movie->{year}, $id),
        link    => "link.to/$id",
    };
}

sub results {
    my ($movie, $count) = @_;
    map { result($movie) } (1 .. $count);
}

sub emails {
    Email::Sender::Simple->default_transport;
}

sub next_email {
    Email::Sender::Simple->default_transport->shift_deliveries->{email};
}

sub add_hours {
    my $hours = shift;
    Time::Fake->offset($timenow += $hours * 60 * 60);
}

sub searchlist_ids {
    my ($wm) = @_;
    sort $wm->movies->searchlist($age)->as_ids->get_column('tmdb_id')->all;
}

sub contains {
    my ($got, $substr, $msg) = @_;
    $msg //= "'$got' contains '$substr'";
    $TB->like($got, qr/\Q$substr\E/, $msg);

}
