use 5.12.0;
use warnings;
use Test::More;
use Test::FailWarnings;

use App::Watchman::Schema::Result::Indexer;

my %samples = (
    q(Bob's Burgers) => q(Bobs Burgers),
    q(Pietà)         => q(Pieta),
);

while (my ($before, $after) = each %samples) {
    my $got = App::Watchman::Schema::Result::Indexer::_normalise_title($before);
    if ($before eq $after) {
        is($got, $after, "'$before' is unmodified");
    }
    else {
        is($got, $after, "'$before' becomes '$after'");
    }
}

done_testing;
