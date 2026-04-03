package App::Watchman::Schema;
use v5.34;
use warnings;

# ABSTRACT: DBIC Schema class
our $VERSION = '0.022'; # VERSION

use Log::Any qw( $log );
use base 'DBIx::Class::Schema';

use Function::Parameters qw( :strict classmethod );

method new ($class: $config) {
    my $filename = $config->{dbfile};
    my $db_exists = -e $filename;

    my $self = $class->connect("DBI:SQLite:$filename");

    if (!$db_exists) {
        $log->info("Creating database $filename");
        $self->deploy;
    }

    return $self;
}

__PACKAGE__->load_namespaces;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Schema - DBIC Schema class

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
