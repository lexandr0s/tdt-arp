#
# AR-P buildsystem smart Makefile
#
package[[ target_libbluray

BDEPENDS_${P} = $(target_glibc) $(target_libaacs)

PV_${P} = 0.6.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://download.videolan.org/pub/videolan/${PN}/${PV}/${PN}-${PV}.tar.bz2
  patch:file://${PN}-0001-Optimized-file-I-O-for-chained-usage-with-libavforma.patch
  patch:file://${PN}-0003-Added-bd_get_clip_infos.patch
  patch:file://${PN}-0005-Don-t-abort-demuxing-if-the-disc-looks-encrypted.patch
  patch:file://${PN}-0006-disable-M2TS_TRACE.patch
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
			--without-libxml2 \
			--without-freetype \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = libbluray is an open-source library designed for Blu-Ray Discs playback for media players
RDEPENDS_${P} = libdvdread4 libdvdnav4 libc6 libaacs
FILES_${P} = /usr/lib/*.so*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
