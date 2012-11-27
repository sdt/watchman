package App::Watchman::NZBMatrix;

use 5.12.0;
use warnings;

# ABSTRACT: tmdb watchlist scraper
# VERSION

use IO::String;
use Log::Any qw( $log );
use LWP::UserAgent;
use URI;

use Method::Signatures;
use Moose;
use namespace::autoclean;

has [qw( apikey username )] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has [qw( ua )] => (
    is => 'ro',
    lazy_build => 1,
);

has [qw( searches_remaining )] => (
    is => 'ro',
    isa => 'Int',
    writer => '_set_searches_remaining',
    default => 100,
);

method _build_ua {
    LWP::UserAgent->new
}

method search ($title) {
    $log->info("Searching nzbmatrix for [$title]");
    die 'NZBMatrix api rate limit exceeded'
        if $self->searches_remaining < 10;

    # Been missing hits due to apostrophes. Trim the search down to just
    # alphanumeric and space.
    $title =~ tr/A-Za-z0-9 //cd;

    my $uri = URI->new('http://api.nzbmatrix.com/v1.1/search.php');
    $uri->query_form(
        username => $self->username,
        apikey   => $self->apikey,
        search   => $title,
        num      => 50,
    );
    my $response = $self->ua->get($uri);

    die $response->status_line
        unless $response->is_success;

    local $HTTP::Headers::TRANSLATE_UNDERSCORE = 0;
    my $searches_remaining = $response->header('API_Rate_Limit_Left');
    $self->_set_searches_remaining($searches_remaining)
        if defined $searches_remaining;

    return []
        if $response->content eq 'error:nothing_found';

    die "NZBMatrix error: $1"
        if $response->content =~ /^error:(.*)$/;

    my @results = _decode($response->content);
    $log->info('Found ', scalar @results, ' raw results');

    my @filtered_results = grep {
        $_->{category} =~ /^Movies >/ &&
        1
    } @results;

    $log->info('Found ', scalar @filtered_results, ' filtered results');
    return \@filtered_results;
}

func _decode ($data) {
    my @results;

    my $fh = IO::String->new($data);
    my $entry = {};
    while (<$fh>) {
        chomp;

        if ($_ eq '|') {
            push(@results, $entry);
            $entry = {};
        }
        else {
            my ($key, $value) = ($_ =~ /^(.*?):(.*);$/);
            $entry->{lc($key)} = $value;
        }
    }

    return @results;
}

__PACKAGE__->meta->make_immutable;
1;
