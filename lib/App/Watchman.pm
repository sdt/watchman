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

use Method::Signatures;
use Moose;

has [qw( config mailer schema tmdb nzbmatrix )] => (
    is => 'ro',
    lazy_build => 1,
);

method run {
    # Ask TMDB for the current watchlist
    my $watchlist = $self->tmdb->watchlist;

    # Update the DB with the current watchlist
    my ($added, $removed) = $self->schema->update_watchlist($watchlist);

    # Add added and updated movies to email notification

    # Get a list of movies that are due for a search
    my $searchlist = $self->schema->fetch_searchlist;

    my @new_hits;

    # For each movie in the search list, update the search results
    for my $movie (@$searchlist) {
        my $title = $movie->{title} . ' ' . $movie->{year};
        my $results = $self->nzbmatrix->search($title);

        my @new_results;

        for my $result (@$results) {
            if ($result->{nzbid} > $movie->{last_nzbid}) {
                push(@new_results, $result);
            }
        }

        if (@new_results) {
            $movie->{last_nzbid} = max map { $_->{nzbid} } @$results;
            push(@new_hits, {
                movie => $movie,
                results => \@new_results,
            });
        }
    }

    $self->schema->update_searchlist(map { $_->{movie} } @new_hits);

    my $email = $self->format_email(
        added => $added,
        removed => $removed,
        new_hits => \@new_hits,
    );

    print $email;

    if ($email) {
        $self->mailer->send(body => $email);
    }
}

method format_email (:$added, :$removed, :$new_hits) {

    my $body = '';

    if (@$added) {
        $body .= "New movies added to watchlist\n\n";

        for my $movie (@$added) {
            $body .= format_movie_info($movie);
        }

        $body .= "\n\n";
    }

    if (@$removed) {
        $body .= "Movies removed from watchlist\n\n";

        for my $movie (@$removed) {
            $body .= format_movie_info($movie);
        }

        $body .= "\n\n";
    }

    if (@$new_hits) {

        $body .= "New search results\n\n";

        for my $hit (@$new_hits) {

            $body .= format_movie_info($hit->{movie});
            for my $result (@{ $hit->{results} }) {
                $body .= format_search_result($result);
            }

            $body .= "\n";
        }
    }

    return $body;
}

func format_movie_info ($movie) {
    return sprintf("* %s (%d) http://www.themoviedb.org/movie/%d\n",
        $movie->{title}, $movie->{year}, $movie->{tmdb_id}
    );
}

func format_search_result ($result) {
    return sprintf("\t* %s http://%s\n",
        $result->{nzbname}, $result->{link}
    );
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

sub _set_handlers {
    my %h = @_;
    while (my ($attr, $handlers) = each %h) {
        has "+$attr" => ( handles => $handlers );
    }
}

1;

__END__

=head1 DESCRIPTION

Main application class.

=head1 SYNOPSIS

    my $watchman = App::Watchman->new;
    $watchman->run;

=cut
