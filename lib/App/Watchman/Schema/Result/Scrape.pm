package App::Watchman::Schema::Result::Scrape;

use 5.12.0;
use warnings;

# ABSTRACT: Scrape records the searching of an indexer for a movie
# VERSION

use base 'DBIx::Class::Core';

__PACKAGE__->table('scrapes');
__PACKAGE__->add_columns(
    movie_fk =>
        { data_type => 'integer', is_nullable => 0, is_foreign_key => 1, },
    indexer_fk =>
        { data_type => 'integer', is_nullable => 0, is_foreign_key => 1, },
    last_searched =>
        { data_type => 'integer', is_nullable => 0, default_value => 0, },
    last_nzbdate =>
        { data_type => 'integer', is_nullable => 0, default_value => 0, },
);
__PACKAGE__->set_primary_key(qw( movie_fk indexer_fk ));

__PACKAGE__->belongs_to(
    movie => 'App::Watchman::Schema::Result::Movie',
    { 'foreign.tmdb_id' => 'self.movie_fk' },
);

__PACKAGE__->belongs_to(
    indexer => 'App::Watchman::Schema::Result::Indexer',
    { 'foreign.indexer_id' => 'self.indexer_fk' },
);

1;
