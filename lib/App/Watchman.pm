package App::Watchman;

use 5.12.0;
use warnings;

# ABSTRACT: watch for interesting posts and notify about them
# VERSION

use App::Watchman::Config;
use App::Watchman::EmailFormatter;
use App::Watchman::Mailer;
use App::Watchman::Schema;
use App::Watchman::TMDB;

use Log::Any qw( $log );
use LWP::UserAgent;
use Method::Signatures;
use Moo;
use namespace::autoclean;
use Try::Tiny;

has [qw( config mailer schema tmdb search_min_age ua )] => (
    is => 'lazy',
);

method run {
    my $stash = {};

    if (my $watchlist = $self->_fetch_watchlist($stash)) {
        $self->_update_watchlist($stash, $watchlist);
    }

    my $searchlist = $self->_get_searchlist;
    $self->_run_searches($stash, $searchlist);

    if (%$stash) {
        $self->_augment_stash($stash);
        $self->mailer->send(body =>
            App::Watchman::EmailFormatter::format_email($stash));
    }
}

method _fetch_watchlist($stash) {
    my $watchlist;
    try {
        $watchlist = $self->tmdb->get_watchlist;
    }
    catch {
        push(@{ $stash->{errors} }, "Get TMDb watchlist failed: $_");
    };
    return $watchlist;
}

method _update_watchlist($stash, $watchlist) {

    # Ask TMDB for the current watchlist
    $log->info(scalar @$watchlist, ' items in watchlist');

    my $movies_rs = $self->schema->resultset('Movie');

    my %seen;
    my $deactivated = $movies_rs->deactivated(@$watchlist);
    if ($deactivated->count > 0) {
        $stash->{deactivated} = [ $deactivated->sorted->as_hashes->all ];
        $deactivated->update({ active => 0 });
    }

    my $reactivated = $movies_rs->reactivated(@$watchlist);
    if ($reactivated->count > 0) {
        $stash->{reactivated} = [ $reactivated->sorted->as_hashes->all ];
        $reactivated->update({ active => 1 });
    }

    my @added;
    for my $id (@$watchlist) {
        next if $movies_rs->find({ tmdb_id => $id });

        my $movie = $self->tmdb->get_movie_info($id);
        $movies_rs->create($movie);
        push(@added, $movie);
    }

    $stash->{added} = \@added if @added;
}

method _run_searches($stash, $searchlist) {

    $log->info(scalar @$searchlist, ' items in searchlist');
    my @new_hits;

    # For each movie in the search list, update the search results
    for my $scrape (@$searchlist) {
        my @results;
        try {
            @results = $scrape->run($self->ua);
        }
        catch {
            push(@{ $stash->{errors} }, $_);
        };
        next unless @results;

        push(@new_hits, {
            movie => { $scrape->movie->get_columns },
            results => \@results,
        });

        $log->info(scalar @results, " new hits for ", $scrape->movie->name);
    }

    $stash->{search_hits} = \@new_hits if @new_hits;
}

method _get_searchlist {

    my @movies = $self->resultset('Movie')
                      ->search({ active => 1 })
                      ->get_column('tmdb_id')
                      ->all;

    my @indexers = $self->resultset('Indexer')
                        ->search({ active => 1 })
                        ->get_column('indexer_id')
                        ->all;

    my $scrapes = $self->resultset('Scrape');
    my @searchlist;
    my $cutoff = time - $self->search_min_age;

    for my $movie_id (@movies) {
        for my $indexer_id (@indexers) {
            my $scrape = $scrapes->find_or_new({
                movie_fk => $movie_id,
                indexer_fk => $indexer_id,
            });
            next if $scrape->last_searched > $cutoff;
            push(@searchlist, $scrape);
        }
    }
    return \@searchlist;
}

method _augment_stash ($stash) {
    for (qw( added deactivated reactivated )) {
        for my $movie (@{ $stash->{$_} // [] }) {
            $self->_augment_movie($movie);
        }
    }

    for (@{ $stash->{search_hits} // []}) {
        $self->_augment_movie($_->{movie});
    }
}

method _augment_movie ($movie) {
    $movie->{nzbsearch_uri} = 'TODO';
#    $movie->{nzbsearch_uri} = $self->newznab->search_uri($movie->{name});

    $movie->{tmdb_uri} = $self->tmdb->movie_uri($movie->{tmdb_id});
}

# Builder methods

method _build_search_min_age {
    my $cfg = $self->config;
    return ( $cfg->{search_min_hours} // 24 ) * 60 * 60;
}

method _build_config {
    return App::Watchman::Config->load();
}

method _build_mailer {
    my $cfg = $self->config->{email};
    return App::Watchman::Mailer->new(
        to   => $cfg->{to},
        from => $cfg->{from} // $cfg->{to},
    );
}

method _build_schema {
    my $cfg = $self->config;
    return App::Watchman::Schema->new(
        filename    => $cfg->{dbfile} // 'watchman.db',
    );
}

method _build_tmdb {
    my $cfg = $self->config->{tmdb};
    return App::Watchman::TMDB->new(
        session_id => $cfg->{session},
        user_id    => $cfg->{user},
    );
}

method _build_ua {
    return LWP::UserAgent->new;
}

1;

__END__

=head1 DESCRIPTION

Main application class.

=head1 SYNOPSIS

    my $watchman = App::Watchman->new;
    $watchman->run;

=cut
