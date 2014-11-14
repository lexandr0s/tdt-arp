#
# AR-P buildsystem smart Makefile
#
package[[ target_libaacs

BDEPENDS_${P} = $(target_glibc) $(target_libgcrypt)

PV_${P} = 0.7.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.videolan.org/pub/videolan/${PN}/${PV}/${PN}-${PV}.tar.bz2
  patch:file://libaacs-buildfix.patch
  nothing:http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-werror \
			--disable-extra-warnings \
			--disable-optimizations \
			--with-libgcrypt-prefix=$(targetprefix)/usr \
			--with-gpg-error-prefix=$(targetprefix)/usr \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = libaacs is a research project to implement the Advanced Access Content System specification.
RDEPENDS_${P} = libc6 libgcrypt libgpg_error
FILES_${P} = /usr/lib/libaacs.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
