use 5.12.0;
use warnings;
use Test::Most;

use lib 't/lib';
use Test::Mock::UserAgent;
use HTTP::Response;
use JSON;

use App::Watchman::TMDB;

# Stripped down version of the json data returned by tmdb
# Sufficient for our purposes
my @responses = (
    {
        page => 1,
        results => [ { id => 73 }, { id => 180 }, { id => 807 } ],
        total_pages => 1,
        total_results => 3
    },
    {
        title => "American History X",
        id => 73,
        release_date => "1977-12-27",
    },
    {
        title => "Minority Report",
        id => 180,
        release_date => "1927-12-27",
    },
    {
        title => "Se7en",
        id => 807,
        release_date => "1998-12-27",
    },
);


my $ua = Test::Mock::UserAgent->new( make_responses(@responses) );

my $tmdb = App::Watchman::TMDB->new(
    ua => $ua, session_id => 'testing', user_id => 'testing',
);

my $watchlist = $tmdb->get_watchlist;
eq_or_diff($watchlist, [ map { $_->{id} } @{ $responses[0]->{results} } ],
    'Watchlist as expected');

my $num_results = scalar @responses - 1;
for my $i (1 .. $num_results) {
    my $info = $tmdb->get_movie_info($watchlist->[$i-1]);
    my $expected = $responses[$i];

    is($info->{title}, $expected->{title}, "Title $i is ok");
    is($info->{tmdb_id}, $expected->{id}, "TMDB ID $i is ok");
    is($info->{year}, substr($expected->{release_date}, 0, 4), "Year $i is ok");
}

done_testing;

sub make_responses {
    map { HTTP::Response->new(200, 'OK', undef, encode_json($_)) } @_;
}
