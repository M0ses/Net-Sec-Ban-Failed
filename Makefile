PREFIX=/usr
SBINDIR=$(PREFIX)/sbin
LIBDIR=$(PREFIX)/lib/ban-failed
ETCDIR=/etc/ban-failed
SYSTEMDDIR=/usr/lib/systemd/system

all: bin lib etc dist

install: bin lib

bin:
	[ -d $(DESTDIR)$(SBINDIR) ] || mkdir -p $(DESTDIR)$(SBINDIR)
	install ./bin/ban-failed $(DESTDIR)$(SBINDIR)/ban-failed

lib:
	[ -d $(DESTDIR)$(LIBDIR)/Net/Sec/Ban ] || mkdir -p $(DESTDIR)$(LIBDIR)/Net/Sec/Ban
	install ./lib/Net/Sec/Ban/Failed.pm $(DESTDIR)$(LIBDIR)/Net/Sec/Ban/Failed.pm

etc:
	[ -d $(DESTDIR)$(ETCDIR) ] || mkdir -p $(DESTDIR)$(ETCDIR)
	install ./etc/config.yml $(DESTDIR)$(ETCDIR)/config.yml
	[ -f ./etc/config.local.yml ] && install ./etc/config.local.yml $(DESTDIR)$(ETCDIR)/config.yml

dist:
	[ -d $(DESTDIR)$(SYSTEMDDIR) ] || mdkir -p $(DESTDIR)$(SYSTEMDDIR)
	install ./dist/ban-failed.service $(DESTDIR)$(SYSTEMDDIR)/ban-failed.service

test:
	PERL5LIB=./lib BAN_FAILED_CONFIG=./etc/config.local.yml bin/ban-failed

.PHONY: bin lib etc test dist
