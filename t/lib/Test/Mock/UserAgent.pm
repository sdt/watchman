package Test::Mock::UserAgent;

use 5.12.0;
use warnings;

use Method::Signatures;

method new ($class:, @res)  { bless [ @res ], $class }
method add_results (@res)   { push(@$self, @res) }
method request ($req)       { shift(@$self) }

sub isa { 1 }  # to pass WWW::TMDB::API isa('LWP::UserAgent') test - dodgy?

1;
