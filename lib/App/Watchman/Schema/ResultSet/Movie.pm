package App::Watchman::Schema::ResultSet::Movie;

use 5.12.0;
use warnings;

# VERSION

use base 'App::Watchman::Schema::ResultSet';

use Method::Signatures;

method as_hashes {
    return $self->search(undef, {
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });
}

method as_ids {
    return $self->search(undef, {
            select => [qw( tmdb_id )],
        });
}

method sorted {
    $self->search_rs(undef, { order_by => [qw( title year )] });
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

method searchlist($search_min_age) {
    my $search_cutoff = time - $search_min_age;
    $self->search({
            active        => 1,
            last_searched => { '<=' => $search_cutoff },
        })->sorted;
}

1;
