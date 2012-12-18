use 5.12.0;
use warnings;
use Test::More;

use File::Temp;
use Config::General qw( SaveConfig );

use App::Watchman;

my $config_fh = File::Temp->new;
SaveConfig($config_fh->filename, {
    email => { to => 'xxx@yyy.zzz' },
    tmdb => { session => 'xxx', user => 'xxx' },
    newznab => { apikey => 'xxx', base_uri => 'http://test.com/' },
    dbname => ':memory:',
});
$ENV{WATCHMANRC} = $config_fh->filename;

my $wm = App::Watchman->new;
isa_ok($wm->mailer,         'App::Watchman::Mailer');
isa_ok($wm->newznab,        'App::Watchman::Newznab');
isa_ok($wm->newznab->ua,    'LWP::UserAgent');
isa_ok($wm->tmdb,           'App::Watchman::TMDB');
isa_ok($wm->tmdb->ua,       'LWP::UserAgent');
isa_ok($wm->schema,         'App::Watchman::Schema');

done_testing;
