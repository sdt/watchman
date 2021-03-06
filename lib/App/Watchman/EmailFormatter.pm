package App::Watchman::EmailFormatter;

use 5.12.0;
use warnings;

# ABSTRACT: format the email to be sent out
# VERSION

use Log::Any qw( $log );
use Number::Bytes::Human qw(format_bytes);
use URI::Escape;
use Template;

use Method::Signatures;

my $template = <<'END_TEMPLATE';
[%-
  BLOCK movie_info;
    IF movie_list;
      "$heading\n";
      FOR movie IN movie_list;
        " $prefix $movie.title ($movie.year) $movie.tmdb_uri\n";
      END;
      "\n";
    END;
  END;

  BLOCK movie_hits;
    SET movie=result.movie;
    SET search="$movie.title $movie.year";
    "New search hits for $movie.title ($movie.year)\n";
    " $movie.tmdb_uri\n";
    " $movie.nzbsearch_uri\n";
    FOR hit IN result.results;
      " ** $hit.name ($hit.size.bytes) $hit.link\n";
    END;
  END;
-%]
[%- IF errors;
     "Errors occured\n";
      FOR e IN errors;
        " !! $e\n";
      END;
      "\n";
   END; -%]
[%- INCLUDE movie_info prefix='++' movie_list=added
           heading='New movies added'; -%]
[%- INCLUDE movie_info prefix='-+' movie_list=reactivated
           heading='Old movies reactivated' -%]
[%- INCLUDE movie_info prefix='--' movie_list=deactivated
           heading='Movies deactivated' -%]
[%- IF search_hits;
     FOR result IN search_hits;
       INCLUDE movie_hits; "\n";
     END;
   END; -%]
END_TEMPLATE

func format_email($stash) {
    my $tt = Template->new;
    $tt->context->define_vmethod(scalar => uri_escape => \&uri_escape);
    $tt->context->define_vmethod(scalar => bytes => sub {
        format_bytes($_[0]) . 'b'
    });

    my $message;
    $tt->process(\$template, $stash, \$message)
      or die $tt->error;

    return $message;
}

1;
