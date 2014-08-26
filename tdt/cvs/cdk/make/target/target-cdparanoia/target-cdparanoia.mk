#
# AR-P buildsystem smart Makefile
#
package[[ target_cdparanoia

BDEPENDS_${P} = $(target_glibc)

PV_${P} = III-10.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.xiph.org/releases/cdparanoia/${PN}-${PV}.src.tgz
  #patch:file://06-autoconf.patch
  patch:file://Makefile.in.patch
  patch:file://interface_Makefile.in.patch
  patch:file://paranoia_Makefile.in.patch
  patch:file://cdparanoia-III-10.2-privatefix.patch
  patch:file://configure.in.patch
]]rule

#call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install prefix=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

NAME_${P} = libcdparanoia
DESCRIPTION_${P} = Paranoia is a library that provides a unified, robust interface for Linux applications that want to use CDROM devices
RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
