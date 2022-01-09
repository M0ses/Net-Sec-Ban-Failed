PREFIX=/usr
BINDIR=$(PREFIX)/bin
LIBDIR=$(PREFIX)/lib/ban_failed
ETCDIR=$(PREFIX)/etc/ban_failed

all: bin lib etc

install: bin lib

bin:
	[ -d $(DESTDIR)/$(BINDIR) ] || mkdir -p $(DESTDIR)/$(BINDIR)
	install ./bin/ban_failed $(DESTDIR)$(BINDIR)/ban_failed

lib:
	[ -d $(DESTDIR)/$(LIBDIR)/Net/Sec/Ban ] || mkdir -p $(DESTDIR)/$(LIBDIR)/Net/Sec/Ban
	install ./lib/Net/Sec/Ban/Failed.pm $(DESTDIR)$(LIBDIR)/Net/Sec/Ban/Failed.pm

etc:
	[ -d $(DESTDIR)/$(ETCDIR) ] || mkdir -p $(DESTDIR)/$(ETCDIR)
	install ./etc/config.yml $(DESTDIR)/$(ETCDIR)/config.yml
	[ -f ./etc/config.local.yml ] && install ./etc/config.local.yml $(DESTDIR)/$(ETCDIR)/config.yml

test:
	PERL5LIB=./lib BAN_FAILED_CONFIG=./etc/config.local.yml bin/ban_failed
