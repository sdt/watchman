
BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    print qq{1..0 # SKIP these tests are for testing by the author\n};
    exit
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.19

use Test::More 0.88;
use Test::EOL;

my @files = (
    'bin/imdb-search',
    'bin/watchman',
    'lib/App/Watchman.pm',
    'lib/App/Watchman/Config.pm',
    'lib/App/Watchman/EmailFormatter.pm',
    'lib/App/Watchman/Mailer.pm',
    'lib/App/Watchman/Newznab.pm',
    'lib/App/Watchman/Schema.pm',
    'lib/App/Watchman/Schema/Result/Movie.pm',
    'lib/App/Watchman/Schema/ResultSet.pm',
    'lib/App/Watchman/Schema/ResultSet/Movie.pm',
    'lib/App/Watchman/TMDB.pm',
    't/00-compile.t',
    't/author-critic.t',
    't/author-distmeta.t',
    't/author-eol.t',
    't/author-no-tabs.t',
    't/author-pod-coverage.t',
    't/author-pod-syntax.t',
    't/author-portability.t',
    't/builders.t',
    't/email_formatter.t',
    't/lib/Test/Mock/UserAgent.pm',
    't/newznab.t',
    't/release-meta-json.t',
    't/title.t',
    't/tmdb.t',
    't/watchman.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
