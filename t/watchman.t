use 5.12.0;
use warnings;
use Test::Most;
use Time::Fake;
use Test::Builder;

my $TB = Test::Builder->new;

BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }

my $timenow = 1_000_000;
Time::Fake->offset($timenow);

{
    package Test::Mock::NZBMatrix;
    use Method::Signatures;

    method new($class:)         { bless { res => [ ], rem => 100 }, $class }
    method stuff(@a)            { @{ $self->{res} } = @a }
    method search($term)        { $self->{rem}--; shift($self->{res}) // [] }
    method searches_remaining   { $self->{rem} }
}

{
    package Test::Mock::TMDB;
    use Method::Signatures;

    method new($class:)         { bless [ ], $class }
    method stuff(@a)            { @$self = @a }
    method watchlist()          { shift(@$self) // [] }
}

use App::Watchman;

my $config    = { dbfile => ':memory:', email => { to => 'me@example.com' } };
my $nzbmatrix = Test::Mock::NZBMatrix->new;
my $tmdb      = Test::Mock::TMDB->new;
my $searches  = 100;

is($nzbmatrix->searches_remaining, $searches, "$searches searches remaining");

my $wm = App::Watchman->new(
    config    => $config,
    nzbmatrix => $nzbmatrix,
    tmdb      => $tmdb,
);

my $movieA = 'movieA/2001';
my $movieB = 'movieB/2002';
my $movieC = 'movieC/2003';

#------------------------------------------------------------------------------
note 'First run with two movies';
my @tmdb_data = movies($movieA, $movieB);
my %nzb_data  = (
    $movieA => [ results($movieA, 3) ],
    $movieB => [ results($movieB, 2) ],
);

$tmdb->stuff(\@tmdb_data);
$nzbmatrix->stuff(@nzb_data{ sort keys %nzb_data });

$wm->run;

is(emails()->delivery_count, 1, "One email sent");
my $email = next_email();

like($email->get_body, qr/Movies added/, 'Movies added');
is(movies_added($email), 2, "2 movies added");
movie_was_added($email, 'movieA');
movie_was_added($email, 'movieB');

unlike($email->get_body, qr/Movies removed/, 'No movies removed');
is(movies_removed($email), 0, "0 movies removed");

like($email->get_body, qr/New search results/, 'New search results');
is(search_results($email, 'movieA'), 3, '3 hits on movie A');
is(search_results($email, 'movieB'), 2, '2 hits on movie A');

searches_made_is(2);

#------------------------------------------------------------------------------
note 'Remove the second movie and run again';
$tmdb->stuff([ $tmdb_data[0] ]);
$wm->run;

is(emails()->delivery_count, 1, "One email sent");
$email = next_email();

unlike($email->get_body, qr/Movies added/, 'No movies added');
is(movies_added($email), 0, "No movies added");

like($email->get_body, qr/Movies removed/, 'Movies removed');
is(movies_removed($email), 1, "One movie removed");
movie_was_removed($email, 'movieB');

unlike($email->get_body, qr/New search results/, 'No new search results');

searches_made_is(0);

#------------------------------------------------------------------------------
note 'Re-add the second movie and run again';
$tmdb->stuff(\@tmdb_data);
$wm->run;

is(emails()->delivery_count, 1, "One email sent");
$email = next_email();

like($email->get_body, qr/Movies added/, 'Movies added');
is(movies_added($email), 1, "One movie added");
movie_was_added($email, 'movieB');

unlike($email->get_body, qr/Movies removed/, 'No movies removed');
is(movies_removed($email), 0, "No movies removed");

unlike($email->get_body, qr/New search results/, 'No new search results');

searches_made_is(0);

#------------------------------------------------------------------------------
note 'Re-run immediately with same watchlist';
$tmdb->stuff(\@tmdb_data);
$wm->run;

is(emails()->delivery_count, 0, "No emails sent");
searches_made_is(0);

#------------------------------------------------------------------------------
note 'Re-run with same watchlist a day later';
add_hours(25);

$tmdb->stuff(\@tmdb_data);
$wm->run;

is(emails()->delivery_count, 0, "No emails sent");
searches_made_is(2);

#------------------------------------------------------------------------------
note 'Add a new watch item 12 hours later';
add_hours(12);

push(@tmdb_data, movie($movieC));
$tmdb->stuff(\@tmdb_data);
$wm->run;

is(emails()->delivery_count, 1, "One email sent");
$email = next_email();

like($email->get_body, qr/Movies added/, 'Movies added');
is(movies_added($email), 1, "One movie added");
movie_was_added($email, 'movieC');

unlike($email->get_body, qr/Movies removed/, 'No movies removed');
is(movies_removed($email), 0, "No movies removed");

unlike($email->get_body, qr/New search results/, 'No new search results');

searches_made_is(1);

#------------------------------------------------------------------------------
note 'Re-run with same watchlist 12 hours later';
add_hours(12);

$tmdb->stuff(\@tmdb_data);
$wm->run;

is(emails()->delivery_count, 0, "No emails sent");
searches_made_is(2);

#------------------------------------------------------------------------------
note 'Add some results and search again 24 hours later';
add_hours(26);

push(@{ $nzb_data{$movieA} },  results($movieA, 1));
push(@{ $nzb_data{$movieB} },  results($movieB, 4));
$nzb_data{$movieC} = [ results($movieC, 3) ];

$tmdb->stuff(\@tmdb_data);
$nzbmatrix->stuff(@nzb_data{ sort keys %nzb_data });

$wm->run;

is(emails()->delivery_count, 1, "One email sent");
$email = next_email();

unlike($email->get_body, qr/Movies added/, 'No movies added');
is(movies_added($email), 0, "No movies added");

unlike($email->get_body, qr/Movies removed/, 'No movies removed');
is(movies_removed($email), 0, "No movies removed");
is(search_results($email, 'movieA'), 1, '1 hits on movie A');
is(search_results($email, 'movieB'), 4, '4 hits on movie B');
is(search_results($email, 'movieC'), 3, '3 hits on movie C');

searches_made_is(3);

done_testing();
#------------------------------------------------------------------------------

sub movie_was_added {
    my ($email, $title) = @_;
    $TB->like($email->get_body, qr/\+\+ \Q$title\E/, "$title was added");
}

sub movie_was_removed {
    my ($email, $title) = @_;
    $TB->like($email->get_body, qr/-- \Q$title\E/, "$title was removed");
}

sub searches_made_is {
    my ($num_searches) = @_;
    my $new_searches = $nzbmatrix->searches_remaining;
    $TB->is_num($searches - $new_searches, $num_searches,
        "$num_searches searches were performed");
    $searches = $new_searches;
}

sub count_occurances {
    my ($string, $regex) = @_;
    my $count =()= $string =~ /$regex/g;
}

sub movies_added {
    my ($email) = @_;
    count_occurances($email->get_body, qr/\+\+/);
}

sub movies_removed {
    my ($email) = @_;
    count_occurances($email->get_body, qr/--/);
}

sub search_results {
    my ($email, $title) = @_;
    count_occurances($email->get_body, qr/\Q$title\E.*link\.to/);
}

sub movie {
    state $next_id = 1;
    my ($ty) = @_;
    my ($title, $year) = split('/', $ty);
    return {
        tmdb_id => $next_id++,
        title   => $title,
        year    => $year,
    };
}

sub movies {
    map { movie($_) } @_
}

sub result {
    state $next_nzbid = 1;
    my ($title) = @_;
    my $id = $next_nzbid++;
    return {
        nzbid   => $id,
        nzbname => "$title $id",
        link    => "link.to/$id",
    };
}

sub results {
    my ($title, $count) = @_;
    reverse map { result($title) } (1 .. $count);
}

sub emails {
    Email::Sender::Simple->default_transport;
}

sub next_email {
    Email::Sender::Simple->default_transport->shift_deliveries->{email};
}

sub add_hours {
    my $hours = shift;
    Time::Fake->offset($timenow += $hours * 60 * 60);
}

