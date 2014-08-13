#
# AR-P buildsystem smart Makefile
#
package[[ target_libjpeg

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 9a
PR_${P} = 1

PN_${P} = jpeg

call[[ base ]]

rule[[
  extract:http://www.ijg.org/files/jpegsrc.v${PV}.tar.gz
  patch:file://jpeg.diff
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
			--enable-shared \
			--enable-static \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libjpeg8
DESCRIPTION_${P} = libjpeg contains a library for handling the JPEG (JFIF) image format, as \
 well as related programs for accessing the libjpeg functions.
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so* 

call[[ ipkbox ]]

]]package
