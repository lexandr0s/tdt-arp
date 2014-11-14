#
# AR-P buildsystem smart Makefile
#
package[[ target_libgpg_error

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.16
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.gnupg.org/gcrypt/${PN}/${PN}-${PV}.tar.bz2
  patch:file://pkgconfig.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Libgpg-error is a small library that defines common error values for all GnuPG components. \
Among these are GPG, GPGSM, GPGME, GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard Daemon and possibly more in the future
RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/libgpg-error.so.*

call[[ ipkbox ]]

]]package
