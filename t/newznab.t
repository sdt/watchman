use 5.12.0;
use warnings;
use Test::Most;
use Test::FailWarnings;

use lib 't/lib';
use Test::Mock::UserAgent;
use HTTP::Headers;
use HTTP::Response;
use JSON;

use App::Watchman::Newznab;

my $good_data = { channel => { item => [
    {
        title => 'Movie 2',
        guid => 'http://site.com/2/',
        pubDate => 'Fri, 16 Nov 2012 17:03:58 +0000',
    },
    {
        title => 'Movie 1',
        guid => 'http://site.com/1/',
        pubDate => 'Sun, 18 Nov 2012 17:03:58 +0000',
    },
]}};

my $single_data = { channel => { item =>
    {
        title => 'Movie 3',
        guid => 'http://site.com/3/',
        pubDate => 'Sat, 17 Nov 2012 17:03:58 +0000',
    },
}};

my $ua = Test::Mock::UserAgent->new;
my $tmdb = App::Watchman::Newznab->new(
    ua => $ua, apikey => 'testing', base_uri => 'http://test.test',
);

note 'Check good data';
$ua->add_results( make_responses($good_data) );
my $results = $tmdb->search('xxx');

is(scalar @$results, 2, 'Two search results');
#eq_or_diff([ map { $_->{nzbid}   } @$results ],
#           [ 111, 222 ], 'Ids match');
eq_or_diff([ map { $_->{name} } @$results ],
           [ map { "Movie $_" } (1 .. 2) ], 'Names match');
eq_or_diff([ map { $_->{link} } @$results ],
           [ map { "http://site.com/$_/" } (1 .. 2) ], 'Links match');

note 'Check single search result';
$ua->add_results( make_responses($single_data) );
$results = $tmdb->search('xxx');

is(scalar @$results, 1, 'One search result');
is($results->[0]->{name}, 'Movie 3', 'Name matches');
is($results->[0]->{link}, 'http://site.com/3/', 'Link matches');

note 'Check no results';
$ua->add_results( make_responses({}) );
$results = $tmdb->search('xxx');
eq_or_diff($results, [ ], 'No results');

#note 'Check other error';
#$ua->add_results( make_responses('error:something') );
#throws_ok { $tmdb->search('xxx') } qr/something/;

note 'Check failure';
$ua->add_results(HTTP::Response->new(500, 'FAIL'));
throws_ok { $tmdb->search('xxx') } qr/FAIL/;

done_testing;

sub make_header {
    my $header = HTTP::Headers->new;
    return $header;
}

sub make_responses {
    map { HTTP::Response->new(200, 'OK', make_header(), encode_json($_)) } @_;
}
