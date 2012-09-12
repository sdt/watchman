package App::Watchman::Mailer;

use 5.12.0;
use warnings;

# ABSTRACT: email sender
# VERSION

use Email::Sender::Simple;
use Email::Simple;
use Sys::Hostname;

use Method::Signatures;
use Moose;
use MooseX::Types::Email qw( EmailAddress );

has [qw( to from )] => (
    is => 'ro',
    isa => EmailAddress,
    required => 1,
);

my $default_subject = 'Message from the watchman at ' . hostname;

method send (:$subject = $default_subject, :$body) {
    my $email = Email::Simple->create(
        header => [
            To      => $self->to,
            From    => $self->from,
            Subject => $subject,
        ],
        body => $body,
    );

    Email::Sender::Simple->send($email);
}

1;
