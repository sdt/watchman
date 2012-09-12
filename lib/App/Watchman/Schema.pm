package App::Watchman::Schema;

use 5.12.0;
use warnings;

# ABSTRACT: tmdb watchlist scraper
# VERSION

use DBI;

use Method::Signatures;
use Moose;

has [qw( filename )] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has [qw( search_age_sec )] => (
    is => 'ro',
    isa => 'Int',
    default => sub { 24 * 60 * 60 },
);

has [qw( dbh )] => (
    is => 'ro',
    lazy_build => 1,
);

method update_watchlist ($watchlist) {
    my @keys = qw( tmdb_id title year );
    my $keys = join(', ', @keys);
    my $phs = join(', ', map { '?' } @keys);

    my $dbh = $self->dbh;
    my $watchlist_ids = join(', ',
        map { $dbh->quote($_->{tmdb_id}) } @$watchlist);

    # Find the active movies which are not in this watchlist, ...
    my $removed = $dbh->selectall_arrayref(
        "SELECT $keys FROM movies WHERE active = 1 " .
        "AND tmdb_id NOT IN ( $watchlist_ids )",
        { Slice => {} },
    );

    # ... and deactivate them.
    my $remove_ids = join(', ',  map { $_->{tmdb_id} } @$removed);
    $dbh->do("UPDATE movies SET active = 0 WHERE tmdb_id IN ( $remove_ids )");

    my @added;
    for my $movie (@$watchlist) {
        my $row = $dbh->selectrow_hashref(
            "SELECT $keys, active FROM movies WHERE tmdb_id = ?",
            {}, $movie->{tmdb_id}
        );

        if (!$row) {
            # Insert movies which do not already exist.
            $dbh->do("INSERT INTO movies ( $keys ) VALUES ( $phs )",
                {}, map { $movie->{$_} } @keys
            );
            push(@added, $movie);
        }
        elsif (! $row->{active}) {
            # Reactivate existing inactive movies.
            $dbh->do('UPDATE movies SET active = 1 WHERE tmdb_id = ?',
                {}, $row->{tmdb_id}
            );
            push(@added, $movie);
        }
    }

    return ( \@added, $removed );
}

method fetch_searchlist {
    my @keys = qw( tmdb_id title year last_nzbid );
    my $keys = join(', ', @keys);

    my $dbh = $self->dbh;

    my $now = time;
    my $search_cutoff = time - $self->search_age_sec;

    my $searchlist = $dbh->selectall_arrayref(
        "SELECT $keys FROM movies WHERE active = 1 AND last_searched < ?",
        { Slice => {} },
        $search_cutoff,
    );

    my $watchlist_ids = join(', ', map { $_->{tmdb_id} } @$searchlist);

    $dbh->do("UPDATE movies SET last_searched = ? " .
             "WHERE tmdb_id in ( $watchlist_ids )", {}, $now);

    return $searchlist;
}

method update_searchlist (@movies) {
    my $dbh = $self->dbh;

    for my $movie (@movies) {
        $dbh->do('UPDATE movies SET last_nzbid = ? WHERE tmdb_id = ?',
                 {}, $movie->{last_nzbid}, $movie->{tmdb_id});
    }
}

my $sql = <<'ENDSQL';
CREATE TABLE movies (
    tmdb_id             INTEGER PRIMARY_KEY,
    title               TEXT,
    year                INTEGER,

    last_searched       INTEGER DEFAULT 0,
    last_nzbid          INTEGER DEFAULT 0,

    active              BOOLEAN DEFAULT 1
);
ENDSQL

method _build_dbh {
    my $db_exists = -e $self->filename;

    my $dbh = DBI->connect('DBI:SQLite:' . $self->filename, '', '',
        { AutoCommit => 1, PrintError => 1, RaiseError => 1 });

    if (! $db_exists) {
        $dbh->do($_) for split(/;/, $sql);
    }

    return $dbh;
}

1;
