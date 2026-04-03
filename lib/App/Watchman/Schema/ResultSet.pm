package App::Watchman::Schema::ResultSet;
use v5.34;
use warnings;

# ABSTRACT: Base resultset class for App::Watchman
our $VERSION = '0.022'; # VERSION

use base 'DBIx::Class::ResultSet';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Schema::ResultSet - Base resultset class for App::Watchman

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
