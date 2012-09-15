package App::Watchman::Schema::ResultSet::Movie;

use 5.12.0;
use warnings;

# VERSION

use base 'App::Watchman::Schema::ResultSet';

use Method::Signatures;

method search_age_sec {     #TODO: this is clunky...
    return 24 * 60 * 60;
}

method as_hashes {
    return $self->search(undef, {
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            order_by => [qw( title year )],
        });
}

method update_watchlist ($watchlist) {

    my $removed_rs = $self->search( {
            active  => 1,
            tmdb_id => { -not_in => [ map { $_->{tmdb_id} } @$watchlist ] },
        });
    my @removed = $removed_rs->as_hashes->all;
    $removed_rs->update({ active => 0 });

    my @added;
    for my $movie (@$watchlist) {
        my $row = $self->find({ tmdb_id => $movie->{tmdb_id} });

        if (!$row) {
            # Insert movies which do not already exist.
            $self->create({
                tmdb_id => $movie->{tmdb_id},
                title   => $movie->{title},
                year    => $movie->{year},
            });
            push(@added, $movie);
        }
        elsif (!$row->active) {
            # Reactivate existing inactive movies.
            $row->update({ active => 1 });
            push(@added, $movie);
        }

    }

    return ( \@added, \@removed );
}

method fetch_searchlist {
    my $search_cutoff = time - $self->search_age_sec;

    my $searchlist_rs = $self->search({
            active => 1,
            last_searched => { '<=' => $search_cutoff },
        });
    return [ $searchlist_rs->as_hashes->all ];
}

1;
