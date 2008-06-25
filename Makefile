# $Id: Makefile,v 1.6.1.3 2006/11/01 07:45:28 izto Exp $

# Where to install.
PREFIX=/usr/local
BINDIR=$(PREFIX)/sbin
LCDIR=$(PREFIX)/lib/checkinstall/locale
CONFDIR=$(PREFIX)/lib/checkinstall

all:
	for file in locale/checkinstall-*.po ; do \
		case $${file} in \
			locale/checkinstall-template.po)  ;; \
			*) \
				out=`echo $$file | sed -s 's/po/mo/'` ; \
				msgfmt -o $${out} $${file} ; \
				if [ $$? != 0 ] ; then \
					exit 1 ; \
				fi ; \
			;; \
		esac ; \
	done	
	make -C installwatch-0.7.0beta5
	
install: all
	export
	make -C installwatch-0.7.0beta5 install
	
	mkdir -p $(BINDIR)
	install checkinstall makepak $(BINDIR)
	for file in locale/*.mo ; do \
		LANG=`echo $$file | sed -e 's|locale/checkinstall-||' \
			-e 's|\.mo||'` && \
		mkdir -p $(LCDIR)/$${LANG}/LC_MESSAGES && \
		cp $$file $(LCDIR)/$${LANG}/LC_MESSAGES/checkinstall.mo || \
		exit 1 ; \
	done
	
	mkdir -p $(CONFDIR)
	install -m644  checkinstallrc-dist $(CONFDIR)
	if ! [ -f $(CONFDIR)/checkinstallrc ]; then \
		cp $(CONFDIR)/checkinstallrc-dist $(CONFDIR)/checkinstallrc; \
	else \
		echo; \
		echo; \
		echo ======================================================== ;\
		echo; \
		echo An existing checkinstallrc file has been found. ;\
		echo The one from this distribution can be found at: ; \
		echo; \
		echo -e \\t$(CONFDIR)/checkinstallrc-dist ; \
		echo; \
		echo; \
		echo ======================================================== ;\
		echo; \
	fi
	
clean:
	for file in locale/checkinstall-*.mo ; do \
		rm -f $${file} ; \
	done
	make -C installwatch-0.7.0beta5 clean
