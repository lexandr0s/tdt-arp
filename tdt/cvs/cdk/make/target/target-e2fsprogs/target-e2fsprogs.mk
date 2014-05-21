#
# AR-P buildsystem smart Makefile
#
package[[ target_e2fsprogs

BDEPENDS_${P} = $(target_glibc) $(target_util_linux)

PV_${P} = 1.42.8
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/${PN}/files/${PN}/v${PV}/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}.patch
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
			--enable-e2initrd-helper \
			--enable-compression \
			--disable-uuidd \
			--disable-rpath \
			--disable-quota \
			--disable-defrag \
			--disable-nls \
			--disable-fsck \
			--disable-libuuid \
			--disable-libblkid \
			--enable-elf-shlibs \
			--enable-verbose-makecmds \
			--enable-symlink-install \
			--without-libintl-prefix \
			--without-libiconv-prefix \
			--with-root-prefix= \
			&& \
		$(MAKE) all && \
		$(MAKE) -C e2fsck e2fsck.static
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install install-libs DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = e2fsprogs_badblocks \
		e2fsprogs_e2fsck \
		e2fsprogs_mke2fs \
		e2fsprogs_tune2fs \
		e2fsprogs_core \
		libcom_err2 \
		libe2p2 \
		libext2fs2 \
		libss2

DESCRIPTION_e2fsprogs_badblocks = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_2fsprogs_badblocks = libcom-err2 libext2fs2 libc6
FILES_e2fsprogs_badblocks = /sbin/badblocks

DESCRIPTION_e2fsprogs_e2fsck = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_e2fsprogs_e2fsck = libblkid1 libcom_err2 libe2p2 libc6 libext2fs2 libuuid1
FILES_e2fsprogs_e2fsck = /sbin/e2fsck

DESCRIPTION_e2fsprogs_mke2fs = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_e2fsprogs_mke2fs = libblkid1 libcom_err2 libe2p2 libc6 libext2fs2 libuuid1
FILES_e2fsprogs_mke2fs = /etc/mke2fs.conf \
			/sbin/mkfs* \
			/sbin/mke2fs

DESCRIPTION_e2fsprogs_tune2fs = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_e2fsprogs_tune2fs = libblkid1 libcom_err2 libe2p2 libc6 libext2fs2 libuuid1
FILES_e2fsprogs_tune2fs = /sbin/tune2fs \
			  /sbin/e2label

DESCRIPTION_e2fsprogs_core = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_e2fsprogs_core = libss2 libext2fs2 libcom_err2 libe2p2 libc6 e2fsprogs_badblocks libblkid1 libuuid1
FILES_e2fsprogs_core = /sbin/debugfs \
		  /sbin/dumpe2fs \
		  /sbin/e2image \
		  /sbin/e2undo \
		  /sbin/logsave \
		  /sbin/resize2fs \
		  /usr/bin/chattr \
		  /usr/bin/compile_et \
		  /usr/bin/lsattr \
		  /usr/bin/mk_cmds

DESCRIPTION_libcom_err2 = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
FILES_libcom_err2 = /lib/libcom_err.so.*

DESCRIPTION_libe2p2 = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
FILES_libe2p2 = /lib/libe2p.so.*

DESCRIPTION_libext2fs2 = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_libext2fs2 = libblkid1 libcom_err2
FILES_libext2fs2 = /lib/libext2fs.so.* \
		   /usr/lib/e2initrd_helper

DESCRIPTION_libss2 = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_libss2 = libcom_err2
FILES_libss2 = /lib/libss.so.*

call[[ ipkbox ]]

]]package
