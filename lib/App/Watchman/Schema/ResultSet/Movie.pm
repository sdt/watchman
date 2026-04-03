package App::Watchman::Schema::ResultSet::Movie;
use v5.34;
use warnings;

# ABSTRACT: Movie resultset class
our $VERSION = '0.022'; # VERSION

use base 'App::Watchman::Schema::ResultSet';

use Function::Parameters qw( :strict classmethod );

method as_hashes() {
    return $self->search(undef, {
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });
}

method as_ids() {
    return $self->search(undef, {
            select => [qw( tmdb_id )],
        });
}

method sorted() {
    $self->search_rs(undef, { order_by => [qw( title year )] });
}

method deactivated(@tmdb_ids) {
    $self->search({
            active  => 1,
            tmdb_id => { -not_in => \@tmdb_ids },
        })->sorted;
}

method reactivated(@tmdb_ids) {
    $self->search({
            active  => 0,
            tmdb_id => { -in => \@tmdb_ids },
        })->sorted;
}

method searchlist($search_min_age) {
    my $search_cutoff = time - $search_min_age;
    $self->search({
            active        => 1,
            last_searched => { '<=' => $search_cutoff },
        })->sorted;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Schema::ResultSet::Movie - Movie resultset class

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
