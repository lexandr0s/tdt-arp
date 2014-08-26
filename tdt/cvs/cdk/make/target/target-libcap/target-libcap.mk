#
# AR-P buildsystem smart Makefile
#
package[[ target_libcap

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.22
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://mirror.linux.org.au/linux/libs/security/linux-privs/${PN}2/${PN}-${PV}.tar.bz2
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(MAKE) \
		DESTDIR=$(PKDIR) \
		LIBDIR=$(PKDIR)/lib \
		PAM_CAP=no \
		LIBATTR=no \
		CC=$(target)-gcc \
		BUILD_CC=gcc
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	$(MAKE) install \
	DESTDIR=$(PKDIR) \
	LIBDIR=$(PKDIR)/lib \
	PAM_CAP=no \
	LIBATTR=no \
	CC=$(target)-gcc \
	BUILD_CC=gcc
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Library for getting/setting POSIX.1e capabilities
PACKAGES_${P} = libcap2 \
		libcap_bin

RDEPENDS_libcap2 = libc6
define postinst_libcap2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libcap2 = /lib/*.so*

RDEPENDS_libcap_bin = libc6 libcap2
FILES_libcap_bin = /sbin/*

call[[ ipkbox ]]

]]package
