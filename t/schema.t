use 5.12.0;
use warnings;
use Test::Most;
use Test::FailWarnings;

use App::Watchman::Schema;

my $schema;

note 'One movie, one indexer'; {
    $schema = App::Watchman::Schema->new(filename => ':memory:');

    rs('Movie')->create(movie(1));
    rs('Indexer')->create(indexer(1));
    my $scrape = rs('Scrape')->find_or_new({movie_fk => 1, indexer_fk => 1});
    ok(!$scrape->in_storage);

    $scrape->last_searched(666);
    $scrape->update_or_insert;
    ok($scrape->in_storage);
#    $scrape->update({ last_searched => 777 });
}

#
#
#note 'Create movies, then indexers'; {
#    $schema = App::Watchman::Schema->new(filename => ':memory:');
#    for (1 .. 4) {
#        rs('Movie')->create(movie($_));
#        eq_or_diff(table('Movie'), [ movie_rows(1 .. $_) ],
#            "Add movie $_" );
#    }
#    for (1 .. 4) {
#        rs('Indexer')->create(indexer($_));
#        eq_or_diff(table('Indexer'), [ indexer_rows(1 .. $_) ],
#            "Add indexer $_" );
#        is(rs('Scrape')->count, 4 * $_, "Scrapes ok");
#    }
#}
#
#note 'Create indexers, then movies'; {
#    $schema = App::Watchman::Schema->new(filename => ':memory:');
#    for (1 .. 4) {
#        rs('Indexer')->create(indexer($_));
#        eq_or_diff(table('Indexer'), [ indexer_rows(1 .. $_) ],
#            "Indexer $_" );
#    }
#    for (1 .. 4) {
#        rs('Movie')->create(movie($_));
#        eq_or_diff(table('Movie'), [ movie_rows(1 .. $_) ],
#            "Add movie $_" );
#        is(rs('Scrape')->count, 4 * $_, "Scrapes ok");
#    }
#}
#
#rs('Scrape')->find({ movie_fk => 1, indexer_fk => 1 })->delete;
##is(rs('Scrape')->searchlist(time)->count, 16);
#
#    my @movie_ids = rs('Movie')->get_column('tmdb_id')->all;
#
#
#use Data::Printer; p rs('Movie')->result_source->primary_columns;
##use Data::Dumper::Concise; print STDERR Dumper(
##    \@movie_ids
##);
#
pass('ok');
done_testing;

sub rs {
    my ($name) = @_;
    return $schema->resultset($name);
}

sub table {
    my ($name) = @_;
    return [ rs($name)->as_hashes->all ];
}

sub movie {
    my ($id) = @_;
    return {
        tmdb_id => $id,
        title   => "Movie-$id",
        year    => 1940 + $id,
    };
}

sub movie_rows {
    return map { {
        %{ movie($_) },
        active => 1,
    } } @_;
}

sub indexer {
    my ($id) = @_;
    return {
        name     => "Indexer-$id",
        base_uri => "http://search-$id",
        apikey   => "$id$id$id",
    };
}

sub indexer_rows {
    return map { {
        %{ indexer($_) },
        indexer_id => $_,
        active => 1,
    } } @_;
}

sub scrapes {
    my ($movies, $indexers) = @_;

    my @scrapes;
    for my $indexer (1 .. $indexers) {
        for my $movie (1 .. $movies) {
            push(@scrapes, {
                movie_fk => $movie,
                indexer_fk => $indexer,
                last_searched => 0,
                last_nzbdate => 0,
            });
        }
    }
    return \@scrapes;
}
