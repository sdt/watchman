package App::Watchman::Schema;

use 5.12.0;
use warnings;

# ABSTRACT: DBIC Schema class
# VERSION

use Log::Any qw( $log );
use base 'DBIx::Class::Schema';

use Method::Signatures;

method new ($class: :$filename) {
    my $db_exists = -e $filename;

    my $self = $class->connect("DBI:SQLite:$filename");

    if (!$db_exists) {
        $log->info("Creating database $filename");
        $self->deploy;
    }

    return $self;
}

__PACKAGE__->load_namespaces;

1;
