#
# AR-P buildsystem smart Makefile
#
package[[ target_aio_grab

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://git.code.sf.net/p/openpli/${PN}.git:r=ef31eca61832b31f28f69157dfe5f850a3cab916
  patch:file://${PN}-ADD_ST_SUPPORT.patch
  patch:file://${PN}-ADD_ST_FRAMESYNC_SUPPORT.patch
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf -i && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Screen grabber for Set-Top-Boxes
RDEPENDS_${P} = libpng16 libjpeg8 libc6

call[[ ipkbox ]]

]]package
