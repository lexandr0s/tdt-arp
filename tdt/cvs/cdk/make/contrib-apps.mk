#
# bzip2
#
BEGIN[[
bzip2
  1.0.6
  {PN}-{PV}
  extract:http://www.bzip.org/{PV}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:PREFIX=PKDIR/usr
;
]]END

NAME_bzip2 = libbz2
DESCRIPTION_bzip2 = "bzip2"

FILES_bzip2 = \
/usr/bin/* \
/usr/lib/*

$(DEPDIR)/bzip2.do_prepare: bootstrap $(DEPENDS_bzip2)
	$(PREPARE_bzip2)
	touch $@

$(DEPDIR)/bzip2.do_compile: $(DEPDIR)/bzip2.do_prepare
	cd $(DIR_bzip2) && \
		mv Makefile-libbz2_so Makefile && \
		$(MAKE) all CC=$(target)-gcc
	touch $@

$(DEPDIR)/bzip2: $(DEPDIR)/bzip2.do_compile
	$(start_build)
	cd $(DIR_bzip2) && \
		$(INSTALL_bzip2)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# MODULE-INIT-TOOLS
#
BEGIN[[
module_init_tools
  3.16
  {PN}-{PV}
  extract:http://ftp.be.debian.org/pub/linux/utils/kernel/{PN}/{PN}-{PV}.tar.bz2
  patch:file://module-init-tools-no-man.patch
  make:INSTALL=install:install:sbin_PROGRAMS="depmod modinfo":bin_PROGRAMS=:mandir=/usr/share/man:DESTDIR=PKDIR
;
]]END

$(DEPDIR)/module_init_tools.do_prepare: bootstrap $(DEPENDS_module_init_tools)
	$(PREPARE_module_init_tools)
	touch $@

$(DEPDIR)/module_init_tools.do_compile: $(DEPDIR)/module_init_tools.do_prepare
	cd $(DIR_module_init_tools) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE)
	touch $@

$(DEPDIR)/module_init_tools: $(DEPDIR)/lsb $(DEPDIR)/module_init_tools.do_compile
	$(start_build)
	cd $(DIR_module_init_tools) && \
		$(INSTALL_module_init_tools)
	touch $@

#
# GREP
#
BEGIN[[
grep
  2.14
  {PN}-{PV}
  extract:ftp://mirrors.kernel.org/gnu/{PN}/{PN}-{PV}.tar.xz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_grep = "grep"

FILES_grep = \
/usr/bin/grep

$(DEPDIR)/grep.do_prepare: bootstrap $(DEPENDS_grep)
	$(PREPARE_grep)
	cd $(DIR_grep) && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch
	touch $@

$(DEPDIR)/grep.do_compile: $(DEPDIR)/grep.do_prepare
	cd $(DIR_grep) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-nls \
			--disable-perl-regexp \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/grep: $(DEPDIR)/grep.do_compile
	$(start_build)
	cd $(DIR_grep) && \
		$(INSTALL_grep)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# PPPD
#
BEGIN[[
pppd
  2.4.5
  ppp-{PV}
  extract:ftp://ftp.samba.org/pub/ppp/ppp-{PV}.tar.gz
  patch:file://{PN}.patch
  make:install:DESTDIR=PKDIR/usr
;
]]END

PKGR_pppd = r1
DESCRIPTION_pppd = "pppd"
FILES_pppd = \
/usr/sbin/* \
/usr/lib/*

$(DEPDIR)/pppd.do_prepare: bootstrap $(DEPENDS_pppd)
	$(PREPARE_pppd)
	cd $(DIR_pppd) && \
              sed -ie s:/usr/include/pcap-bpf.h:$(prefix)/cdkroot/usr/include/pcap-bpf.h: pppd/Makefile.linux
	touch $@

$(DEPDIR)/pppd.do_compile: pppd.do_prepare
	cd $(DIR_pppd)  && \
		$(BUILDENV) \
	      CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--with-kernel=$(buildprefix)/$(KERNEL_DIR) \
			--disable-kernel-module \
			--prefix=/usr && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/pppd: $(DEPDIR)/pppd.do_compile
	$(start_build)
	cd $(DIR_pppd)  && \
		$(INSTALL_pppd)
	$(tocdk_build)
	$(toflash_build)
	touch $@
	
#
# USB MODESWITCH
#
BEGIN[[
usb_modeswitch
  1.2.7
  {PN}-{PV}
  extract:http://www.draisberghof.de/usb_modeswitch/{PN}-{PV}.tar.bz2
  patch:file://{PN}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_usb_modeswitch = usb_modeswitch
RDEPENDS_usb_modeswitch = libusb-0.1 libusb-1.0 usb_modeswitch_data
FILES_usb_modeswitch = \
/etc/* \
/lib/udev/* \
/usr/sbin/*

$(DEPDIR)/usb_modeswitch.do_prepare: libusb2 libusb_compat usb_modeswitch_data $(DEPENDS_usb_modeswitch)
	$(PREPARE_usb_modeswitch)
	touch $@
$(DEPDIR)/usb_modeswitch.do_compile: $(DEPDIR)/usb_modeswitch.do_prepare
	  touch $@

$(DEPDIR)/usb_modeswitch: $(DEPDIR)/usb_modeswitch.do_compile
	$(start_build)
	cd $(DIR_usb_modeswitch)  && \
	  $(BUILDENV) \
		DESTDIR=$(PKDIR) \
		PREFIX=$(PKDIR)/usr \
	  $(MAKE) $(MAKE_OPTS) install
	$(tocdk_build)
	$(toflash_build)
	touch $@
	

#
# USB MODESWITCH DATA
#
BEGIN[[
usb_modeswitch_data
  20130807
  {PN}-{PV}
  extract:http://www.draisberghof.de/usb_modeswitch/{PN}-{PV}.tar.bz2
  patch:file://{PN}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_usb_modeswitch_data = usb_modeswitch_data

FILES_usb_modeswitch_data = \
/usr/* \
/etc/* \
/lib/udev/rules.d

$(DEPDIR)/usb_modeswitch_data.do_prepare: $(DEPENDS_usb_modeswitch_data)
	$(PREPARE_usb_modeswitch_data)
	touch $@
	
$(DEPDIR)/usb_modeswitch_data.do_compile: $(DEPDIR)/usb_modeswitch_data.do_prepare
	touch $@

$(DEPDIR)/usb_modeswitch_data: $(DEPDIR)/usb_modeswitch_data.do_compile
	$(start_build)
	cd $(DIR_usb_modeswitch_data)  && \
		$(BUILDENV) \
		DESTDIR=$(PKDIR) \
		$(MAKE) install
	$(tocdk_build)
	$(toflash_build)
	touch $@
	
#
# NTFS-3G
#
BEGIN[[
ntfs3g
  2013.1.13
  ntfs-3g_ntfsprogs-{PV}
  extract:http://tuxera.com/opensource/ntfs-3g_ntfsprogs-{PV}.tgz
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_ntfs3g = ntfs_3g \
		  libntfs_3g84 \
		  ntfsprogs

DESCRIPTION_ntfs_3g = The NTFS-3G driver is an open source, freely available NTFS driver for \
 Linux with read and write support.
RDEPENDS_ntfs_3g = libc6 libfuse2 libntfs_3g84
FILES_ntfs_3g = /sbin/mount.n* \
               /usr/bin/ntfs-3*

DESCRIPTION_ntfsprogs = The NTFS-3G driver is an open source, freely available NTFS driver for \
 Linux with read and write support.
RDEPENDS_ntfsprogs = libc6 libntfs_3g84
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

DESCRIPTION_libntfs_3g84 = The NTFS-3G driver is an open source, freely available NTFS driver for \
 Linux with read and write support.
RDEPENDS_libntfs_3g84 = libc6
define postinst_libntfs_3g84
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libntfs_3g84 = /usr/lib/libntfs-3g.so.*

$(DEPDIR)/ntfs3g.do_prepare: $(DEPENDS_ntfs3g)
	$(PREPARE_ntfs3g)
	touch $@

$(DEPDIR)/ntfs3g.do_compile: bootstrap fuse $(DEPDIR)/ntfs3g.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	LDCONFIG=$(prefix)/cdkroot/sbin/ldconfig \
	cd $(DIR_ntfs3g)  && \
		$(BUILDENV) \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-ldconfig \
			--enable-shared \
			--exec-prefix=/usr \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/ntfs3g: $(DEPDIR)/ntfs3g.do_compile
	$(start_build)
	cd $(DIR_ntfs3g)  && \
		$(INSTALL_ntfs3g)
	$(tocdk_build)	
	$(toflash_build)
	touch $@
	

#
# LSB
#
BEGIN[[
lsb
  3.2-28
  {PN}-3.2
  extract:http://www.emdebian.org/locale/pool/main/l/lsb/{PN}_{PV}.tar.gz
  install:-d:PKDIR/lib/{PN}
  install:-m644:init-functions:PKDIR/lib/{PN}
;
]]END

DESCRIPTION_lsb = "lsb"
FILES_lsb = \
/lib/lsb/*

$(DEPDIR)/lsb.do_prepare: bootstrap $(DEPENDS_lsb)
	$(PREPARE_lsb)
	touch $@

$(DEPDIR)/lsb.do_compile: $(DEPDIR)/lsb.do_prepare
	touch $@

$(DEPDIR)/lsb: $(DEPDIR)/lsb.do_compile
	$(start_build)
	cd $(DIR_lsb) && \
		$(INSTALL_lsb)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# PORTMAP
#
BEGIN[[
portmap
  6.0
  {PN}_{PV}
  extract:http://fossies.org/unix/misc/old/{PN}-{PV}.tgz
  patch:file://{PN}_{PV}.diff
  patch:http://debian.osuosl.org/debian/pool/main/p/{PN}/{PN}_{PV}.0-2.diff.gz
  make:install:BASEDIR=PKDIR
  install:-m755:debian/init.d:PKDIR/etc/init.d/{PN}
;
]]END

DESCRIPTION_portmap = "the program supports access control in the style of the tcp wrapper (log_tcp) packag"
RDEPENDS_portmap = lsb
FILES_portmap = \
/sbin/* \
/etc/init.d/

define postinst_portmap
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ portmap start 41 S . stop 10 0 6 .
endef

define prerm_portmap
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ portmap remove
endef

$(DEPDIR)/portmap.do_prepare: bootstrap $(DEPENDS_portmap)
	$(PREPARE_portmap)
	cd $(DIR_portmap) && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch
	touch $@

$(DEPDIR)/portmap.do_compile: $(DEPDIR)/portmap.do_prepare
	cd $(DIR_portmap) && \
		$(BUILDENV) \
		$(MAKE)
	touch $@

$(DEPDIR)/portmap: $(DEPDIR)/lsb $(DEPDIR)/portmap.do_compile
	$(start_build)
	mkdir -p $(PKDIR)/sbin/
	mkdir -p $(PKDIR)/etc/init.d/
	mkdir -p $(PKDIR)/usr/share/man/man8
	cd $(DIR_portmap) && \
		$(INSTALL_portmap)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# OPENRDATE
#
BEGIN[[
openrdate
  1.1.2
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/project/openrdate/openrdate/{PN}-{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_openrdate = openrdate
FILES_openrdate = \
/usr/bin/* \
/etc/init.d/*

$(DEPDIR)/openrdate.do_prepare: bootstrap $(DEPENDS_openrdate)
	$(PREPARE_openrdate)
	cd $(DIR_openrdate)
	touch $@

$(DEPDIR)/openrdate.do_compile: $(DEPDIR)/openrdate.do_prepare
	cd $(DIR_openrdate) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/openrdate: $(DEPDIR)/openrdate.do_compile
	$(start_build)
	cd $(DIR_openrdate) && \
		$(INSTALL_openrdate)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# E2FSPROGS
#
BEGIN[[
e2fsprogs
  1.42.8
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/v{PV}/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_e2fsprogs = e2fsprogs_badblocks \
		     e2fsprogs_blkid \
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
FILES_e2fsprogs_badblocks = /sbin/badblock

DESCRIPTION_e2fsprogs_blkid = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_e2fsprogs_blkid = libblkid1 libext2fs2
FILES_e2fsprogs_blkid = /sbin/blkid

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
			  /sbin/e2label \
			  /sbin/findfs

DESCRIPTION_e2fsprogs_core = The Ext2 Filesystem Utilities (e2fsprogs) contain all of the standard \
 utilities for creating, fixing, configuring , and debugging ext2 filesystems.
RDEPENDS_e2fsprogs_core = libss2 libext2fs2 libcom_err2 libe2p2 libc6 e2fsprogs_badblocks libblkid1 libuuid1
FILES_e2fsprogs_core = /sbin/debugfs \
		  /sbin/dumpe2fs \
		  /sbin/e2freefrag \
		  /sbin/e2image \
		  /sbin/e2undo \
		  /sbin/e4defrag \
		  /sbin/filefrag \
		  /sbin/logsave \
		  /sbin/mklost+found \
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

$(DEPDIR)/e2fsprogs.do_prepare: bootstrap $(DEPENDS_e2fsprogs)
	$(PREPARE_e2fsprogs)
	touch $@

$(DEPDIR)/e2fsprogs.do_compile: $(DEPDIR)/e2fsprogs.do_prepare | $(UTIL_LINUX)
	cd $(DIR_e2fsprogs) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	cc=$(target)-gcc \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--target=$(target) \
		--with-linker=$(target)-ld \
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
		--with-root-prefix= && \
	$(MAKE) all && \
	$(MAKE) -C e2fsck e2fsck.static
	touch $@

$(DEPDIR)/e2fsprogs: $(DEPDIR)/e2fsprogs.do_compile
	$(start_build)
	cd $(DIR_e2fsprogs) && \
	$(BUILDENV) \
	$(MAKE) install install-libs \
		LDCONFIG=true \
		DESTDIR=$(PKDIR) && \
	$(INSTALL) e2fsck/e2fsck.static $(PKDIR)/sbin
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# SDPARM
#
BEGIN[[
sdparm
  1.07
  {PN}-{PV}
  extract:http://sg.danny.cz/sg/p/{PN}-{PV}.tgz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_sdparm = "sdparm"
RDEPENDS_sdparm =libc6
FILES_sdparm = \
/sbin/sdparm

$(DEPDIR)/sdparm.do_prepare: bootstrap $(DEPENDS_sdparm)
	$(PREPARE_sdparm)
	touch $@

$(DEPDIR)/sdparm.do_compile: $(DEPDIR)/sdparm.do_prepare
	cd $(DIR_sdparm) && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) clean || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/sdparm: $(DEPDIR)/sdparm.do_compile
	$(start_build)
	mkdir $(PKDIR)/sbin
	cd $(DIR_sdparm) && \
		export PATH=$(MAKE_PATH) && \
		$(INSTALL_sdparm)
	$(tocdk_build)
	mv -f $(PKDIR)/usr/bin/sdparm $(PKDIR)/sbin
	$(toflash_build)
	touch $@

#
# IPKG
#
BEGIN[[
ipkg
  0.99.163
  {PN}-{PV}
  extract:ftp.gwdg.de/linux/handhelds/packages/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/ipkg.do_prepare: bootstrap $(DEPENDS_ipkg)
	$(PREPARE_ipkg)
	touch $@

$(DEPDIR)/ipkg.do_compile: $(DEPDIR)/ipkg.do_prepare
	cd $(DIR_ipkg) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/ipkg: $(DEPDIR)/ipkg.do_compile
	cd $(DIR_ipkg) && \
		$(INSTALL_ipkg)
	ln -sf ipkg-cl $(prefix)/$*cdkroot/usr/bin/ipkg && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc && $(INSTALL) -m 644 root/etc/ipkg.conf $(prefix)/$*cdkroot/etc && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/ipkg
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/lib/ipkg
	$(INSTALL) -m 644 root/usr/lib/ipkg/status.initial $(prefix)/$*cdkroot/usr/lib/ipkg/status
	touch $@

#
# RSYNC
#
BEGIN[[
rsync
  3.1.0
  {PN}-{PV}
  extract:http://rsync.samba.org/ftp/{PN}/src/{PN}-{PV}.tar.gz
  nothing:file://../root/etc/rsyncd.conf
  make:install:DESTDIR=TARGETS
;
]]END

DESCRIPTION_rsync = File synchronization tool
RDEPENDS_rsync = libpopt0 libc6
define conffiles_rsync
/etc/rsyncd.conf
endef
FILES_rsync = /etc/rsyncd.conf \
	      /usr/bin/rsync

$(DEPDIR)/rsync.do_prepare: bootstrap $(DEPENDS_rsync)
	$(PREPARE_rsync)
	touch $@

$(DEPDIR)/rsync.do_compile: $(DEPDIR)/rsync.do_prepare
	cd $(DIR_rsync) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--exec-prefix=/usr \
			--prefix=/usr \
			--disable-xattr-support \
			--disable-acl-support && \
		$(MAKE)
	touch $@

$(DEPDIR)/rsync: $(DEPDIR)/rsync.do_compile
	$(start_build)
	cd $(DIR_rsync) && \
		$(INSTALL_rsync)
	$(INSTALL_DIR) $(PKDIR)/etc && \
	$(INSTALL_DIR) $(PKDIR)/usr/bin && \
	$(INSTALL_BIN) $(DIR_rsync)/rsync $(PKDIR)/usr/bin && \
	$(INSTALL_FILE) $(DIR_rsync)/rsyncd.conf $(PKDIR)/etc && \
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# RFKILL
#
BEGIN[[
rfkill
  git
  {PN}-{PV}
  nothing:git://git.sipsolutions.net/rfkill.git
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_rfkill = rfkill is a small tool to query the state of the rfkill switches, buttons and subsystem interfaces
PKGR_rfkill = r1
FILES_rfkill = \
/usr/sbin/*

$(DEPDIR)/rfkill.do_prepare: bootstrap $(DEPENDS_rfkill)
	$(PREPARE_rfkill)
	touch $@

$(DEPDIR)/rfkill.do_compile: $(DEPDIR)/rfkill.do_prepare
	cd $(DIR_rfkill) && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/rfkill: $(DEPDIR)/rfkill.do_compile
	$(start_build)
	cd $(DIR_rfkill) && \
		$(INSTALL_rfkill)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# LM_SENSORS
#
BEGIN[[
lm_sensors
  2.9.2
  lm_sensors-{PV}
  extract:http://dl.{PN}.org/{PN}/releases/lm_sensors-{PV}.tar.gz
  make:user_install:MACHINE=sh:PREFIX=/usr:MANDIR=/usr/share/man:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lm_sensors = "lm_sensors"

FILES_lm_sensors = \
/usr/bin/sensors \
/etc/sensors.conf \
/usr/lib/*.so* \
/usr/sbin/*

$(DEPDIR)/lm_sensors.do_prepare: bootstrap $(DEPENDS_lm_sensors)
	$(PREPARE_lm_sensors)
	touch $@

$(DEPDIR)/lm_sensors.do_compile: $(DEPDIR)/lm_sensors.do_prepare
	cd $(DIR_lm_sensors) && \
		$(MAKE) $(MAKE_OPTS) MACHINE=sh PREFIX=/usr user
	touch $@

$(DEPDIR)/lm_sensors: $(DEPDIR)/lm_sensors.do_compile
	$(start_build)
	cd $(DIR_lm_sensors) && \
		$(INSTALL_lm_sensors) && \
		rm $(PKDIR)/usr/bin/*.pl && \
		rm $(PKDIR)/usr/sbin/*.pl && \
		rm $(PKDIR)/usr/sbin/sensors-detect && \
		rm $(PKDIR)/usr/share/man/man8/sensors-detect.8 && \
		rm $(PKDIR)/usr/include/linux/i2c-dev.h && \
		rm $(PKDIR)/usr/bin/ddcmon
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# FUSE
#
BEGIN[[
fuse
  2.9.3
  {PN}-{PV}
  extract:http://dfn.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

PACKAGES_fuse = libfuse2 \
		libulockmgr1 \
		fuse_utils

DESCRIPTION_libfuse2 = With FUSE it is possible to implement a fully functional filesystem in a \
 userspace program  FUSE (Filesystem in Userspace) is a simple interface \
 for userspace   programs to export a virtual filesystem to the Linux \
 kernel.  FUSE also   aims to provide a secure method for non privileged \
 users to create and   mount their own filesystem implementations.
RDEPENDS_libfuse2 = libc6
define postinst_libfuse2
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libfuse2 = /usr/lib/libfuse.so.*

DESCRIPTION_libulockmgr1 = With FUSE it is possible to implement a fully functional filesystem in a \
 userspace program  FUSE (Filesystem in Userspace) is a simple interface \
 for userspace   programs to export a virtual filesystem to the Linux \
 kernel.  FUSE also   aims to provide a secure method for non privileged \
 users to create and   mount their own filesystem implementations.
RDEPENDS_libulockmgr1 = libc6
define postinst_libulockmgr1
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libulockmgr1 = /usr/lib/libulockmgr.so.*

DESCRIPTION_fuse_utils = With FUSE it is possible to implement a fully functional filesystem in a \
 userspace program  FUSE (Filesystem in Userspace) is a simple interface \
 for userspace   programs to export a virtual filesystem to the Linux \
 kernel.  FUSE also   aims to provide a secure method for non privileged \
 users to create and   mount their own filesystem implementations.
RDEPENDS_fuse_utils = libc6
FILES_fuse_utils = /etc/init.d/fuse \
		   /etc/udev/* \
		   /sbin/mount.fuse \
		   /usr/bin/*

define postinst_fuse_utils
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ fuse start 34 S .
endef

define prerm_fuse_utils
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ fuse remove
endef

$(DEPDIR)/fuse.do_prepare: bootstrap curl glib2 $(DEPENDS_fuse)
	$(PREPARE_fuse)
	touch $@

$(DEPDIR)/fuse.do_compile: $(DEPDIR)/fuse.do_prepare
	cd $(DIR_fuse) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/fuse: curl glib2 $(DEPDIR)/fuse.do_compile
	  $(start_build)
	  cd $(DIR_fuse) && \
		$(INSTALL_fuse)
	rm -R $(PKDIR)/dev
	$(LN_SF) sh4-linux-fusermount $(PKDIR)/usr/bin/fusermount
	$(LN_SF) sh4-linux-ulockmgr_server $(PKDIR)/usr/bin/ulockmgr_server
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# CURLFTPFS
#
BEGIN[[
curlftpfs
  0.9.2
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/latest/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/curlftpfs.do_prepare: bootstrap fuse $(DEPENDS_curlftpfs)
	$(PREPARE_curlftpfs)
	touch $@

$(DEPDIR)/curlftpfs.do_compile: $(DEPDIR)/curlftpfs.do_prepare
	cd $(DIR_curlftpfs) && \
		export ac_cv_func_malloc_0_nonnull=yes && \
		export ac_cv_func_realloc_0_nonnull=yes && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/curlftpfs: fuse $(DEPDIR)/curlftpfs.do_compile
	cd $(DIR_curlftpfs) && \
		$(INSTALL_curlftpfs)
	touch $@

#
# FBSET
#
BEGIN[[
fbset
  2.1
  {PN}-{PV}
  extract:http://ftp.de.debian.org/debian/pool/main/f/{PN}/{PN}_{PV}.orig.tar.gz
  patch:http://archive.debian.org/debian/dists/potato/main/source/admin/{PN}_{PV}-6.diff.gz
  patch:file://{PN}_{PV}-fb.modes-ST.patch
  install:-d:-m755:TARGETS/{usr/sbin,etc}
  install:-m755:{PN}:TARGETS/usr/sbin
  install:-m755:con2fbmap:TARGETS/usr/sbin
  install:-m644:etc/fb.modes.ATI:TARGETS/etc/fb.modes
;
]]END

$(DEPDIR)/fbset.do_prepare: bootstrap $(DEPENDS_fbset)
	$(PREPARE_fbset)
	touch $@

$(DEPDIR)/fbset.do_compile: $(DEPDIR)/fbset.do_prepare
	cd $(DIR_fbset) && \
		make CC="$(target)-gcc -Wall -O2 -I."
	touch $@

$(DEPDIR)/fbset: fbset.do_compile
	cd $(DIR_fbset) && \
		$(INSTALL_fbset)
	touch $@

#
# PNGQUANT
#
BEGIN[[
pngquant
  1.1
  {PN}-{PV}
  extract:ftp://ftp.simplesystems.org/pub/libpng/png/applications/{PN}/{PN}-{PV}-src.tgz
  install:-m755:{PN}:TARGETS/usr/bin
;
]]END

$(DEPDIR)/pngquant.do_prepare: bootstrap libz libpng $(DEPENDS_pngquant)
	$(PREPARE_pngquant)
	touch $@

$(DEPDIR)/pngquant.do_compile: $(DEPDIR)/pngquant.do_prepare
	cd $(DIR_pngquant) && \
		$(target)-gcc -O3 -Wall -I. -funroll-loops -fomit-frame-pointer -o pngquant pngquant.c rwpng.c -lpng -lz -lm
	touch $@

$(DEPDIR)/pngquant: $(DEPDIR)/pngquant.do_compile
	cd $(DIR_pngquant) && \
		$(INSTALL_pngquant)
	touch $@

#
# MPLAYER
#
BEGIN[[
mplayer
  1.0
  {PN}-export-*
  extract:ftp://ftp.{PN}hq.hu/MPlayer/releases/{PN}-export-snapshot.tar.bz2
  make:install INSTALLSTRIP="":DESTDIR=TARGETS
;
]]END

$(DEPDIR)/mplayer.do_prepare: bootstrap $(DEPENDS_mplayer)
	$(PREPARE_mplayer)
	touch $@

$(DEPDIR)/mplayer.do_compile: $(DEPDIR)/mplayer.do_prepare
	cd $(DIR_mplayer) && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-mencoder && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/mplayer: $(DEPDIR)/mplayer.do_compile
	cd $(DIR_mplayer) && \
		$(INSTALL_mplayer)
	touch $@

#
# MENCODER
#
BEGIN[[
mencoder
  1.0
  mplayer-export-*
  extract:ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-export-snapshot.tar.bz2
  make:install INSTALLSTRIP="":DESTDIR=TARGETS
;
]]END

#$(DEPDIR)/mencoder.do_prepare: bootstrap $(DEPENDS_mencoder)
#	$(PREPARE_mencoder)
#	touch $@

$(DEPDIR)/mencoder.do_compile: $(DEPDIR)/mplayer.do_prepare
	cd $(DIR_mencoder) && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-dvdnav \
			--disable-dvdread \
			--disable-dvdread-internal \
			--disable-libdvdcss-internal \
			--disable-libvorbis \
			--disable-mp3lib \
			--disable-liba52 \
			--disable-mad \
			--disable-vcd \
			--disable-ftp \
			--disable-pvr \
			--disable-tv-v4l2 \
			--disable-tv-v4l1 \
			--disable-tv \
			--disable-network \
			--disable-real \
			--disable-xanim \
			--disable-faad-internal \
			--disable-tremor-internal \
			--disable-pnm \
			--disable-ossaudio \
			--disable-tga \
			--disable-v4l2 \
			--disable-fbdev \
			--disable-dvb \
			--disable-mplayer && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/mencoder: $(DEPDIR)/mencoder.do_compile
	cd $(DIR_mencoder) && \
		$(INSTALL_mencoder)
	touch $@

#
# jfsutils
#
BEGIN[[
jfsutils
  1.1.15
  {PN}-{PV}
  extract:http://jfs.sourceforge.net/project/pub/{PN}-{PV}.tar.gz
  make:install:mandir=/usr/share/man:DESTDIR=PKDIR
;
]]END

DESCRIPTION_jfsutils = "jfsutils"
FILES_jfsutils = \
/sbin/*

$(DEPDIR)/jfsutils.do_prepare: bootstrap e2fsprogs $(DEPENDS_jfsutils)
	$(PREPARE_jfsutils)
	touch $@

$(DEPDIR)/jfsutils.do_compile: $(DEPDIR)/jfsutils.do_prepare
	cd $(DIR_jfsutils) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--disable-dependency-tracking \
			--prefix= && \
		$(MAKE)
	touch $@

$(DEPDIR)/jfsutils: $(DEPDIR)/jfsutils.do_compile
	$(start_build)
	cd $(DIR_jfsutils) && \
		$(INSTALL_jfsutils)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# opkg
#
BEGIN[[
opkg
  0.2.0
  {PN}-{PV}
  extract:http://{PN}.googlecode.com/files/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
  link:/usr/bin/{PN}-cl:PKDIR/usr/bin/{PN}
;
]]END

PACKAGE_ARCH_opkg = $(box_arch)
OPKG_ARCH_CONF = /etc/opkg/opkg.conf
DESCRIPTION_opkg = "lightweight package management system"
FILES_opkg = \
/etc/opkg \
/usr/bin \
/usr/lib

define conffiles_opkg
/etc/opkg/opkg.conf
endef

$(DEPDIR)/opkg.do_prepare: bootstrap $(DEPENDS_opkg)
	$(PREPARE_opkg)
	touch $@

$(DEPDIR)/opkg.do_compile: $(DEPDIR)/opkg.do_prepare
	cd $(DIR_opkg) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--with-opkglibdir=/usr/lib && \
		$(MAKE) all
	touch $@

$(DEPDIR)/opkg: $(DEPDIR)/opkg.do_compile
	$(start_build)
	cd $(DIR_opkg) && \
		$(INSTALL_opkg)
	$(INSTALL_DIR) $(PKDIR)/etc/opkg && \
	( echo "arch all 1" ; \
	  echo "arch sh4 10"; \
	  echo "arch $(box_arch) 16" ) >>$(PKDIR)$(OPKG_ARCH_CONF) && \
	ln -sf /usr/bin/opkg-cl  $(PKDIR)/usr/bin/ipkg-cl && \
	ln -sf /usr/bin/opkg-cl  $(PKDIR)/usr/bin/opkg && \
	ln -sf /usr/bin/opkg-cl  $(PKDIR)/usr/bin/ipkg
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# ntpclient
#
BEGIN[[
ntpclient
  #second param is version
  2007_365
  #third is buid dir
  {PN}-2007
  #sources goes below
  http://doolittle.icarus.com/ntpclient/{PN}_{PV}.tar.gz
  nothing:file://{PN}-init.file
;
]]END


# PARENT_PK defined as per rule variable below is main postfix
# at first split_packages.py searches for variable PACKAGES_ + $(PARENT_PK)
# PACKAGES_ntpclient = ntpclient
# this is the default.
# PACKAGES_ntpclient = $(PARENT_PK)
# secondly for each package in the list it looks for control fields.
# the default control field is PARENT_PK one.

DESCRIPTION_ntpclient := time sync over ntp protocol
#this is default
#MAINTAINER_ntpclient := Ar-P team
#Source: are handled by smart-rules
#SRC_URI_ntpclient =
#PACKAGE_ARCH_ntpclient := sh4
#the Package: field in control file
#NAME_ntpclient := ntpclient
#mask for files to package
FILES_ntpclient := /sbin /etc
#version is handled by smart-rules
#PKGV_ntpclient =
PKGR_ntpclient = r1
# comment symbol '#' in define goes directly to split_packages.py. You do not need to escape it!
# moreover line breaks are also correctly exported to python, enjoy!
define postinst_ntpclient
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ ntpclient start 
endef
define postrm_ntpclient
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ ntpclient remove
endef

$(DEPDIR)/ntpclient.do_prepare: $(DEPENDS_ntpclient)
	$(PREPARE_ntpclient)
	touch $@

$(DEPDIR)/ntpclient.do_compile: $(DEPDIR)/ntpclient.do_prepare
	cd $(DIR_ntpclient)  && \
		export CC=sh4-linux-gcc CFLAGS="$(TARGET_CFLAGS)"; \
		$(MAKE) ntpclient; \
		$(MAKE) adjtimex
	touch $@

$(DEPDIR)/ntpclient: $(DEPDIR)/ntpclient.do_compile
	$(start_build)
	cd $(DIR_ntpclient)  && \
		install -D -m 0755 ntpclient $(PKDIR)/sbin/ntpclient; \
		install -D -m 0755 adjtimex $(PKDIR)/sbin/adjtimex; \
		install -D -m 0755 rate.awk $(PKDIR)/sbin/ntpclient-drift-rate.awk
	install -D -m 0755 Patches/ntpclient-init.file $(PKDIR)/etc/init.d/ntpclient
	$(toflash_build)
	touch $@

#
# udpxy
#
BEGIN[[
udpxy
  1.0.23-0
  {PN}-{PV}
  http://sourceforge.net/projects/udpxy/files/udpxy/Chipmunk-1.0/udpxy.{PV}-prod.tar.gz
  #for patch -p0 use the following
  patch-0:file://udpxy-makefile.patch
;
]]END

# You can use it as example of building and making package for new utility.
# First of all take a look at smart-rules file. Read the documentation at the beginning.
#
# At the first stage let's build one single package. For example udpxy. Be careful, each package name should be unique.
# First of all you should define some necessary info about your package.
# Such as 'Description:' field in control file

DESCRIPTION_udpxy := udp to http stream proxy

# Next set package release number and increase it each time you change something here in make scripts.
# Release number is part of the package version, updating it tells others that they can upgrade their system now.

PKGR_udpxy = r0

# Other variables are optional and have default values and another are taken from smart-rules (full list below)
# Usually each utility is split into three make-targets. Target name and package name 'udpxy' should be the same.
# Write
#  $(DEPDIR)/udpxy.do_prepare:
# But not
#  $(DEPDIR)/udpxy_proxy.do_prepare:
# *exceptions of this rule discussed later.

# Also target should contain only A-z characters and underscore "_".

# Firstly, downloading and patching. Use $(DEPENDS_udpxy) from smart rules as target-depends.
# In the body use $(PREPARE_udpxy) generated by smart-rules
# You can add your special commands too.

$(DEPDIR)/udpxy.do_prepare: $(DEPENDS_udpxy)
	$(PREPARE_udpxy)
	touch $@

# Secondly, the configure and compilation stage
# Each target should ends with 'touch $@'

$(DEPDIR)/udpxy.do_compile: $(DEPDIR)/udpxy.do_prepare
	cd $(DIR_udpxy) && \
		export CC=sh4-linux-gcc && \
		$(MAKE)
	touch $@

# Finally, install and packaging!
# How does it works:
#  start with line $(start_build) to prepare temporary directories and determine package name by the target name.
#  At first all files should go to temporary directory $(PKDIR) which is cdk/packagingtmpdir.
#  If you fill $(PKDIR) correctly then our scripts could proceed.
#  You could call one of the following:
#    $(tocdk_build) - copy all $(PKDIR) contents to tufsbox/cdkroot to use them later if something depends on them.
#    $(toflash_build) - At first do exactly that $(toflash_build) does. After install package to tufsbox/root to include it in image.
#  Tip: $(tocdk_build) and $(toflash_build) could be used simultaneously.

$(DEPDIR)/udpxy: $(DEPDIR)/udpxy.do_compile
	$(start_build)
	cd $(DIR_udpxy)  && \
		export INSTALLROOT=$(PKDIR)/usr && \
		$(MAKE) install
	$(toflash_build)
	touch $@

# Note: all above defined variables has suffix 'udpxy' same as make-target name '$(DEPDIR)/udpxy'
# If you want to change name of make-target for some reason add $(call parent_pk,udpxy) before $(start_build) line.
# Of course place your variables suffix instead of udpxy.

# Some words about git and svn.
# It is available to automatically determine version from git and svn
# If there is git/svn rule in smart-rules and the version equals git/svn then the version will be automatically evaluated during $(start_build)
# Note: it is assumed that there is only one repo for the utility.
# If you use your own git/svn fetch mechanism we provide you with $(get_git_version) or $(get_svn_version), but make sure that DIR_foo is git/svn repo.

# FILES variable
# FILES variable is the filter for your $(PKDIR), by default it equals "/" so all files from $(PKDIR) are built into the package. It is list of files and directories separated by space. Wildcards are supported.
# Wildcards used in the FILES variables are processed via the python function fnmatch. The following items are of note about this function:
#   /<dir>/*: This will match all files and directories in the dir - it will not match other directories.
#   /<dir>/a*: This will only match files, and not directories.
#   /dir: will include the directory dir in the package, which in turn will include all files in the directory and all subdirectories.

# Info about some additional variables
# PKGV_foo
#  Taken from smart rules version. Set if you don't use smart-rules
# SRC_URI_foo
#  Sources from which package is built, taken from smart-rules file://, http://, git://, svn:// rules.
# NAME_foo
#  If real package name is too long put it in this variable. By default it is like in varible names.
# Next variables has default values and influence CONTROL file fields only:
# MAINTAINER_foo := Ar-P team
# PACKAGE_ARCH_foo := sh4
# SECTION_foo := base
# PRIORITY_foo := optional
# LICENSE_foo := unknown
# HOMEPAGE_foo := unknown
# You set package dependencies in CONTROL file with:
# RDEPENDS_foo :=
# RREPLACES :=
# RCONFLICTS :=

# post/pre inst/rm Scripts
# For these sripts use make define as following:

define postinst_foo
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ foo start 99 S .
endef

# This is all about scripts
# Note: init.d script starting and stopping is handled by update-rc.d

# Multi-Packaging
# When you whant to split files from one target to different packages you should set PACKAGES_parentfoo value.
# By default parentfoo is equals make target name. Place subpackages names to PACKAGES_parentfoo variable,
# parentfoo could be also in the list. Example:
## PACKAGES_megaprog = megaprog_extra megaprog
# Then set FILES for each subpackage
## FILES_megaprog = /bin/prog /lib/*.so*
## FILES_megaprog_extra = /lib/megaprog-addon.so
# NOTE: files are moving to pacakges in same order they are listed in PACKAGES variable.

# Optional install to flash
# When you call $(tocdk_build)/$(toflash_build) all packages are installed to image.
# If you want to select some non-installing packages from the same target (multi-packaging case)
# just list them in EXTRA_parentfoo variable
# DIST_parentfoo variable works vice-versa

#
# sysstat
#
BEGIN[[
sysstat
  10.0.4
  {PN}-{PV}
  extract:http://pagesperso-orange.fr/sebastien.godard/{PN}-{PV}.tar.gz
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/sysstat: bootstrap $(DEPENDS_sysstat)
	$(PREPARE_sysstat)
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_sysstat) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--disable-documentation && \
		$(MAKE) && \
		$(INSTALL_sysstat)
	@DISTCLEANUP_sysstat@
	touch $@

#
# hotplug-e2
#
BEGIN[[
hotplug_e2
  git
  {PN}-helper
  git://openpli.git.sourceforge.net/gitroot/openpli/hotplug-e2-helper
  patch:file://hotplug-e2-helper-support_fw_upload.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

NAME_hotplug_e2 = hotplug_e2_helper
DESCRIPTION_hotplug_e2 = "hotplug_e2"
RDEPENDS_hotplug_e2 = libc6
PKGR_hotplug_e2 = r1
FILES_hotplug_e2 = \
/sbin/bdpoll \
/usr/bin/hotplug_e2_helper

$(DEPDIR)/hotplug_e2.do_prepare: bootstrap $(DEPENDS_hotplug_e2)
	$(PREPARE_hotplug_e2)
	touch $@

$(DEPDIR)/hotplug_e2.do_compile: $(DEPDIR)/hotplug_e2.do_prepare
	cd $(DIR_hotplug_e2) && \
		./autogen.sh &&\
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/hotplug_e2: $(DEPDIR)/hotplug_e2.do_compile
	$(start_build)
	cd $(DIR_hotplug_e2) && \
		$(INSTALL_hotplug_e2)
	$(tocdk_build)
	mkdir $(PKDIR)/sbin
	cp -f $(PKDIR)/usr/bin/* $(PKDIR)/sbin
	$(toflash_build)
	touch $@

#
# autofs
#
BEGIN[[
autofs
  4.1.4
  {PN}-{PV}
  extract:http://kernel.org/pub/linux/daemons/{PN}/v4/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.patch
  make:install:INSTALLROOT=PKDIR
;
]]END

DESCRIPTION_autofs = Kernel based automounter for linux. \
 Kernel based automounter for linux..
RDEPENDS_autofs = libc6

define postinst_autofs
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $OPT autofs defaults
fi
endef

define postrm_autofs
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT=""
	fi
	update-rc.d $OPT autofs remove
fi
endef

define preinst_autofs
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/autofs" ]; then
	/etc/init.d/autofs stop
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-f -r $$D"
	else
		OPT="-f"
	fi
	update-rc.d $OPT autofs remove
fi
endef

define prerm_autofs
#!/bin/sh
if [ -z "$D" ]; then
	/etc/init.d/autofs stop
fi
endef

FILES_autofs = \
/etc/* \
/usr/*

$(DEPDIR)/autofs.do_prepare: bootstrap $(DEPENDS_autofs)
	$(PREPARE_autofs)
	touch $@

$(DEPDIR)/autofs.do_compile: $(DEPDIR)/autofs.do_prepare
	cd $(DIR_autofs) && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all CC=$(target)-gcc STRIP=$(target)-strip
	touch $@

$(DEPDIR)/autofs: $(DEPDIR)/autofs.do_compile
	$(start_build)
	cd $(DIR_autofs) && \
		$(INSTALL_autofs)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# imagemagick
#
BEGIN[[
imagemagick
  6.8.0-4
  ImageMagick-{PV}
  extract:ftp://ftp.fifi.org/pub/ImageMagick/ImageMagick-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_imagemagick = "imagemagick"
FILES_imagemagick = \
/usr/*
$(DEPDIR)/imagemagick.do_prepare: bootstrap $(DEPENDS_imagemagick)
	$(PREPARE_imagemagick)
	touch $@

$(DEPDIR)/imagemagick.do_compile: $(DEPDIR)/imagemagick.do_prepare
	cd $(DIR_imagemagick) && \
	$(BUILDENV) \
	CFLAGS="-O1" \
	PKG_CONFIG=$(hostprefix)/bin/pkg-config \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--without-dps \
		--without-fpx \
		--without-gslib \
		--without-jbig \
		--without-jp2 \
		--without-lcms \
		--without-tiff \
		--without-xml \
		--without-perl \
		--disable-openmp \
		--disable-opencl \
		--without-zlib \
		--enable-shared \
		--enable-static \
		--without-x && \
	$(MAKE) all
	touch $@

$(DEPDIR)/imagemagick: $(DEPDIR)/imagemagick.do_compile
	$(start_build)
	cd $(DIR_imagemagick) && \
		$(INSTALL_imagemagick)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# grab
#
BEGIN[[
grab
  git
  {PN}-{PV}
  git://git.code.sf.net/p/openpli/aio-grab.git: r=ef31eca61832b31f28f69157dfe5f850a3cab916
  patch:file://aio-grab-ADD_ST_SUPPORT.patch
  patch:file://aio-grab-ADD_ST_FRAMESYNC_SUPPORT.patch
  make:install:DESTDIR=PKDIR
;
]]END

NAME_grab = aio_grab
DESCRIPTION_grab = Screen grabber for Set-Top-Boxes
PKGR_grab = r1
RDEPENDS_grab = libpng16 libjpeg8 libc6

$(DEPDIR)/grab.do_prepare: bootstrap $(RDEPENDS_grab) $(DEPENDS_grab)
	$(PREPARE_grab)
	touch $@

$(DEPDIR)/grab.do_compile: grab.do_prepare
	cd $(DIR_grab) && \
		autoreconf -i && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr
	touch $@

$(DEPDIR)/grab: grab.do_compile
	$(start_build)
	cd $(DIR_grab) && \
		$(INSTALL_grab)
	$(toflash_build)
	touch $@


#
# enigma2-plugin-cams-oscam
#
BEGIN[[
oscam
  svn
  {PN}-{PV}
  svn://www.oscam.cc/svn/oscam-mirror/trunk/
  make:install:DESTDIR=PKDIR:OSCAM_BIN = OSCAM_BIN
;
]]END

NAME_oscam = enigma2_plugin_cams_oscam
DESCRIPTION_oscam = Open Source Conditional Access Module software
RDEPENDS_oscam = libssl1 libcrypto1
SRC_URI_oscam = http://www.streamboard.tv/oscam/
FILES_oscam = \
/usr/bin/cam/oscam

$(DEPDIR)/oscam.do_prepare: bootstrap $(DEPENDS_oscam)
	$(PREPARE_oscam)
	touch $@

$(DEPDIR)/oscam.do_compile: oscam.do_prepare
	cd $(DIR_oscam) && \
	$(BUILDENV) \
	$(MAKE) CROSS=$(prefix)/devkit/sh4/bin/$(target)-  CONF_DIR=/var/keys
	touch $@

$(DEPDIR)/oscam: oscam.do_compile
	$(start_build)
	cd $(DIR_oscam)  && \
		$(INSTALL_DIR) $(PKDIR)/usr/bin/cam; \
		$(INSTALL_BIN) Distribution/oscam*-sh4-linux $(PKDIR)/usr/bin/cam/oscam
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# enigma2-plugin-cams-oscam-config
#
BEGIN[[
oscamconfig
  0.1
  {PN}-{PV}
  nothing:file://../root/var/keys/oscam.conf
  nothing:file://../root/var/keys/oscam.dvbapi
  nothing:file://../root/var/keys/oscam.services
  nothing:file://../root/var/keys/oscam.srvid
  nothing:file://../root/var/keys/oscam.user
  nothing:file://../root/var/keys/oscam.server2
  nothing:file://../root/var/keys/oscam.server
  nothing:file://../root/var/keys/oscam.guess
;
]]END
NAME_oscamconfig = enigma2_plugin_cams_oscam_config
DESCRIPTION_oscamconfig = Example configs for Open Source Conditional Access Module software
SRC_URI_oscamconfig = http://www.streamboard.tv/oscam/
RDEPENDS_oscamconfig = enigma2-plugin-cams-oscam
FILES_oscamconfig = \
/var/keys/oscam.*

define conffiles_oscamconfig
/var/keys/oscam.conf
/var/keys/oscam.dvbapi
/var/keys/oscam.services
/var/keys/oscam.srvid
/var/keys/oscam.user
/var/keys/oscam.server
/var/keys/oscam.guess
endef

$(DEPDIR)/oscamconfig: oscam $(DEPENDS_oscamconfig)
	 $(PREPARE_oscamconfig)
	 $(start_build)
		$(INSTALL_DIR) $(PKDIR)/var/keys
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.conf     $(PKDIR)/var/keys/oscam.conf
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.dvbapi   $(PKDIR)/var/keys/oscam.dvbapi
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.services $(PKDIR)/var/keys/oscam.services
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.srvid    $(PKDIR)/var/keys/oscam.srvid
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.user     $(PKDIR)/var/keys/oscam.user
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.server2  $(PKDIR)/var/keys/oscam.server
		$(INSTALL_FILE) $(buildprefix)/root/var/keys/oscam.guess    $(PKDIR)/var/keys/oscam.guess
	 $(toflash_build)
	touch $@

#
# tor
#
BEGIN[[
tor
  0.2.4.20
  {PN}-{PV}
  https://www.torproject.org/dist/{PN}-{PV}.tar.gz
#  patch-0:file://tor.patch
  make:install:DESTDIR=PKDIR

;
]]END

DESCRIPTION_tor := Tor is a network of virtual tunnels that allows you to improve your privacy and security on the Internet.
RDEPENDS_tor = libevent-dev
PKGR_tor = r0

$(DEPDIR)/tor.do_prepare: $(DEPENDS_tor) $(RDEPENDS_tor)
	$(PREPARE_tor)
	touch $@

$(DEPDIR)/tor.do_compile: $(DEPDIR)/tor.do_prepare
	cd $(DIR_tor) && \
		$(BUILDENV) \
		./configure \
			--prefix= \
			--datarootdir=/usr/share \
			--disable-asciidoc \
			--build=$(build) \
			--host=$(target) \
			--target=$(target)  && \
		$(MAKE) 
	touch $@

$(DEPDIR)/tor: $(DEPDIR)/tor.do_compile
	$(start_build)
	cd $(DIR_tor)  && \
		$(INSTALL_tor)
	$(toflash_build)
	touch $@
