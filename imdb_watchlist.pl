#!/usr/bin/env perl

use 5.12.0;
use warnings;

use Data::Dumper::Concise;
use Text::CSV::Slurp;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new;
$mech->agent_alias('Linux Mozilla');

$mech->get('https://secure.imdb.com/oauth/login?origurl=http://www.imdb.com/');
$mech->submit_form(with_fields => {
        login    => $ENV{IMDB_EMAIL},
        password => $ENV{IMDB_PASSWORD},
    });

$mech->get('http://www.imdb.com/list/watchlist');
$mech->follow_link(text => 'Export this list');

my $data = Text::CSV::Slurp->load(string => $mech->content);
print Dumper($data);
