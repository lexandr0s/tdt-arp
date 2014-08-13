#
# AR-P buildsystem smart Makefile
#
package[[ target_libgif

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 5.1.0
PR_${P} = 1

PN_${P} = giflib

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/giflib/files/giflib-${PV}.tar.gz
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
			--without-x \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libgif4
DESCRIPTION_${P} =  shared library for GIF images
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
