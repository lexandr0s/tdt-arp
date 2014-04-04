#
# AR-P buildsystem smart Makefile
#
package[[ target_libpng

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 1.6.8
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://prdownloads.sourceforge.net/libpng/${PN}-${PV}.tar.gz
  nothing:file://${PN}.diff
  patch:file://${PN}-workaround_for_stmfb_alpha_error.patch
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
			--enable-maintainer-mode \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	$(call rewrite_config, $(PKDIR)/usr/bin/libpng-config)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libpng16
DESCRIPTION_libpng16 = libpng
RDEPENDS_libpng16 = libz1 libc6
FILES_libpng16 = /usr/lib/*.so*

call[[ ipkbox ]]

]]package