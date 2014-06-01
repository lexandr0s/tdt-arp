#
# AR-P buildsystem smart Makefile
#
package[[ target_curl

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 7.34.0
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
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	
	$(call rewrite_config, $(PKDIR)/usr/bin/curl-config)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Command line tool and library for client-side URL transfers
PACKAGES_${P} = libcurl4 curl

RDEPENDS_libcurl4 = libcap2 libz1 librtmp1 libc6
FILES_libcurl4 = /usr/lib/*.so*

RDEPENDS_curl = libcurl4 libz1 libc6
FILES_curl = /usr/bin/curl

call[[ ipkbox ]]

]]package
