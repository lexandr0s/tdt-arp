#
# AR-P buildsystem smart Makefile
#
package[[ target_libexif

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.6.21
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${PN}-${PV}.tar.gz
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
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libexif12
DESCRIPTION_${P} = libexif is a library for parsing, editing, and saving EXIF data.
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/libexif.*

call[[ ipkbox ]]

]]package
