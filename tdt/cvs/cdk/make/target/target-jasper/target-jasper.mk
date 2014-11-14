#
# AR-P buildsystem smart Makefile
#
package[[ target_jasper

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.900.1
PR_${P} = 1

call[[ base ]]

rule[[
   extract:http://www.ece.uvic.ca/~mdadams/${PN}/software/${PN}-${PV}.zip
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
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

NAME_${P} = libpcre
DESCRIPTION_${P} = JasPer is a collection of software (i.e., a library and application programs) for the coding and manipulation of images.\
This software can handle image data in a variety of formats.
RDEPENDS_${P} = libc6
FILES_${P} = /usr/bin/*

call[[ ipkbox ]]

]]package
