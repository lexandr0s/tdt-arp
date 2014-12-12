#
# AR-P buildsystem smart Makefile
#
package[[ target_libogg

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.3.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.xiph.org/releases/ogg/${PN}-${PV}.tar.xz
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

NAME_${P} = libogg0
DESCRIPTION_${P} = libogg is the bitstream and framing library for the Ogg project. \
It provides functions which are necessary to codec libraries like libvorbis.
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
