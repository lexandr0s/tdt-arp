#
# AR-P buildsystem smart Makefile
#
package[[ target_flac

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.3.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.xiph.org/releases/${PN}/${PN}-${PV}.tar.xz
  patch:file://${PN}-${PV}.patch
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
			--disable-ogg \
			--disable-oggtest \
			--disable-id3libtest \
			--disable-asm-optimizations \
			--disable-doxygen-docs \
			--disable-xmms-plugin \
			--without-xmms-prefix \
			--without-xmms-exec-prefix \
			--without-libiconv-prefix \
			--without-id3lib \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libflac8 libflacpp6
DESCRIPTION_${P} = FLAC stands for Free Lossless Audio Codec, an audio format similar to MP3, but lossless.

FILES_libflac8 = /usr/lib/libFLAC.so.*

NAME_libflacpp6 = libflac++6
RDEPENDS_libflacpp6 = libgcc1 libogg0 libflac8 libstdc
FILES_libflacpp6 = /usr/lib/libFLAC++.so.*

call[[ ipkbox ]]

]]package
