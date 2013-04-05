package App::Watchman::Schema::Result::Indexer;

use 5.12.0;
use warnings;

# ABSTRACT: Indexer class
# VERSION

use base 'DBIx::Class::Core';
use DateTime;
use DateTime::Format::Strptime;
use JSON qw( decode_json );
use Log::Any qw( $log );
use Method::Signatures;
use URI;

use App::Watchman::Schema::ColumnTypes qw( PrimaryKey Text Boolean );

__PACKAGE__->table('indexers');
__PACKAGE__->add_columns(
    indexer_id  => PrimaryKey,
    name        => Text,
    base_uri    => Text,
    apikey      => Text,
    active      => Boolean(default_value => 1),
);

__PACKAGE__->set_primary_key('indexer_id');
__PACKAGE__->has_many(
    scrapes => 'App::Watchman::Schema::Result::Scrape',
    { 'foreign.indexer_fk' => 'self.indexer_id' },
);
__PACKAGE__->add_unique_constraint([qw( name )]);
__PACKAGE__->add_unique_constraint([qw( base_uri )]);

method scrape ($ua, $title) {
    my $name = $self->name;
    $log->info("Searching newznab [$name] for [$title]");

    my $uri = URI->new($self->base_uri . '/api');
    $uri->query_form(
        apikey  => $self->apikey,
        t       => 'search',
        o       => 'json',
        cat     => 2000,
        q       =>  _normalise_title($title),
    );
    my $response = $ua->get($uri);

    die $response->status_line
        unless $response->is_success;

    my @results = _decode($response->content);
    $log->info('Found ', scalar @results, ' raw results');

    return @results;
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

{
    my $datetime_parser = new DateTime::Format::Strptime(
        # "Fri, 16 Nov 2012 17:03:58 +0000",
        pattern => '%a, %d %b %Y %T %z',
        on_error => 'croak',
        time_zone => 'UTC',
    );

    func _parse_date($datestr) {
        return $datetime_parser->parse_datetime($datestr)->epoch();
    }
}

1;
