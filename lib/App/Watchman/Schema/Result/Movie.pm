package App::Watchman::Schema::Result::Movie;

use 5.12.0;
use warnings;

# ABSTRACT: Movie result class
# VERSION

use base 'DBIx::Class::Core';

__PACKAGE__->table('movies');
__PACKAGE__->add_columns(
    tmdb_id =>
        { data_type => 'integer', is_nullable => 0 },
    title =>
        { data_type => 'text',    is_nullable => 0 },
    year =>
        { data_type => 'integer', is_nullable => 0 },
    last_searched =>
        { data_type => 'integer', is_nullable => 0, default_value => 0, },
    last_nzbid =>
        { data_type => 'integer', is_nullable => 0, default_value => 0, },
    active =>
        { data_type => 'boolean', is_nullable => 0, default_value => 1, },
);
__PACKAGE__->set_primary_key('tmdb_id');

1;
