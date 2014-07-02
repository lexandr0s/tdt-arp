#
# AR-P buildsystem smart Makefile
#
package[[ target_mediatomb

BDEPENDS_${P} = $(target_glibc) $(target_ffmpeg) $(target_curl) $(target_sqlite) $(target_expat)

PV_${P} = 0.12.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}_metadata.patch
]]rule

CONFIG_FLAGS_${P} = \
		--disable-ffmpegthumbnailer \
		--disable-libmagic \
		--disable-mysql \
		--disable-id3lib \
		--disable-taglib \
		--disable-lastfmlib \
		--disable-libexif \
		--disable-libmp4v2 \
		--disable-inotify \
		--with-avformat-h=$(targetprefix)/usr/include \
		--disable-rpl-malloc

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
		cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]


DESCRIPTION_${P} = MediaTomb is an open source (GPL) UPnP MediaServer with a nice web user interfaces
FILES_${P} = \
/usr/bin/* \
/usr/share/mediatomb/*


call[[ ipkbox ]]

]]package
