#
# AR-P buildsystem smart Makefile
#
package[[ target_libfribidi

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.19.5
PR_${P} = 1

PN_${P} = fribidi

call[[ base ]]

rule[[
  extract:http://fribidi.org/download/${PN}-${PV}.tar.bz2
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
			--enable-memopt \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libfribidi0 libfribidi_bin
DESCRIPTION_${P} = Fribidi library for bidirectional text

RDEPENDS_libfribidi0 = libc6
FILES_libfribidi0 = /usr/lib/*.so*

RDEPENDS_libfribidi_bin = libfribidi0 libc6
FILES_libfribidi_bin = /usr/bin/*

call[[ ipkbox ]]

]]package
