use 5.12.0;
use warnings;
use Test::Most;
use Test::FailWarnings;

use lib 't/lib';
use Test::Mock::UserAgent;
use HTTP::Response;
use JSON;

use App::Watchman::TMDB;

# Stripped down version of the json data returned by tmdb
# Sufficient for our purposes
my @watchlist_responses = (
    {
        page => 1,
        results => [ { id => 73 }, { id => 180 }, { id => 666 } ],
        total_pages => 2,
        total_results => 4,
    },
    {
        page => 2,
        results => [ { id => 807 }, ],
        total_pages => 2,
        total_results => 4,
    },
);

my @info_responses = (
    {
        title => "Title 73",
        id => 73,
        release_date => "1977-12-27",
        imdb_id => 'tt073',
    },
    {
        title => "Title 180",
        id => 180,
        release_date => "1927-12-27",
        imdb_id => 'tt0180',
    },
    {
        title => "Title 666",
        id => 666,
        release_date => "1955-12-27",
        imdb_id => 'tt0666',
    },
    {
        title => "Title 807",
        id => 807,
        release_date => "1998-12-27",
        imdb_id => 'tt0807',
    },
);


my $ua = Test::Mock::UserAgent->new( make_responses(@watchlist_responses) );

my $tmdb = App::Watchman::TMDB->new(
    ua => $ua, session_id => 'testing', user_id => 'testing',
);

my $watchlist = $tmdb->get_watchlist;
eq_or_diff($watchlist, [ map { $_->{id} } @info_responses ],
    'Watchlist as expected');

is(scalar @$ua, 0, 'All pages fetched');

# We expect that the watchlist will have been consumed at this point, but lets
# resync here anyway in case it hasn't.
$ua->set_results(make_responses(@info_responses));

for my $i (0 .. $#info_responses) {
    my $info = $tmdb->get_movie_info($watchlist->[$i-1]);
    my $expected = $info_responses[$i];

    isnt($info, undef, "Got info for movie $i");

    is($info->{title}, $expected->{title}, "Title $i is ok");
    is($info->{tmdb_id}, $expected->{id}, "TMDB ID $i is ok");
    is($info->{year}, substr($expected->{release_date}, 0, 4), "Year $i is ok");
    is($info->{imdb_id}, '0' . $expected->{id}, "TMDB ID $i is ok");
}

done_testing;

sub make_responses {
    map { HTTP::Response->new(200, 'OK', undef, encode_json($_)) } @_;
}
