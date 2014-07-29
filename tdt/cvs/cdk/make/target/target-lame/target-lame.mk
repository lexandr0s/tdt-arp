#
# AR-P buildsystem smart Makefile
#
package[[ target_lame

BDEPENDS_${P} = $(target_glibc) $(target_ncurses)

PV_${P} = 3.99.5
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/project/${PN}/${PN}/3.99/${PN}-${PV}.tar.gz
  patch:file://no-gtk1.patch
  patch:file://${PN}-${PV}_fix_for_automake-1.12.x.patch
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
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]


DESCRIPTION_${P} = Userspace library to access USB (version 1.0)
PACKAGES_${P} = lame libmp3lame

RDEPENDS_lame = libtinfo5 libc6
FILES_lame = /usr/bin/lame

RDEPENDS_libmp3lame = libc6
define postinst_libmp3lame
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libmp3lame = /usr/lib/libmp3lame.so.*

call[[ ipkbox ]]

]]package
