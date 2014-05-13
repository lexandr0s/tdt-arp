#
# AR-P buildsystem smart Makefile
#
package[[ target_vsftpd

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 3.0.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://fossies.org/unix/misc/${PN}-${PV}.tar.gz
  patch:file://${PN}_${PV}.diff

  install:-d:$(PKDIR)/etc/init.d
  install_bin:$(PKDIR)/etc/init.d/vsftpd:file://vsftpd
  install_file:$(PKDIR)/etc/vsftpd.conf:file://vsftpd.conf
]]rule

MAKE_FLAGS_${P} = $(MAKE_OPTS) CFLAGS="-pipe -Os -g0" PREFIX=$(PKDIR)

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(MAKE) $(MAKE_FLAGS_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	install -d $(PKDIR)/usr/bin
	install -d $(PKDIR)/etc
	install -d $(PKDIR)/usr/share/man/man{5,8}

	cd $(DIR_${P}) && $(MAKE) $(MAKE_FLAGS_${P}) install DESTDIR=$(PKDIR)
	cd $(DIR_${P}) && $(INSTALL_${P})
	
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = ftp server
FILES_${P} = \
	/etc/* \
	/usr/bin/*

define preinst_${P}
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/vsftpd" ]; then
	/etc/init.d/vsftpd stop
fi
endef

define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ vsftpd start 20 3 .
endef

define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ vsftpd remove
endef

define postrm_${P}
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/vsftpd" ]; then
	/etc/init.d/vsftpd start
fi
endef

call[[ ipkbox ]]

]]package