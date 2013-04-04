package App::Watchman::Schema::ResultSet::Movie;

use 5.12.0;
use warnings;

# ABSTRACT: Movie resultset class
# VERSION

use base 'App::Watchman::Schema::ResultSet';
use Method::Signatures;

method sorted {
    $self->search_rs(undef, { order_by => [qw( title year )] });
}

method as_ids {
    return $self->search(undef, {
            select => [qw( tmdb_id )],
        });
}

method deactivated(@tmdb_ids) {
    $self->search({
            active  => 1,
            tmdb_id => { -not_in => \@tmdb_ids },
        })->sorted;
}

method reactivated(@tmdb_ids) {
    $self->search({
            active  => 0,
            tmdb_id => { -in => \@tmdb_ids },
        })->sorted;
}

1;
