package App::Watchman::Newznab;

use 5.12.0;
use warnings;

# ABSTRACT: tmdb watchlist scraper
# VERSION

use DateTime;
use DateTime::Format::Strptime;
use JSON qw( decode_json );
use Log::Any qw( $log );
use LWP::UserAgent;
use URI;

use Method::Signatures;
use Moose;
use namespace::autoclean;

my $datetime_parser = new DateTime::Format::Strptime(
    # "Fri, 16 Nov 2012 17:03:58 +0000",
    pattern => '%a, %d %b %Y %T %z',
    on_error => 'croak',
    time_zone => 'UTC',
);

has [qw( base_uri apikey )] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has [qw( ua )] => (
    is => 'ro',
    lazy_build => 1,
);

method _build_ua {
    LWP::UserAgent->new
}

method search ($title) {
    $log->info("Searching newznab for [$title]");

    my $uri = URI->new($self->base_uri . '/api');
    $uri->query_form(
        apikey  => $self->apikey,
        t       => 'search',
        o       => 'json',
        cat     => 2000,
        q       =>  _normalise_title($title),
    );
    my $response = $self->ua->get($uri);

    die $response->status_line
        unless $response->is_success;

    my @results = _decode($response->content);
    $log->info('Found ', scalar @results, ' raw results');

    return \@results;
}

method search_uri ($title) {
    return URI->new($self->base_uri . '/search/' . _normalise_title($title));
}

func _normalise_title ($title) {
    # Been missing hits due to apostrophes. Trim the search down to just
    # alphanumeric and space.
    $title =~ tr/A-Za-z0-9 //cd;
    return $title;
}

func _decode ($json) {
    my @results;

    my $data = decode_json($json);
    for my $item (@{ $data->{channel}->{item} // []}) {
        push(@results, {
            name => $item->{title},
            link => $item->{guid},
            date => _parse_date($item->{pubDate}),
        });
    }

    return @results;
}

func _parse_date($datestr) {
    return $datetime_parser->parse_datetime($datestr)->epoch();
}

__PACKAGE__->meta->make_immutable;
1;
