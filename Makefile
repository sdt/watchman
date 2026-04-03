# This Makefile is for the App::Watchman extension to perl.
#
# It was generated automatically by MakeMaker version
# 7.76 (Revision: 77600) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[Watch out!]
#     AUTHOR => [q[Stephen Thirlwall <sdt@cpan.org>]]
#     BUILD_REQUIRES => {  }
#     CONFIGURE_REQUIRES => { ExtUtils::MakeMaker=>q[0] }
#     DISTNAME => q[App-Watchman]
#     EXE_FILES => [q[bin/imdb-search], q[bin/watchman]]
#     LICENSE => q[perl]
#     MIN_PERL_VERSION => q[5.034000]
#     NAME => q[App::Watchman]
#     PREREQ_PM => { Class::Load=>q[0], Config::General=>q[0], DBD::SQLite=>q[0], DBIx::Class::Core=>q[0], DBIx::Class::ResultClass::HashRefInflator=>q[0], DBIx::Class::ResultSet=>q[0], DBIx::Class::Schema=>q[0], Data::Dumper::Concise=>q[0], DateTime=>q[0], DateTime::Format::Strptime=>q[0], Email::Sender::Simple=>q[0.120002], Email::Simple=>q[0], File::HomeDir=>q[0], File::Spec=>q[0], File::Temp=>q[0], Function::Parameters=>q[0], HTTP::Headers=>q[0], HTTP::Response=>q[0], IO::Handle=>q[0], IO::Interactive=>q[0], IPC::Open3=>q[0], JSON=>q[v2.61.0], LWP::UserAgent=>q[0], List::Util=>q[0], Log::Any=>q[0], Log::Any::Adapter=>q[0], Log::Any::Plugin=>q[0], Moo=>q[0], MooX::Types::MooseLike::Base=>q[0], MooX::Types::MooseLike::Email=>q[0], Number::Bytes::Human=>q[0], SQL::Translator=>q[0], Sys::Hostname=>q[0], Template=>q[0], Test::Builder=>q[0], Test::FailWarnings=>q[0], Test::More=>q[0], Test::Most=>q[0], Time::Fake=>q[0], Try::Tiny=>q[0], URI=>q[0], URI::Escape=>q[0], WWW::TMDB::API=>q[0], base=>q[0], lib=>q[0], namespace::autoclean=>q[0], strict=>q[0], warnings=>q[0] }
#     TEST_REQUIRES => { File::Spec=>q[0], File::Temp=>q[0], HTTP::Headers=>q[0], HTTP::Response=>q[0], IO::Handle=>q[0], IPC::Open3=>q[0], Test::Builder=>q[0], Test::FailWarnings=>q[0], Test::More=>q[0], Test::Most=>q[0], Time::Fake=>q[0], lib=>q[0], strict=>q[0] }
#     VERSION => q[0.022]
#     test => { TESTS=>q[t/*.t] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib/x86_64-linux-gnu/perl-base/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = x86_64-linux-gnu-gcc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
CPPRUN = x86_64-linux-gnu-gcc  -E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = x86_64-linux-gnu-gcc
LDDLFLAGS = -shared -L/usr/local/lib -fstack-protector-strong
LDFLAGS =  -fstack-protector-strong -L/usr/local/lib
LIBC = /lib/x86_64-linux-gnu/libc.so.6
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 6.1.0
RANLIB = :
SITELIBEXP = /usr/local/share/perl/5.40.1
SITEARCHEXP = /usr/local/lib/x86_64-linux-gnu/perl/5.40.1
SO = so
VENDORARCHEXP = /usr/lib/x86_64-linux-gnu/perl5/5.40
VENDORLIBEXP = /usr/share/perl5


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = App::Watchman
NAME_SYM = App_Watchman
VERSION = 0.022
VERSION_MACRO = VERSION
VERSION_SYM = 0_022
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.022
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1p
MAN3EXT = 3pm
MAN1SECTION = 1
MAN3SECTION = 3
INSTALLDIRS = site
INSTALL_BASE = /home/sdt/perl5
DESTDIR = 
PREFIX = $(INSTALL_BASE)
INSTALLPRIVLIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = $(INSTALL_BASE)/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = $(INSTALL_BASE)/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = $(INSTALL_BASE)/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /usr/share/perl/5.40
PERL_ARCHLIB = /usr/lib/x86_64-linux-gnu/perl/5.40
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib/x86_64-linux-gnu/perl/5.40/CORE
PERL = "/usr/bin/perl"
FULLPERL = "/usr/bin/perl"
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /home/sdt/perl5/lib/perl5/ExtUtils/MakeMaker.pm
MM_VERSION  = 7.76
MM_REVISION = 77600

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = App/Watchman
BASEEXT = Watchman
PARENT_NAME = App
DLBASE = $(BASEEXT)
VERSION_FROM = 
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = bin/imdb-search \
	bin/watchman
MAN3PODS = lib/App/Watchman.pm \
	lib/App/Watchman/Config.pm \
	lib/App/Watchman/EmailFormatter.pm \
	lib/App/Watchman/Mailer.pm \
	lib/App/Watchman/Newznab.pm \
	lib/App/Watchman/Schema.pm \
	lib/App/Watchman/Schema/Result/Movie.pm \
	lib/App/Watchman/Schema/ResultSet.pm \
	lib/App/Watchman/Schema/ResultSet/Movie.pm \
	lib/App/Watchman/TMDB.pm

# Where to build things
INST_LIBDIR      = $(INST_LIB)/App
INST_ARCHLIBDIR  = $(INST_ARCHLIB)/App

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/App/Watchman.pm \
	lib/App/Watchman/Config.pm \
	lib/App/Watchman/EmailFormatter.pm \
	lib/App/Watchman/Mailer.pm \
	lib/App/Watchman/Newznab.pm \
	lib/App/Watchman/Schema.pm \
	lib/App/Watchman/Schema/Result/Movie.pm \
	lib/App/Watchman/Schema/ResultSet.pm \
	lib/App/Watchman/Schema/ResultSet/Movie.pm \
	lib/App/Watchman/TMDB.pm
PERL_ARCHLIBDEP = /usr/lib/x86_64-linux-gnu/perl/5.40
PERL_INCDEP = /usr/lib/x86_64-linux-gnu/perl/5.40/CORE


# Dependencies info
PERL_ARCHIVEDEP    = 

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIBDEP)$(DFSEP)Config.pm $(PERL_INCDEP)$(DFSEP)config.h


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 7.76
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = App-Watchman
DISTVNAME = App-Watchman-0.022


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"\
	INSTALL_BASE="$(INSTALL_BASE)"\
	PASTHRU_DEFINE='$(DEFINE) $(PASTHRU_DEFINE)'\
	PASTHRU_INC='$(INC) $(PASTHRU_INC)'


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir pure_all subdirs clean_subdirs makemakerdflt manifypods realclean_subdirs subdirs_dynamic subdirs_pure_nolink subdirs_static subdirs-test_dynamic subdirs-test_static test_dynamic test_static



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)

pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: dynamic
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) config $(INST_BOOT) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all config  \
	bin/imdb-search \
	bin/watchman \
	lib/App/Watchman.pm \
	lib/App/Watchman/Config.pm \
	lib/App/Watchman/EmailFormatter.pm \
	lib/App/Watchman/Mailer.pm \
	lib/App/Watchman/Newznab.pm \
	lib/App/Watchman/Schema.pm \
	lib/App/Watchman/Schema/Result/Movie.pm \
	lib/App/Watchman/Schema/ResultSet.pm \
	lib/App/Watchman/Schema/ResultSet/Movie.pm \
	lib/App/Watchman/TMDB.pm
	$(NOECHO) $(POD2MAN) --section=$(MAN1SECTION) --perm_rw=$(PERM_RW) -u \
	  bin/imdb-search $(INST_MAN1DIR)/imdb-search.$(MAN1EXT) \
	  bin/watchman $(INST_MAN1DIR)/watchman.$(MAN1EXT) 
	$(NOECHO) $(POD2MAN) --section=$(MAN3SECTION) --perm_rw=$(PERM_RW) -u \
	  lib/App/Watchman.pm $(INST_MAN3DIR)/App::Watchman.$(MAN3EXT) \
	  lib/App/Watchman/Config.pm $(INST_MAN3DIR)/App::Watchman::Config.$(MAN3EXT) \
	  lib/App/Watchman/EmailFormatter.pm $(INST_MAN3DIR)/App::Watchman::EmailFormatter.$(MAN3EXT) \
	  lib/App/Watchman/Mailer.pm $(INST_MAN3DIR)/App::Watchman::Mailer.$(MAN3EXT) \
	  lib/App/Watchman/Newznab.pm $(INST_MAN3DIR)/App::Watchman::Newznab.$(MAN3EXT) \
	  lib/App/Watchman/Schema.pm $(INST_MAN3DIR)/App::Watchman::Schema.$(MAN3EXT) \
	  lib/App/Watchman/Schema/Result/Movie.pm $(INST_MAN3DIR)/App::Watchman::Schema::Result::Movie.$(MAN3EXT) \
	  lib/App/Watchman/Schema/ResultSet.pm $(INST_MAN3DIR)/App::Watchman::Schema::ResultSet.$(MAN3EXT) \
	  lib/App/Watchman/Schema/ResultSet/Movie.pm $(INST_MAN3DIR)/App::Watchman::Schema::ResultSet::Movie.$(MAN3EXT) \
	  lib/App/Watchman/TMDB.pm $(INST_MAN3DIR)/App::Watchman::TMDB.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = bin/imdb-search bin/watchman

pure_all :: $(INST_SCRIPT)/imdb-search $(INST_SCRIPT)/watchman
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/imdb-search $(INST_SCRIPT)/watchman 

$(INST_SCRIPT)/imdb-search : bin/imdb-search $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/imdb-search
	$(CP) bin/imdb-search $(INST_SCRIPT)/imdb-search
	$(FIXIN) $(INST_SCRIPT)/imdb-search
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/imdb-search

$(INST_SCRIPT)/watchman : bin/watchman $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/watchman
	$(CP) bin/watchman $(INST_SCRIPT)/watchman
	$(FIXIN) $(INST_SCRIPT)/watchman
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/watchman



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
# so clean is forced to complete before realclean_subdirs runs
realclean_subdirs : clean
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge :: realclean_subdirs
	- $(RM_F) \
	  $(FIRST_MAKEFILE) $(MAKEFILE_OLD) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: '\''Watch out!'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''Stephen Thirlwall <sdt@cpan.org>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Spec: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Temp: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  HTTP::Headers: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  HTTP::Response: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  IO::Handle: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  IPC::Open3: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::Builder: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::FailWarnings: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::More: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::Most: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Time::Fake: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  lib: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  strict: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 7.76, CPAN::Meta::Converter version 2.150010'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: perl' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: '\''1.4'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: App-Watchman' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  Class::Load: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Config::General: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DBD::SQLite: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DBIx::Class::Core: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DBIx::Class::ResultClass::HashRefInflator: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DBIx::Class::ResultSet: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DBIx::Class::Schema: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Data::Dumper::Concise: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DateTime: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  DateTime::Format::Strptime: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Email::Sender::Simple: '\''0.120002'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Email::Simple: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::HomeDir: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Spec: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Function::Parameters: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  IO::Interactive: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  JSON: v2.61.0' >> META_new.yml
	$(NOECHO) $(ECHO) '  LWP::UserAgent: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  List::Util: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Log::Any: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Log::Any::Adapter: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Log::Any::Plugin: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Moo: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  MooX::Types::MooseLike::Base: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  MooX::Types::MooseLike::Email: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Number::Bytes::Human: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  SQL::Translator: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Sys::Hostname: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Template: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Try::Tiny: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  URI: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  URI::Escape: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  WWW::TMDB::API: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  base: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  namespace::autoclean: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  perl: '\''5.034000'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  warnings: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: '\''0.022'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'x_serialization_backend: '\''CPAN::Meta::YAML version 0.018'\''' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "Watch out!",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "Stephen Thirlwall <sdt@cpan.org>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 7.76, CPAN::Meta::Converter version 2.150010",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "perl_5"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : 2' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "App-Watchman",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "Class::Load" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Config::General" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DBD::SQLite" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DBIx::Class::Core" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DBIx::Class::ResultClass::HashRefInflator" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DBIx::Class::ResultSet" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DBIx::Class::Schema" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Data::Dumper::Concise" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DateTime" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DateTime::Format::Strptime" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Email::Sender::Simple" : "0.120002",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Email::Simple" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::HomeDir" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Spec" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Function::Parameters" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "IO::Interactive" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "JSON" : "v2.61.0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "LWP::UserAgent" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "List::Util" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Log::Any" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Log::Any::Adapter" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Log::Any::Plugin" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Moo" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "MooX::Types::MooseLike::Base" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "MooX::Types::MooseLike::Email" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Number::Bytes::Human" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "SQL::Translator" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Sys::Hostname" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Template" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Try::Tiny" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "URI" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "URI::Escape" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "WWW::TMDB::API" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "base" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "namespace::autoclean" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "perl" : "5.034000",' >> META_new.json
	$(NOECHO) $(ECHO) '            "warnings" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "test" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Spec" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Temp" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "HTTP::Headers" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "HTTP::Response" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "IO::Handle" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "IPC::Open3" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::Builder" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::FailWarnings" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::More" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::Most" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Time::Fake" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "lib" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "strict" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "stable",' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : "0.022",' >> META_new.json
	$(NOECHO) $(ECHO) '   "x_serialization_backend" : "JSON::PP version 4.16"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:
ci :
	$(ABSPERLRUN) -MExtUtils::Manifest=maniread -e '@all = sort keys %{ maniread() };' \
	  -e 'print(qq{Executing $(CI) @all\n});' \
	  -e 'system(qq{$(CI) @all}) == 0 or die $$!;' \
	  -e 'print(qq{Executing $(RCS_LABEL) ...\n});' \
	  -e 'system(qq{$(RCS_LABEL) @all}) == 0 or die $$!;' --


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or die "Could not add META.yml to MANIFEST: $${'\''@'\''}"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or die "Could not add META.json to MANIFEST: $${'\''@'\''}"' --



# --- MakeMaker distsignature section:
distsignature : distmeta
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or die "Could not add SIGNATURE to MANIFEST: $${'\''@'\''}"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLPRIVLIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLARCHLIB)" \
		"$(INST_BIN)" "$(DESTINSTALLBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLSCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLMAN3DIR)"
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		"$(SITEARCHEXP)/auto/$(FULLEXT)"


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(SITEARCHEXP)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLSITELIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLSITEARCH)" \
		"$(INST_BIN)" "$(DESTINSTALLSITEBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLSITESCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLSITEMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLSITEMAN3DIR)"
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		"$(PERL_ARCHLIB)/auto/$(FULLEXT)"

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLVENDORLIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLVENDORARCH)" \
		"$(INST_BIN)" "$(DESTINSTALLVENDORBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLVENDORSCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLVENDORMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLVENDORMAN3DIR)"


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) "$(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist"

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) "$(SITEARCHEXP)/auto/$(FULLEXT)/.packlist"

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) "$(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist"


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = "/usr/bin/perl"
MAP_PERLINC   = "-Iblib/arch" "-Iblib/lib" "-I/usr/lib/x86_64-linux-gnu/perl/5.40" "-I/usr/share/perl/5.40"

$(MAP_TARGET) :: $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : static $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR="" \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:
TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)
	$(NOECHO) $(NOOP)

test :: $(TEST_TYPE)
	$(NOECHO) $(NOOP)

# Occasionally we may face this degenerate target:
test_ : test_dynamic
	$(NOECHO) $(NOOP)

subdirs-test_dynamic :: dynamic pure_all

test_dynamic :: subdirs-test_dynamic
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: dynamic pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

subdirs-test_static :: static pure_all

test_static :: subdirs-test_static
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_static :: static pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)



# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="App-Watchman" VERSION="0.022">' > App-Watchman.ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>Watch out!</ABSTRACT>' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Stephen Thirlwall &lt;sdt@cpan.org&gt;</AUTHOR>' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <PERLCORE VERSION="5,034000,0,0" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Class::Load" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Config::General" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBD::SQLite" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class::Core" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class::ResultClass::HashRefInflator" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class::ResultSet" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class::Schema" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Data::Dumper::Concise" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DateTime::" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DateTime::Format::Strptime" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Email::Sender::Simple" VERSION="0.120002" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Email::Simple" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::HomeDir" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Spec" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Function::Parameters" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="IO::Interactive" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="JSON::" VERSION="v2.61.0" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="LWP::UserAgent" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="List::Util" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Log::Any" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Log::Any::Adapter" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Log::Any::Plugin" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Moo::" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="MooX::Types::MooseLike::Base" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="MooX::Types::MooseLike::Email" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Number::Bytes::Human" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="SQL::Translator" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Sys::Hostname" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Template::" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Try::Tiny" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="URI::" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="URI::Escape" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="WWW::TMDB::API" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="base::" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="namespace::autoclean" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="warnings::" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-gnu-thread-multi-5.40" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> App-Watchman.ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> App-Watchman.ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e '$$i=0; $$n=$$#ARGV; $$i++ until $$i > $$n or $$ARGV[$$i] eq q{--};' \
	  -e 'die q{Failed to find -- in }.join(q{|},@ARGV) if $$i > $$n;' \
	  -e '@parts=splice @ARGV,0,$$i+1;' \
	  -e 'pop @parts; $$filter=join q{ }, map qq{"$$_"}, @parts;' \
	  -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', $$filter, '\''$(PERM_DIR)'\'')' -- $(PM_FILTER) -- \
	  'lib/App/Watchman.pm' 'blib/lib/App/Watchman.pm' \
	  'lib/App/Watchman/Config.pm' 'blib/lib/App/Watchman/Config.pm' \
	  'lib/App/Watchman/EmailFormatter.pm' 'blib/lib/App/Watchman/EmailFormatter.pm' \
	  'lib/App/Watchman/Mailer.pm' 'blib/lib/App/Watchman/Mailer.pm' \
	  'lib/App/Watchman/Newznab.pm' 'blib/lib/App/Watchman/Newznab.pm' \
	  'lib/App/Watchman/Schema.pm' 'blib/lib/App/Watchman/Schema.pm' \
	  'lib/App/Watchman/Schema/Result/Movie.pm' 'blib/lib/App/Watchman/Schema/Result/Movie.pm' \
	  'lib/App/Watchman/Schema/ResultSet.pm' 'blib/lib/App/Watchman/Schema/ResultSet.pm' \
	  'lib/App/Watchman/Schema/ResultSet/Movie.pm' 'blib/lib/App/Watchman/Schema/ResultSet/Movie.pm' \
	  'lib/App/Watchman/TMDB.pm' 'blib/lib/App/Watchman/TMDB.pm' 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:

# here so even if top_targets is overridden, these will still be defined
# gmake will silently still work if any are .PHONY-ed but nmake won't

test_static ::
	$(NOECHO) $(NOOP)

test_dynamic ::
	$(NOECHO) $(NOOP)

static ::
	$(NOECHO) $(NOOP)

dynamic ::
	$(NOECHO) $(NOOP)

config ::
	$(NOECHO) $(NOOP)


# --- MakeMaker postamble section:


# End.
