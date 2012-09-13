package App::Watchman::Config;

use 5.12.0;
use warnings;

# ABSTRACT: watchman configuration
# VERSION

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

=head1 NAME

App::Watchman::Config

=cut
