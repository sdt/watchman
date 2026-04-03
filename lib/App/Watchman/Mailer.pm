package App::Watchman::Mailer;
use v5.34;
use warnings;

# ABSTRACT: email sender
our $VERSION = '0.022'; # VERSION

use Email::Sender::Simple 0.120002;
use Email::Simple;
use Log::Any qw( $log );
use Sys::Hostname;

use Function::Parameters qw( :strict classmethod );
use Moo;
use MooX::Types::MooseLike::Email qw( EmailAddress );
use namespace::autoclean;

has [qw( to from )] => (
    is => 'ro',
    isa => EmailAddress,
    required => 1,
);

my $default_subject = 'Message from the watchman at ' . hostname;

method send (:$subject = $default_subject, :$body) {
    $log->info('Sending email to ', $self->to);
    my $email = Email::Simple->create(
        header => [
            To      => $self->to,
            From    => $self->from,
            Subject => $subject,
        ],
        body => $body,
    );

    Email::Sender::Simple->send($email);
    $log->info('Email sent');
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Watchman::Mailer - email sender

=head1 VERSION

version 0.022

=head1 AUTHOR

Stephen Thirlwall <sdt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
