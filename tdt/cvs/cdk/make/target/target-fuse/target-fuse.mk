#
# AR-P buildsystem smart Makefile
#
package[[ target_fuse

BDEPENDS_${P} = $(target_glibc) $(target_glib2)

PV_${P} = 2.9.3
PR_${P} = 2

call[[ base ]]

rule[[
  extract:http://dfn.dl.sourceforge.net/sourceforge/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
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
			--target=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR) && \
	ln -sf sh4-linux-fusermount $(PKDIR)/usr/bin/fusermount && \
	ln -sf sh4-linux-ulockmgr_server $(PKDIR)/usr/bin/ulockmgr_server && \
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libfuse2 libulockmgr1 fuse_utils

DESCRIPTION_${P} = With FUSE it is possible to implement a fully functional filesystem in a \
 userspace program  FUSE (Filesystem in Userspace) is a simple interface \
 for userspace   programs to export a virtual filesystem to the Linux \
 kernel.  FUSE also   aims to provide a secure method for non privileged \
 users to create and   mount their own filesystem implementations.

RDEPENDS_libfuse2 = libc6
define postinst_libfuse2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libfuse2 = /usr/lib/libfuse.so.*

RDEPENDS_libulockmgr1 = libc6
define postinst_libulockmgr1
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libulockmgr1 = /usr/lib/libulockmgr.so.*

RDEPENDS_fuse_utils = libc6
define postinst_fuse_utils
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ fuse start 34 S .
endef
define prerm_fuse_utils
#!/bin/sh
update-rc.d -f -r $$OPKG_OFFLINE_ROOT/ fuse remove
endef
FILES_fuse_utils = /etc/init.d/fuse /etc/udev/* /sbin/mount.fuse /usr/bin/*

call[[ ipkbox ]]

]]package
