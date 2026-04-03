package App::Watchman::Schema::Result::Movie;
use v5.34;
use warnings;

# ABSTRACT: Movie result class
our $VERSION = '0.022'; # VERSION

use base 'DBIx::Class::Core';

__PACKAGE__->table('movies');
__PACKAGE__->add_columns(
    tmdb_id =>
        { data_type => 'integer', is_nullable => 0 },
    title =>
        { data_type => 'text',    is_nullable => 0 },
    year =>
        { data_type => 'integer', is_nullable => 0 },
    imdb_id =>
        { data_type => 'text', is_nullable => 0 },
    last_searched =>
        { data_type => 'integer', is_nullable => 0, default_value => 0, },
    last_nzbdate =>
        { data_type => 'integer', is_nullable => 0, default_value => 0, },
    active =>
        { data_type => 'boolean', is_nullable => 0, default_value => 1, },
);
__PACKAGE__->set_primary_key('tmdb_id');

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Schema::Result::Movie - Movie result class

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
