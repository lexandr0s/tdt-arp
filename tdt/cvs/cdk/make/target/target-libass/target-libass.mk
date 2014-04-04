#
# AR-P buildsystem smart Makefile
#
package[[ target_libass

BDEPENDS_${P} = $(target_glibc) $(target_freetype) $(target_libfribidi)

PV_${P} = 0.10.2
PR_${P} = 1

DESCRIPTION_${P} = libass

call[[ base ]]

rule[[
  extract:http://${PN}.googlecode.com/files/${PN}-${PV}.tar.gz
]]rule

CONFIG_FLAGS_${P} = \
		--disable-fontconfig \
		--disable-enca 

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
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

RDEPENDS_${P} += libfreetype6 libfribidi0
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
