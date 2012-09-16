package App::Watchman::TMDB;

use 5.12.0;
use warnings;

# ABSTRACT: tmdb watchlist scraper
# VERSION

use Log::Any qw( $log );
use LWP::UserAgent;
use WWW::TMDB::API;

use Method::Signatures;
use Moose;
use namespace::autoclean;

my $api_key = 'd83ccf1c8c6ca49a86fe647198323b38';

has [qw( user_id session_id )] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has [qw( api ua )] => (
    is => 'ro',
    lazy_build => 1,
);

method _build_api {
    WWW::TMDB::API->new( api_key => $api_key, ua => $self->ua );
}

method _build_ua {
    LWP::UserAgent->new
}

method get_watchlist {
    $log->info('Fetching watchlist from TMDB');
    my $results = $self->api->send_api(
        [ account => $self->user_id, 'movie_watchlist' ],
        { session_id => 1 }, { session_id => $self->session_id }
    );

    return [ sort { $a <=> $b } map { $_->{id} } @{ $results->{results} } ];
}

method get_movie_info ($tmdb_id) {
    $log->info("Fetching movie info for #$tmdb_id");
    my $info = $self->api->movie->info( ID => $tmdb_id );
    return {
        tmdb_id => $info->{id},
        title   => $info->{title},
        year    => substr($info->{release_date}, 0, 4),
    };
}

__PACKAGE__->meta->make_immutable;
1;
