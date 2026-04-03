package App::Watchman::Config;
use v5.34;
use warnings;

# ABSTRACT: watchman configuration
our $VERSION = '0.022'; # VERSION

use Config::General;
use File::HomeDir;
use File::Spec;
use Log::Any qw( $log );

sub filename {
    return $ENV{WATCHMANRC}
        // File::Spec->catfile(File::HomeDir->my_home, '.watchmanrc');
}

sub load {
    my $filename = filename();

    my $default = get_default();
    if (! -e $filename) {
        $log->warn("Config file $filename not found");
        return $default;
    }

    my $cfg = Config::General->new(
        -ConfigFile => $filename,
        -DefaultConfig => $default,
    );

    return { $cfg->getall };
}

sub get_default {
    return { };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Config - watchman configuration

=head1 VERSION

version 0.022

=head1 NAME

App::Watchman::Config

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
