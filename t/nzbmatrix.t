use 5.12.0;
use warnings;
use Test::Most;

use lib 't/lib';
use Test::Mock::UserAgent;
use HTTP::Headers;
use HTTP::Response;

use App::Watchman::NZBMatrix;

my $good_data = <<'END_DATA';
NZBID:111;
NZBNAME:Movie 1;
WEBLINK:http://site.com/1/;
CATEGORY:Movies > Testing;
|
NZBID:222;
NZBNAME:Movie 2;
WEBLINK:http://site.com/2/;
CATEGORY:Movies > Testing;
|
NZBID:333;
NZBNAME:Movie 3;
WEBLINK:http://site.com/3/;
CATEGORY:Skipped;
|
END_DATA

my $ua = Test::Mock::UserAgent->new;
my $tmdb = App::Watchman::NZBMatrix->new(
    ua => $ua, apikey => 'testing', username => 'testing',
);
my $searches_remaining = 55;

note 'Check good data';
$ua->add_results( make_responses($good_data) );
my $results = $tmdb->search('xxx');

is(scalar @$results, 2, 'Two search results');
eq_or_diff([ map { $_->{nzbid}   } @$results ],
           [ 111, 222 ], 'Ids match');
eq_or_diff([ map { $_->{nzbname} } @$results ],
           [ map { "Movie $_" } (1 .. 2) ], 'Names match');
eq_or_diff([ map { $_->{weblink} } @$results ],
           [ map { "http://site.com/$_/" } (1 .. 2) ], 'Links match');

is($tmdb->searches_remaining, $searches_remaining,
    "$searches_remaining searches remain");

note 'Check no results';
$ua->add_results( make_responses('error:nothing_found') );
$results = $tmdb->search('xxx');
eq_or_diff($results, [ ], 'No results');
is($tmdb->searches_remaining, $searches_remaining,
    "$searches_remaining searches remain");

note 'Check other error';
$ua->add_results( make_responses('error:something') );
throws_ok { $tmdb->search('xxx') } qr/something/;
is($tmdb->searches_remaining, $searches_remaining,
    "$searches_remaining searches remain");

note 'Check failure';
$ua->add_results(HTTP::Response->new(500, 'FAIL'));
throws_ok { $tmdb->search('xxx') } qr/FAIL/;

note 'Check out of searches';
$tmdb->_set_searches_remaining(0);
throws_ok { $tmdb->search('xxx') } qr/rate limit exceeded/;

done_testing;

sub make_header {
    my $header = HTTP::Headers->new;
    $header->{api_rate_limit_left} = --$searches_remaining;
    return $header;
}

sub make_responses {
    map { HTTP::Response->new(200, 'OK', make_header(), $_) } @_;
}
