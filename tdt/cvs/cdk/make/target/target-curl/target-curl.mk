#
# AR-P buildsystem smart Makefile
#
package[[ target_curl

BDEPENDS_${P} = 

PV_${P} = 7.37.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://${PN}.haxx.se/download/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--with-ssl \
		--disable-debug \
		--disable-file \
		--disable-rtsp \
		--disable-dict \
		--disable-imap \
		--disable-pop3 \
		--disable-smtp \
		--disable-verbose \
		--disable-manual \
		--mandir=/usr/share/man \
		--with-random \
	&& \
	make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(hostprefix)/bin/curl-config; \
	chmod 755 $(hostprefix)/bin/curl-config; \
	$(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Command line tool and library for client-side URL transfers
PACKAGES_${P} = libcurl4 \
		curl

RDEPENDS_libcurl4 = libcap2 libz1 librtmp1 libc6
define postinst_libcurl4
#!/bin/sh
if [ x"$$OPKG_OFFLINE_ROOT" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcurl4 = /usr/lib/*.so*

RDEPENDS_curl = libcurl4 libz1 libc6
FILES_curl = /usr/bin/curl

call[[ ipkbox ]]

]]package
