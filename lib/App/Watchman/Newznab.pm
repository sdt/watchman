package App::Watchman::Newznab;

use 5.12.0;
use warnings;

# ABSTRACT: tmdb watchlist scraper
# VERSION

use DateTime;
use DateTime::Format::Strptime;
use JSON v2.61 qw( decode_json );
use Log::Any qw( $log );
use LWP::UserAgent;
use URI;

use Method::Signatures;
use Moo;
use MooX::Types::MooseLike::Base qw( Str );
use namespace::autoclean;

my $datetime_parser = new DateTime::Format::Strptime(
    # "Fri, 16 Nov 2012 17:03:58 +0000",
    pattern => '%a, %d %b %Y %T %z',
    on_error => 'croak',
    time_zone => 'UTC',
);

has [qw( base_uri apikey )] => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has ua => (
    is => 'lazy',
    default => sub {
        LWP::UserAgent->new(
            ssl_opts => {
                verify_hostname => 0,
                SSL_verify_mode => 'SSL_VERIFY_NONE',
            }
        )
    },
);

method search ($title, $imdb_id) {
    $log->info("Searching newznab for [$title]");

    my $uri = URI->new($self->base_uri . '/api');
    $uri->query_form(
        apikey  => $self->apikey,
        t       => 'movie',
        o       => 'json',
        imdbid  =>  $imdb_id,
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
    # Been missing hits due to apostrophes, get rid of them!
    $title =~ tr/'//d;

    # Happened upon this char which isn't working well for me, but works
    # fine as a regular 'a'.
    $title =~ s/à/a/g;  # tr/à/a/ converts à to aa ?
    return $title;
}

func _decode ($json) {
    my @results;

    my $data = decode_json($json);
    my $items = $data->{channel}->{item} // [];
    $items = [ $items ] unless ref $items eq 'ARRAY';
    for my $item (@$items) {
        push(@results, {
            name => $item->{title},
            link => $item->{guid},
            date => _parse_date($item->{pubDate}),
            size => $item->{enclosure}->{'@attributes'}->{length},
        });
    }

    return reverse sort { $a->{date} <=> $b->{date} } @results;
}

func _parse_date($datestr) {
    return $datetime_parser->parse_datetime($datestr)->epoch();
}

1;
