use 5.12.0;
use warnings;
use Test::More;

use App::Watchman;

#XXX: create fake config file
my $config = {
    email => { to => 'xxx@yyy.zzz' },
    tmdb => { session => 'xxx', user => 'xxx' },
    nzbmatrix => { apikey => 'xxx', user => 'xxx' },
    dbname => ':memory:',
};

my $wm = App::Watchman->new(config => $config);
isa_ok($wm, 'App::Watchman');
isa_ok($wm->mailer,         'App::Watchman::Mailer');
isa_ok($wm->nzbmatrix,      'App::Watchman::NZBMatrix');
isa_ok($wm->nzbmatrix->ua,  'LWP::UserAgent');
isa_ok($wm->tmdb,           'App::Watchman::TMDB');
isa_ok($wm->tmdb->ua,       'LWP::UserAgent');
isa_ok($wm->schema,         'App::Watchman::Schema');

done_testing;
