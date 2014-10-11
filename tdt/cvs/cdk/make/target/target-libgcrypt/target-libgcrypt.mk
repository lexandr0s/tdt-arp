#
# AR-P buildsystem smart Makefile
#
package[[ target_libgcrypt

BDEPENDS_${P} = $(target_glibc) $(target_libgpg_error) $(target_libcap)

PV_${P} = 1.6.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.gnupg.org/gcrypt/${PN}/${PN}-${PV}.tar.gz
  patch:file://add-pkgconfig-support.patch
  patch:file://libgcrypt-01-dont_replace_parts_of_path-0.1.patch
  patch:file://fix-ICE-failure-on-mips-with-option-O-and-g.patch
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
			--disable-asm \
			--with-capabilities \
			--with-gpg-error-prefix=$(targetprefix)/usr \
			--prefix=/usr \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	rm $(PKDIR)/usr/share/info/dir
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = This is a general purpose cryptographic library based on the code from GnuPG.
RDEPENDS_${P} = libc6 libgpg_error libcap2
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/libgcrypt.s*

call[[ ipkbox ]]

]]package
