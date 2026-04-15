package App::Watchman::Newznab;
use v5.34;
use warnings;

# ABSTRACT: tmdb watchlist scraper
our $VERSION = '0.022'; # VERSION

use Data::Dumper::Concise;
use DateTime;
use DateTime::Format::Strptime;
use JSON v2.61 qw( decode_json );
use Log::Any qw( $log );
use LWP::UserAgent;
use URI;
use XML::Parser qw( );

use Function::Parameters qw( :strict classmethod );
use Moo;
use MooX::Types::MooseLike::Base qw( Str );
use namespace::autoclean;

my $datetime_parser = new DateTime::Format::Strptime(
    # "Fri, 16 Nov 2012 17:03:58 +0000",
    pattern => '%a, %d %b %Y %T %z',
    on_error => 'undef',
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
        extended  => 1,
        imdbid  =>  $imdb_id,
    );
    my $response = $self->ua->get($uri);

    die $response->status_line
        unless $response->is_success;

    my @results;
    my $content = $response->content;

    if ($content =~ /^\s*</) {
        $log->info('Attempting XML decode');
        @results = _decode_xml($content);
    }
    elsif ($content =~ /^\s*{/) {
        $log->info('Attempting JSON decode');
        @results = _decode_json($content);
    }
    else {
        $log->error($content);
        die q(Can't work out the format of the results);
    }

    $log->info('Found ', scalar @results, ' raw results');

    return \@results;
}

method search_uri ($title) {
    # https://v2.nzbs.in/search?category=movies&query=shining+1980
    my $uri = URI->new($self->base_uri . '/search');
    $uri->query_param(category => 'movies');
    $uri->query_param(query => $title);
    return $uri->as_string;
}

fun _normalise_title ($title) {
    # Been missing hits due to apostrophes, get rid of them!
    $title =~ tr/'//d;

    # Happened upon this char which isn't working well for me, but works
    # fine as a regular 'a'.
    $title =~ s/à/a/g;  # tr/à/a/ converts à to aa ?
    return $title;
}

fun _decode_xml ($xml) {
    my @node_stack;
    my @items;
    my $current_item;
    my %handlers = (
        Start => fun($expat, $element, %attr) {
            if ($element eq 'item') {
                $current_item = { };
            }
            my %node = (
                element => $element,
                value => '',
            );
            $node{attr} = \%attr if %attr;
            push(@node_stack, \%node);
        },
        Char => fun($expat, $str) {
            my $node = $node_stack[-1];
            $node->{value} .= $str;
        },
        End => fun($expat, $element) {
            my $path = join('|', map { $_->{element} } @node_stack);
            my $node = pop(@node_stack);
            $node->{path} = $path;

            if ($current_item) {
                if ($element eq 'item') {
                    push(@items, $current_item);
                    $current_item = undef;
                }
                elsif ($element eq 'newznab:attr') {
                    my $key = $node->{attr}->{name};
                    my $value = $node->{attr}->{value};
                    $current_item->{$key} = $value;
                }
                else {
                    my $value = $node->{value};
                    if ($value ne '') {
                        $current_item->{$element} = $value;
                    }
                }
            }
        },
    );
    my $parser = XML::Parser->new(Handlers => \%handlers);
    $parser->parse($xml);

    my @results;
    for my $item (@items) {
        push(@results, {
            name => $item->{title},
            link => $item->{guid},
            date => _parse_date($item->{pubDate}),
            size => $item->{size},
        });
    }

    return reverse sort { $a->{date} <=> $b->{date} } @results;
}

fun _decode_json ($json) {
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

my $default_datetime = DateTime->new(year => 2000);

fun _parse_date($datestr) {
    my $datetime =  $datetime_parser->parse_datetime($datestr);
    if (!defined $datetime) {
        print "Bad date: ", Dumper($datestr);
        $datetime = $default_datetime;
    }
    return $datetime->epoch();
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Newznab - tmdb watchlist scraper

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
