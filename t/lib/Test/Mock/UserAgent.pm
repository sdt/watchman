package Test::Mock::UserAgent;

use 5.12.0;
use warnings;

use Moose;
use namespace::autoclean;

has 'results' => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
    handles => {
        next_result     => 'shift',
        add_results     => 'push',
        clear_results   => 'clear',
    },
);

sub request { shift->next_result }
sub isa     { 1 }  # to pass WWW::TMDB::API isa('LWP::UserAgent') test - dodgy?

__PACKAGE__->meta->make_immutable;
1;
