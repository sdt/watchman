package App::Watchman::Mailer;

# ABSTRACT: email sender
# VERSION

use 5.12.0;
use warnings;

use Email::Sender::Simple;
use Email::Simple;

use Method::Signatures;
use Moose;

has [qw( to from )] => (
    is => 'ro',
    isa => 'Str', #XXX: email address type here?
    required => 1,
);

method send (:$subject = 'Message from the watchman', :$body) {
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
