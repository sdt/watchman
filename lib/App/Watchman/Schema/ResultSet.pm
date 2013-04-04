package App::Watchman::Schema::ResultSet;

use 5.12.0;
use warnings;

# ABSTRACT: Base resultset class for App::Watchman
# VERSION

use base 'DBIx::Class::ResultSet';
use Method::Signatures;

method as_hashes {
    return $self->search(undef, {
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });
}

method sorted {
    $self->search_rs(undef, { order_by => [qw( title year )] });
}

1;
