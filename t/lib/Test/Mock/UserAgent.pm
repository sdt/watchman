package Test::Mock::UserAgent;
use v5.34;
use warnings;

use Function::Parameters qw( :strict classmethod );

classmethod new (@res)      { bless [ @res ], $class }
method add_results (@res)   { push(@$self, @res) }
method set_results (@res)   { @$self = @res }
method request ($req)       { shift(@$self) }
method get ($req)           { shift(@$self) }

sub isa { 1 }  # to pass WWW::TMDB::API isa('LWP::UserAgent') test - dodgy?

1;
