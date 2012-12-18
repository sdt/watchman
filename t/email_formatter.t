use 5.12.0;
use warnings;
use Test::Most;
use Test::Builder;

my $TB = Test::Builder->new;

use App::Watchman::EmailFormatter;

my %stash = (
    added       => [ movies(0, 1) ],
    reactivated => [ movies(1, 2) ],
    deactivated => [ movies(3, 3) ],
    search_hits => [
        search_hits(0, 0, 2),
        search_hits(1, 2, 1),
    ],
    errors      => [
        'wtf?',
        'ffs!',
    ],
);

my @stash_keys = sort keys %stash;
my $iter = combinations(0, $#stash_keys);
while (my $indexes = $iter->()) {
    my @keys = @stash_keys[ @$indexes ];
    my %s = map { $_ => $stash{$_} } @keys;
    my $msg = App::Watchman::EmailFormatter::format_email(\%s);

    note "Checking for stash keys: @keys";

    unlike($msg, qr/\n\n\n/m, 'No double-blank lines');
    like($msg, qr/\n\n$/m, 'Ends in a blank line');

    check_watchlist(\%s, $msg, added => '++', 'New movies added');
    check_watchlist(\%s, $msg, reactivated => '-+', 'Old movies reactivated');
    check_watchlist(\%s, $msg, deactivated => '--', 'Movies deactivated');
    check_search_hits(\%s, $msg);
    check_errors(\%s, $msg);
}

done_testing;

#------------------------------------------------------------------------------

sub movie {
    my ($id) = @_;
    return {
        title   => "movie$id",
        year    => 1970 + $id,
        tmdb_id => $id,
    };
}

sub movies {
    my ($first, $count) = @_;
    return map { movie($first + $_) } (0 .. $count-1);
}

sub search_hit {
    my ($movieid, $nzbid) = @_;
    return {
        name => "movie$movieid nzb$nzbid",
        link => "link.to/$nzbid",
    };
}

sub search_hits {
    my ($movieid, $first, $count) = @_;
    return {
        movie   => movie($movieid),
        results => [
            map { search_hit($movieid, $first + $_) } (0 .. $count-1)
        ],
    }
}

sub combinations {
    my ($min, $max) = @_;
    my @items = map { [ $_ ] } ($min .. $max);
    return sub {
        my $ret = shift @items or return;
        for ($ret->[-1] + 1 .. $max) {
            push(@items, [ @$ret, $_ ]);
        }
        return $ret;
    }
}

sub check_search_hits {
    my ($stash, $message) = @_;
    my ($key, $prefix, $heading) = ( 'search_hits', '**', 'New search hits' );

    if (!exists $stash->{$key}) {
        $TB->unlike($message, qr/\Q$heading\E/,
            "Heading for $key not found");
        $TB->unlike($message, qr/\Q$prefix\E/,
            "Entries for $key not found");
        return;
    }

    for my $result (@{ $stash->{$key} }) {
        my $movie = $result->{movie};
        for my $field (qw( title year )) {
            $TB->like($message, qr/\Q$heading\E.*\Q$movie->{$field}\E/,
                "Message contains $key message '$movie->{$field}'");
        }
        for my $hit (@{ $result->{results} }) {
            for my $field (qw( name link )) {
                $TB->like($message, qr/\Q$prefix\E.*\Q$hit->{$field}\E/,
                    "Message contains $field '$hit->{$field}'");
            }
        }
    }
}

sub check_errors {
    my ($stash, $message) = @_;
    my ($key, $prefix, $heading) = ( 'errors', '!!', 'Errors occured' );

    if ($stash->{$key}) {
        for my $error (@{ $stash->{$key} }) {
            $TB->like($message, qr/\Q$prefix\E.*\Q$error\E/,
                "Message contains $key message '$error'");
        }
    }
    else {
        $TB->unlike($message, qr/\Q$heading\E/, "Heading for $key not found");
        $TB->unlike($message, qr/\Q$prefix\E/, "Entries for $key not found");
    }
}

sub check_watchlist {
    my ($stash, $message, $key, $prefix, $heading) = @_;

    my @keys = sort keys %$stash;
    if ($stash->{$key}) {
        $TB->like($message, qr/\Q$heading\E/, "Heading for $key found");
        for my $movie (@{ $stash->{$key} }) {
            for my $field (qw( title year tmdb_id)) {
                $TB->like($message, qr/\Q$prefix\E.*\Q$movie->{$field}\E/,
                    "Message contains $key movie $field");
            }
        }
    }
    else {
        $TB->unlike($message, qr/\Q$heading\E/, "Heading for $key not found");
        $TB->unlike($message, qr/\Q$prefix\E/, "Entries for $key not found");
    }
}
