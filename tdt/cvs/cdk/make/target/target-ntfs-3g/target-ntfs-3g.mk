#
# AR-P buildsystem smart Makefile
#
package[[ target_ntfs_3g

BDEPENDS_${P} = $(target_glibc) $(target_fuse)

PV_${P} = 2014.2.15
PR_${P} = 1

DIR_${P} = ${WORK}/ntfs-3g_ntfsprogs-${PV}

call[[ base ]]

rule[[
  extract:http://tuxera.com/opensource/ntfs-3g_ntfsprogs-${PV}.tgz
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
			--disable-ldconfig \
			--enable-shared \
			--exec-prefix=/usr \
			--prefix=/usr \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = \
		ntfs_3g \
		libntfs_3g85 \
		ntfsprogs

DESCRIPTION_${P} = The NTFS-3G driver is an open source, freely available NTFS driver for \
 Linux with read and write support.
RDEPENDS_ntfs_3g = libc6 libfuse2 libntfs_3g85
FILES_ntfs_3g = /sbin/mount.n* \
               /usr/bin/ntfs-3*

RDEPENDS_ntfsprogs = libc6 libntfs_3g85
FILES_ntfsprogs = /sbin/mount.lowntfs-3g \
		  /sbin/mkfs.ntfs \
		  /usr/bin/lowntfs-3g \
		  /usr/bin/ntfscat \
		  /usr/bin/ntfscluster \
		  /usr/bin/ntfscmp \
		  /usr/bin/ntfsfix \
		  /usr/bin/ntfsinfo \
		  /usr/bin/ntfsls \
		  /usr/sbin/mkntfs \
		  /usr/sbin/ntfsclone \
		  /usr/sbin/ntfscp \
		  /usr/sbin/ntfslabel \
		  /usr/sbin/ntfsresize \
		  /usr/sbin/ntfsundelete

RDEPENDS_libntfs_3g85 = libc6
define postinst_libntfs_3g85
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libntfs_3g85 = /usr/lib/libntfs-3g.so.*

call[[ ipkbox ]]

]]package
