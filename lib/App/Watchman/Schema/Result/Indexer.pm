package App::Watchman::Schema::Result::Indexer;

use 5.12.0;
use warnings;

# ABSTRACT: Indexer class
# VERSION

use base 'DBIx::Class::Core';
use Method::Signatures;

use App::Watchman::Schema::ColumnTypes qw( PrimaryKey Integer Text Boolean );

__PACKAGE__->table('indexers');
__PACKAGE__->add_columns(
    indexer_id  => PrimaryKey,
    name        => Text,
    base_uri    => Text,
    apikey      => Integer,
    active      => Boolean(default_value => 1),
);

__PACKAGE__->set_primary_key('indexer_id');
__PACKAGE__->has_many(
    scrapes => 'App::Watchman::Schema::Result::Scrape',
    { 'foreign.indexer_fk' => 'self.indexer_id' },
);
__PACKAGE__->add_unique_constraint([qw( name )]);
__PACKAGE__->add_unique_constraint([qw( base_uri )]);

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
