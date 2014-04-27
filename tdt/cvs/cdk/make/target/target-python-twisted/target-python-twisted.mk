#
# AR-P buildsystem smart Makefile
#
package[[ target_python_twisted

BDEPENDS_${P} = $(target_python_zopeinterface)

PV_${P} = 12.0.0
PR_${P} = 1

DIR_${P} = $(WORK_${P})/Twisted-${PV}

call[[ base ]]

rule[[
  extract:http://twistedmatrix.com/Releases/Twisted/12.0/Twisted-${PV}.tar.bz2
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = \
	python_twisted_conch \
	python_twisted_core \
	python_twisted_lore \
	python_twisted_mail \
	python_twisted_names \
	python_twisted_news \
	python_twisted_pair \
	python_twisted_protocols \
	python_twisted_runner \
	python_twisted_test \
	python_twisted_web \
	python_twisted_words \
	python_twisted_zsh \
	python_twisted

DESCRIPTION_python_twisted = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including \
 HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more
RDEPENDS_python_twisted = python_twisted_news python_twisted_lore python_twisted_conch python_twisted_names python_twisted_words \
python_twisted_runner python_core python_twisted_web python_twisted_mail
FILES_python_twisted = \

DESCRIPTION_python_twisted_conch = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including \
 HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more
RDEPENDS_python_twisted_conch = python_twisted_core python_twisted_protocols
FILES_python_twisted_conch = \
  /usr/bin/cftp \
  /usr/bin/ckeygen \
  /usr/bin/conch \
  /usr/bin/tkconch \
  $(PYTHON_DIR)/site-packages/twisted/conch/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/conch/client \
  $(PYTHON_DIR)/site-packages/twisted/conch/insults \
  $(PYTHON_DIR)/site-packages/twisted/conch/openssh_compat \
  $(PYTHON_DIR)/site-packages/twisted/conch/scripts \
  $(PYTHON_DIR)/site-packages/twisted/conch/ssh \
  $(PYTHON_DIR)/site-packages/twisted/conch/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/conch/ui \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_conch.p*

DESCRIPTION_python_twisted_core = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_core = python_core python_zopeinterface libc6
FILES_python_twisted_core = \
  /usr/bin/manhole \
  /usr/bin/pyhtmlizer \
  /usr/bin/tap2deb \
  /usr/bin/tap2rpm \
  /usr/bin/tapconvert \
  /usr/bin/trial \
  /usr/bin/twistd \
  $(PYTHON_DIR)/site-packages/twisted/application/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/cred \
  $(PYTHON_DIR)/site-packages/twisted/enterprise \
  $(PYTHON_DIR)/site-packages/twisted/internet/*.* \
  $(PYTHON_DIR)/site-packages/twisted/internet/iocpreactor \
  $(PYTHON_DIR)/site-packages/twisted/manhole/ui \
  $(PYTHON_DIR)/site-packages/twisted/manhole/*.* \
  $(PYTHON_DIR)/site-packages/twisted/persisted/journal \
  $(PYTHON_DIR)/site-packages/twisted/persisted/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/__init__.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_anonymous.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_file.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_memory.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/cred_unix.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_ftp.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_inet.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_manhole.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_portforward.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_qtstub.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_reactors.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_runner.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_socks.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_telnet.* \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_trial.* \
  $(PYTHON_DIR)/site-packages/twisted/python/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/scripts/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/spread \
  $(PYTHON_DIR)/site-packages/twisted/tap \
  $(PYTHON_DIR)/site-packages/twisted/trial/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/__init__.p* \
  $(PYTHON_DIR)/site-packages/twisted/_version.p* \
  $(PYTHON_DIR)/site-packages/twisted/copyright.p* \
  $(PYTHON_DIR)/site-packages/twisted/plugin.p*

DESCRIPTION_python_twisted_lore = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_lore = python_twisted_core
FILES_python_twisted_lore = \
  /usr/bin/lore \
  $(PYTHON_DIR)/site-packages/twisted/lore/*.* \
  $(PYTHON_DIR)/site-packages/twisted/lore/scripts \
  $(PYTHON_DIR)/site-packages/twisted/lore/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_lore.*

DESCRIPTION_python_twisted_mail = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_mail = python_twisted_core python_twisted_protocols
FILES_python_twisted_mail = \
  /usr/bin/mailmail \
  $(PYTHON_DIR)/site-packages/twisted/mail/*.* \
  $(PYTHON_DIR)/site-packages/twisted/mail/scripts \
  $(PYTHON_DIR)/site-packages/twisted/mail/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_mail.*

DESCRIPTION_python_twisted_names = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_names = python_twisted_core
FILES_python_twisted_names = \
  $(PYTHON_DIR)/site-packages/twisted/names/*.* \
  $(PYTHON_DIR)/site-packages/twisted/names/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_names.*

DESCRIPTION_python_twisted_news = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_news = python_twisted_core python_twisted_protocols
FILES_python_twisted_news = \
  $(PYTHON_DIR)/site-packages/twisted/news/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/news/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_news.*

DESCRIPTION_python_twisted_pair = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_pair = python_twisted_core
FILES_python_twisted_pair = \
  $(PYTHON_DIR)/site-packages/twisted/pair/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/pair/topfiles

DESCRIPTION_python_twisted_protocols = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
FILES_python_twisted_protocols = \
  $(PYTHON_DIR)/site-packages/twisted/protocols/*.p* \
  $(PYTHON_DIR)/site-packages/twisted/protocols/mice \
  $(PYTHON_DIR)/site-packages/twisted/protocols/gps

DESCRIPTION_python_twisted_runner = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_runner = python_twisted_core python_twisted_protocols libc6
FILES_python_twisted_runner = \
  $(PYTHON_DIR)/site-packages/twisted/runner/*.* \
  $(PYTHON_DIR)/site-packages/twisted/runner/topfiles

DESCRIPTION_python_twisted_test = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_test = python_twisted libc6
FILES_python_twisted_test = \
  $(PYTHON_DIR)/site-packages/twisted/application/test \
  $(PYTHON_DIR)/site-packages/twisted/conch/test \
  $(PYTHON_DIR)/site-packages/twisted/internet/test \
  $(PYTHON_DIR)/site-packages/twisted/lore/test \
  $(PYTHON_DIR)/site-packages/twisted/mail/test \
  $(PYTHON_DIR)/site-packages/twisted/manhole/test \
  $(PYTHON_DIR)/site-packages/twisted/names/test \
  $(PYTHON_DIR)/site-packages/twisted/news/test \
  $(PYTHON_DIR)/site-packages/twisted/pair/test \
  $(PYTHON_DIR)/site-packages/twisted/persisted/test \
  $(PYTHON_DIR)/site-packages/twisted/protocols/test \
  $(PYTHON_DIR)/site-packages/twisted/python/test \
  $(PYTHON_DIR)/site-packages/twisted/runner/test \
  $(PYTHON_DIR)/site-packages/twisted/scripts/test \
  $(PYTHON_DIR)/site-packages/twisted/test \
  $(PYTHON_DIR)/site-packages/twisted/trial/test \
  $(PYTHON_DIR)/site-packages/twisted/web/test \
  $(PYTHON_DIR)/site-packages/twisted/words/test

DESCRIPTION_python_twisted_web = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_web = python_twisted_core python_twisted_protocols
FILES_python_twisted_web = \
  $(PYTHON_DIR)/site-packages/twisted/web/*.* \
  $(PYTHON_DIR)/site-packages/twisted/web/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/web/_auth \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_web.*

DESCRIPTION_python_twisted_words = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
RDEPENDS_python_twisted_words = python_twisted_core
FILES_python_twisted_words = \
  $(PYTHON_DIR)/site-packages/twisted/words/*.* \
  $(PYTHON_DIR)/site-packages/twisted/words/im \
  $(PYTHON_DIR)/site-packages/twisted/words/protocols \
  $(PYTHON_DIR)/site-packages/twisted/words/topfiles \
  $(PYTHON_DIR)/site-packages/twisted/words/xish \
  $(PYTHON_DIR)/site-packages/twisted/plugins/twisted_words.*

DESCRIPTION_python_twisted_zsh = Twisted is an event-driven networking framework written in Python and \
 licensed under the LGPL. Twisted supports TCP, UDP, SSL/TLS, multicast,\
 Unix sockets, a large number of protocols (including HTTP, NNTP, IMAP, SSH, IRC, FTP, and others), and much more.
FILES_python_twisted_zsh = \
  $(PYTHON_DIR)/site-packages/twisted/python/zshc* \
  $(PYTHON_DIR)/site-packages/twisted/python/zsh

call[[ ipkbox ]]

]]package