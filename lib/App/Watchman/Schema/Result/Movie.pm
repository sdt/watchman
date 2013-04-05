package App::Watchman::Schema::Result::Movie;

use 5.12.0;
use warnings;

# ABSTRACT: Movie result class
# VERSION

use base 'DBIx::Class::Core';
use Method::Signatures;

use App::Watchman::Schema::ColumnTypes qw( Integer Text Boolean );

__PACKAGE__->table('movies');
__PACKAGE__->add_columns(
    tmdb_id => Integer,
    title   => Text,
    year    => Integer,
    active  => Boolean(default_value => 1),
);

__PACKAGE__->set_primary_key('tmdb_id');
__PACKAGE__->has_many(
    scrapes => 'App::Watchman::Schema::Result::Scrape',
    { 'foreign.movie_fk' => 'self.tmdb_id' },
);

method name {
    return $self->title . ' ' . $self->year;
}

1;
