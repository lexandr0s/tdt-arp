#
# AR-P buildsystem smart Makefile
#
package[[ target_transmission

BDEPENDS_${P} = $(target_libevent) $(target_curl)

PV_${P} = 2.84
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://download-origin.transmissionbt.com/files/${PN}-${PV}.tar.xz
  nothing:file://transmission.init
  nothing:file://transmission.json
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--disable-nls \
			--disable-mac \
			--disable-libappindicator \
			--disable-libcanberra \
			--with-gnu-ld \
			--enable-daemon \
			--enable-cli \
			--disable-gtk \
			--enable-largefile \
			--enable-lightweight \
			--build=$(build) \
			--host=$(target) \
			&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	
	$(INSTALL_DIR) $(PKDIR)/etc && \
	$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/transmission && \
	$(INSTALL_FILE) $(DIR_${P})/transmission.json $(PKDIR)/etc/transmission/settings.json && \
	$(INSTALL_BIN) $(DIR_${P})/transmission.init $(PKDIR)/etc/init.d/transmission
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = A free, lightweight BitTorrent client
RDEPENDS_${P} = libevent libcurl4 libssl1
define conffiles_${P}
/etc/transmission/settings.json
endef
define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ transmission start 100 S . stop 2 6 .
endef
define postrm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ transmission remove
endef

FILES_${P} = /etc \
/usr/bin/* \
/usr/share/transmission/*

call[[ ipkbox ]]

]]package
