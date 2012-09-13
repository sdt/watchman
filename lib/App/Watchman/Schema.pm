package App::Watchman::Schema;

use 5.12.0;
use warnings;

# VERSION

use base 'DBIx::Class::Schema';

use Method::Signatures;

method new ($class: :$filename) {
    my $db_exists = -e $filename;

    my $self = $class->connect("DBI:SQLite:$filename");

    if (!$db_exists) {
        $self->deploy;
    }

    return $self;
}

__PACKAGE__->load_namespaces;

1;
