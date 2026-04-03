package App::Watchman::TMDB;
use v5.34;
use warnings;

# ABSTRACT: tmdb watchlist scraper
our $VERSION = '0.022'; # VERSION

use Log::Any qw( $log );
use LWP::UserAgent;
use WWW::TMDB::API;

use Function::Parameters qw( :strict classmethod );
use Moo;
use MooX::Types::MooseLike::Base qw( Str );
use namespace::autoclean;

my $api_key = 'd83ccf1c8c6ca49a86fe647198323b38';

has [qw( user_id session_id )] => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has [qw( api ua )] => (
    is => 'lazy',
);

method _build_api() {
    my $api = WWW::TMDB::API->new( api_key => $api_key, ua => $self->ua );
    $api->{url} =~ s/http:/https:/;
    return $api;
}

method _build_ua() {
    LWP::UserAgent->new
}

method get_watchlist() {
    $log->info('Fetching watchlist from TMDB');

    my @ids;
    for (my $page = 1; ; $page++) {
        my $results = $self->api->send_api(
            [ account => $self->user_id, 'movie_watchlist' ],
            { session_id => 1, page => 0 },
            { page => $page, session_id => $self->session_id }
        );

        push(@ids, map { $_->{id} } @{ $results->{results} });
        last if $results->{page} == $results->{total_pages};
    }

    return [ sort { $a <=> $b } @ids ];
}

method get_movie_info ($tmdb_id) {
    $log->info("Fetching movie info for #$tmdb_id");
    my $info = $self->api->movie->info( ID => $tmdb_id );
    return {
        tmdb_id  => $info->{id},
        imdb_id  => $info->{imdb_id} =~ s/^tt//r,
        title    => $info->{title},
        year     => substr($info->{release_date}, 0, 4),
    };
}

method movie_uri ($tmdb_id) {
    return "http://www.themoviedb.org/movie/$tmdb_id";

}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::TMDB - tmdb watchlist scraper

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
