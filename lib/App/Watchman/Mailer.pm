package App::Watchman::Mailer;

use 5.12.0;
use warnings;

# ABSTRACT: email sender
# VERSION

use Email::Sender::Simple 0.120002;
use Email::Simple;
use Log::Any qw( $log );
use Sys::Hostname;

use Method::Signatures;
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
