package App::Watchman::TMDB;

use 5.12.0;
use warnings;

# ABSTRACT: tmdb watchlist scraper
# VERSION

use WWW::TMDB::API;

use Method::Signatures;
use Moose;

my $api_key = 'd83ccf1c8c6ca49a86fe647198323b38';

has [qw( user_id session_id )] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has [qw( api watchlist )] => (
    is => 'ro',
    lazy_build => 1,
);

method _build_api {
    WWW::TMDB::API->new( api_key => $api_key );
}

method _build_watchlist {
    my $results = $self->api->send_api(
        [ account => $self->user_id, 'movie_watchlist' ],
        { session_id => 1 }, { session_id => $self->session_id }
    );

    my @watchlist;
    for my $movie (@{ $results->{results} }) {

        my $info = $self->api->movie->info( ID => $movie->{id} );
        push(@watchlist, {
            tmdb_id => $info->{id},
            title   => $info->{title},
            year    => substr($info->{release_date}, 0, 4),
        });
    }

    return \@watchlist;
}

1;
