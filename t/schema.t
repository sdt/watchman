use 5.12.0;
use warnings;
use Test::Most;

use App::Watchman::Schema;

my $schema = App::Watchman::Schema->connect('DBI:SQLite::memory:');
ok($schema);

$schema->_install;

$schema->resultset('Version')->create({ version => 3 });
$schema->resultset('Version')->create({ version => 2 });

is($schema->installed_version, 3);

$schema = App::Watchman::Schema->new(filename => ':memory:');
is($schema->installed_version, 1);

done_testing;
