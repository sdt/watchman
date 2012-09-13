package App::Watchman::Schema::Result::Version;

use 5.12.0;
use warnings;

# VERSION

use base 'DBIx::Class::Core';

__PACKAGE__->table('version');
__PACKAGE__->add_columns(
    version => { data_type => 'integer', is_nullable => 0 },
);
__PACKAGE__->set_primary_key('version');

1;
