package App::Watchman::Config;

# ABSTRACT: watchman configuration
# VERSION

use 5.12.0;
use warnings;

use Config::General;
use File::HomeDir;
use File::Spec;

sub filename {
    return $ENV{WATCHMANRC}
        // File::Spec->catfile(File::HomeDir->my_home, '.watchmanrc');
}

sub load {
    my $filename = filename();

    my $default = get_default();
    return $default unless -e $filename;

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

=head1 NAME

App::Watchman::Config

=cut
