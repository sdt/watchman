package App::Watchman::Schema::Result::Indexer;

use 5.12.0;
use warnings;

# ABSTRACT: Indexer class
# VERSION

use base 'DBIx::Class::Core';
use Method::Signatures;

__PACKAGE__->table('indexers');
__PACKAGE__->add_columns(
    indexer_id =>
        { data_type => 'integer', is_nullable => 0, is_auto_increment => 1 },
    base_uri =>
        { data_type => 'text',    is_nullable => 0 },
    apikey =>
        { data_type => 'integer', is_nullable => 0 },
    active =>
        { data_type => 'boolean', is_nullable => 0, default_value => 1, },
);
__PACKAGE__->set_primary_key('indexer_id');
__PACKAGE__->has_many(
    scrapes => 'App::Watchman::Schema::Result::Scrape',
    { 'foreign.indexer_fk' => 'self.indexer_id' },
);

method insert (@args) {
    my $schema = $self->result_source->schema;
    my $guard = $schema->txn_scope_guard;

    $self->next::method(@args);
    my $movies = $schema->resultset('Movie');
    while (my $movie = $movies->next) {
        $self->create_related(scrapes => { movie => $movie });
    }

    $guard->commit;

    return $self;
}

1;
