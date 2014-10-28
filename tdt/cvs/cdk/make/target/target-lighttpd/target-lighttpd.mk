#
# AR-P buildsystem smart Makefile
#
package[[ target_lighttpd

BDEPENDS_${P} = $(target_fuse) $(target_pcre)

PV_${P} = 1.4.35
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.${PN}.net/download/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--exec-prefix=/usr \
			--datarootdir=/usr/share \
			&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	
	$(INSTALL) -d $(PKDIR)/etc/lighttpd && \
	$(INSTALL) -c -m644 $(DIR_${P})/doc/config/lighttpd.conf $(PKDIR)/etc/lighttpd && \
	$(INSTALL) -d $(PKDIR)/etc/init.d && \
	$(INSTALL) -c -m755 $(DIR_${P})/doc/initscripts/rc.lighttpd.redhat $(PKDIR)/etc/init.d/lighttpd

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = lighttpd powers several popular Web 2.0 sites
RDEPENDS_${P} = 
define postinst_${P}
#!/bin/sh
if [ -f /etc/lighttpd.conf ]; then mv /etc/lighttpd.conf /etc/lighttpd.conf.org; fi
update-rc.d -r $$OPKG_OFFLINE_ROOT/ lighttpd start 30 3 . stop 30 0 .
endef
define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ lighttpd remove
endef

FILES_${P} = /usr/bin/* \
/usr/sbin/* \
/usr/lib/*.so \
/etc/init.d/* \
/etc/lighttpd/*.conf 

call[[ ipkbox ]]

]]package
