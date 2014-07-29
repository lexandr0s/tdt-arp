#
# AR-P buildsystem smart Makefile
#
package[[ target_libcdio

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.82
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.gnu.org/gnu/${PN}/${PN}-${PV}.tar.gz
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
			--disable-rpath \
			ac_cv_member_struct_tm_tm_gmtoff=no \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	rm -r $(PKDIR)/usr/share/info/dir
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = The GNU Compact Disc Input and Control library (libcdio) contains a library for CD-ROM and CD image access.
PACKAGES_${P} = \
	libcdio_cdda0 \
	libcdioxx0 \
	libcdio_paranoia0 \
	libcdio_utils \
	libcdio12 \
	libiso9660xx0 \
	libiso9660 \
	libudf0


RDEPENDS_libcdio12 = libc6
define postinst_libcdio12
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdio12 = /usr/lib/libcdio.so.*

RDEPENDS_libcdio_cdda0 = libcdio12 libc6
define postinst_libcdio_cdda0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdio_cdda0 = /usr/lib/libcdio_cdda.so.*

RDEPENDS_libcdio_paranoia0 = libcdio12 libc6 libcdio_cdda0
define postinst_libcdio_paranoia0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdio_paranoia0 = /usr/lib/libcdio_paranoia.so.*

NAME_libcdioxx0 = libcdio++0
RDEPENDS_libcdioxx0 = libgcc1 libstdc++6 libcdio12 libc6
define postinst_libcdioxx0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libcdioxx0 = /usr/lib/libcdio++.so.*

RDEPENDS_libiso9660 = libcdio12 libc6
define postinst_libiso9660
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libiso9660 = /usr/lib/libiso9660.so.*

NAME_libiso9660xx0 = libiso9660++0
RDEPENDS_libiso9660xx0 = libgcc1 libiso9660 libcdio12 libstdc++6 libc6
define postinst_libiso9660xx0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libiso9660xx0 = /usr/lib/libiso9660++.so.*

RDEPENDS_libudf0 = libcdio12 libc6
define postinst_libudf0
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libudf0 = /usr/lib/libudf.so.*



RDEPENDS_libcdio_utils = libcdio12 libc6 libcdio_cdda0 libcdio_paranoia0 libncurses5
FILES_libcdio_utils = /usr/bin/*

call[[ ipkbox ]]

]]package
