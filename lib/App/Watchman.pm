package App::Watchman;

use 5.12.0;
use warnings;

# ABSTRACT: watch for interesting posts and notify about them
# VERSION

use List::Util qw( max );

use App::Watchman::Config;
use App::Watchman::Mailer;
use App::Watchman::NZBMatrix;
use App::Watchman::Schema;
use App::Watchman::TMDB;
use Log::Any qw( $log );
use URI::Escape;
use Try::Tiny;

use Method::Signatures;
use Moose;
use namespace::autoclean;

has [qw( config mailer schema tmdb nzbmatrix )] => (
    is => 'ro',
    lazy_build => 1,
);

has search_min_age => (
    is => 'ro',
    isa => 'Int',
    default => 24 * 60 * 60,
);

method movies {
    #TODO: is this necessary, can run keep the same resultset?
    return $self->schema->resultset('Movie');
}

method run {
    my $stash = {};

    if (my $watchlist = $self->_fetch_watchlist($stash)) {
        $self->_update_watchlist($stash, $watchlist);
    }

    my $searchlist = $self->movies->searchlist($self->search_min_age);
    $self->_run_searches($stash, $searchlist);

    if (%$stash) {
        $self->mailer->send(body => $self->_format_email($stash));
    }

    $log->info($self->nzbmatrix->searches_remaining, ' searches remaining');
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

    my %seen;
    my $deactivated = $self->movies->deactivated(@$watchlist);
    if ($deactivated->count > 0) {
        $stash->{deactivated} = [ $deactivated->sorted->as_hashes->all ];
        $deactivated->update({ active => 0 });
    }

    my $reactivated = $self->movies->reactivated(@$watchlist);
    if ($reactivated->count > 0) {
        $stash->{reactivated} = [ $reactivated->sorted->as_hashes->all ];
        $reactivated->update({ active => 1 });
    }

    my @added;
    for my $id (@$watchlist) {
        next if $self->movies->find({ tmdb_id => $id });

        my $movie = $self->tmdb->get_movie_info($id);
        $self->movies->create($movie);
        push(@added, $movie);
    }

    $stash->{added} = \@added if @added;
}

method _run_searches($stash, $searchlist) {

    $log->info($searchlist->count, ' items in searchlist');

    my @new_hits;
    my $now = time;

    # For each movie in the search list, update the search results
    while (my $movie = $searchlist->next) {
        my $title = $movie->title . ' ' . $movie->year;
        my $results;
        try {
            $results = $self->nzbmatrix->search($title);
        }
        catch {
            push(@{ $stash->{errors} }, "NZBMatrix search '$title' failed: $_");
        };
        next unless $results;

        @$results = grep { $_->{nzbid} > $movie->last_nzbid } @$results;
        if (@$results) {
            $movie->set_column(last_nzbid => max map { $_->{nzbid} } @$results);
            push(@new_hits, {
                movie => $movie,
                results => $results,
            });

            $log->info(scalar $results, " new hits for $title");
        }

        $movie->update({ last_searched => $now });
    }

    $stash->{search_hits} = \@new_hits if @new_hits;
}

method _format_email($stash) {

    my $body = '';

    $body .= format_movie_list($stash->{added},
        '++', 'New movies added');
    $body .= format_movie_list($stash->{reactivated},
        '-+', 'Old movies reactivated');
    $body .= format_movie_list($stash->{deactivated},
        '--', 'Movies deactivated');

    if ($stash->{search_hits}) {
        $body .= "New search results\n\n";
        for my $hit (@{ $stash->{search_hits} }) {

            $body .= format_search_query($hit->{movie});
            for my $result (@{ $hit->{results} }) {
                $body .= format_search_result($result);
            }

            $body .= "\n";
        }
    }

    if ($stash->{search_hits}) {
        $body .= "Errors occurred\n\n";

        for my $error (@{ $stash->{errors} }) {
            $body .= format_error($error);
        }
        $body .= "\n";
    }

    return $body;
}

func format_movie_list ($list, $prefix, $msg) {
    return '' unless $list;

    my $text = "$msg\n\n";
    for my $movie (@$list) {
        $text .= format_movie_info($prefix, $movie);
    }
    $text .= "\n\n";
    return $text;
}

func format_movie_info ($prefix, $movie) {
    return sprintf("$prefix %s (%d) http://www.themoviedb.org/movie/%d\n",
        $movie->{title}, $movie->{year}, $movie->{tmdb_id}
    );
}

func format_search_query ($movie) {
    return sprintf(
        "** %s (%d) http://nzbmatrix.com/nzb-search.php?search=%s\n",
        $movie->title, $movie->year,
        uri_escape($movie->title . ' ' . $movie->year),
    );
}

func format_search_result ($result) {
    return sprintf("\t* %s http://%s\n",
        $result->{nzbname}, $result->{link}
    );
}

func format_error ($error) {
    return sprintf("\t* %s\n", $error);
}

# Builder methods

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

method _build_nzbmatrix {
    my $cfg = $self->config->{nzbmatrix};
    return App::Watchman::NZBMatrix->new(
        apikey      => $cfg->{apikey},
        username    => $cfg->{user},
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

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 DESCRIPTION

Main application class.

=head1 SYNOPSIS

    my $watchman = App::Watchman->new;
    $watchman->run;

=cut
