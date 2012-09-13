package App::Watchman::Schema;

use 5.12.0;
use warnings;

# VERSION

use base 'DBIx::Class::Schema';

use Method::Signatures;

my $schema_version = 1;

method new ($class: :$filename) {
    my $db_exists = -e $filename;

    my $self = $class->connect("DBI:SQLite:$filename");

    if (!$db_exists) {
        $self->_install;
    }
    else {
        $self->_upgrade;
    }

    return $self;
}

method installed_version {
    $self->resultset('Version')->search(undef,
        {
            order_by => { -desc => 'version' },
            rows     => 1,
        })->single->get_column('version');
}

method _install {
    $self->deploy;
    $self->resultset('Version')->create({ version => $schema_version });
}

method _upgrade {
    for (my $installed_version = $self->installed_version;
         $installed_version < $schema_version;
         $installed_version++) {

        $self->_upgrade_step($installed_version);
    }
}

my %upgrade_code = (


);

method _upgrade_step ($installed_version) {
    my $code = $upgrade_code{$installed_version}
        or die "Unable to upgrade schema from version $installed_version";

    $code->($self);
}

__PACKAGE__->load_namespaces;

1;
