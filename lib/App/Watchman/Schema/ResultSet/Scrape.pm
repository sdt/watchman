package App::Watchman::Schema::ResultSet::Scrape;

use 5.12.0;
use warnings;

# ABSTRACT: Movie resultset class
# VERSION

use base 'App::Watchman::Schema::ResultSet';
use Method::Signatures;

method searchlist($search_min_age) {
    my $search_cutoff = time - $search_min_age;
    $self->search(
        {
            'movie.active'      => 1,
            'indexer.active'    => 1,
            last_searched       => { '<=' => $search_cutoff },
        },
        {
            prefetch => [qw( indexer movie )],
        })->sorted;
}

1;
