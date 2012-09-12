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

has [qw( to from )] => (
    is => 'ro',
    isa => 'Str', #XXX: email address type here?
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
