#
# NFS-UTILS
#
BEGIN[[
nfs_utils
  1.1.1
  {PN}-{PV}
  extract:ftp://ftp.piotrkosoft.net/pub/mirrors/ftp.kernel.org/linux/utils/nfs/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-12.diff.gz
  make:install:DESTDIR=PKDIR
  install:-m644:debian/nfs-common.default:PKDIR/etc/default/nfs-common
  install:-m755:debian/nfs-common.init:PKDIR/etc/init.d/nfs-common
  install:-m644:debian/nfs-kernel-server.default:PKDIR/etc/default/nfs-kernel-server
  install:-m755:debian/nfs-kernel-server.init:PKDIR/etc/init.d/nfs-kernel-server
  install:-m644:debian/etc.exports:PKDIR/etc/exports
  remove:PKDIR/sbin/mount.nfs4:PKDIR/sbin/umount.nfs4
;
]]END

DESCRIPTION_nfs_utils = "nfs_utils"
FILES_nfs_utils = \
/usr/bin/*

$(DEPDIR)/nfs_utils.do_prepare: $(DEPENDS_nfs_utils)
	$(PREPARE_nfs_utils)
	chmod +x $(DIR_nfs_utils)/autogen.sh
	cd $(DIR_nfs_utils) && \
		gunzip -cd ../$(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: 2345 19 81\n### BEGIN INIT INFO/g' -i debian/nfs-common.init && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: 2345 20 80\n### BEGIN INIT INFO/g' -i debian/nfs-kernel-server.init && \
		sed -e 's/do_modprobe nfsd/# do_modprobe nfsd/g' -i debian/nfs-kernel-server.init && \
		sed -e 's/RPCNFSDCOUNT=8/RPCNFSDCOUNT=3/g' -i debian/nfs-kernel-server.default
	touch $@

$(DEPDIR)/nfs_utils.do_compile: bootstrap e2fsprogs $(DEPDIR)/nfs_utils.do_prepare
	cd $(DIR_nfs_utils) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			CC_FOR_BUILD=$(target)-gcc \
			--disable-gss \
			--disable-nfsv4 \
			--without-tcp-wrappers && \
		$(MAKE)
	touch $@

$(DEPDIR)/nfs_utils: $(DEPDIR)/nfs_utils.do_compile
	$(start_build)
	cd $(DIR_nfs_utils) && \
		$(INSTALL_nfs_utils)
	$(tocdk_build)
	$(toflash_build)
	touch $@


#
# LIGHTTPD
#
BEGIN[[
lighttpd
  1.4.15
  {PN}-{PV}
  extract:http://www.{PN}.net/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lighttpd = "lighttpd"
FILES_lighttpd = \
/usr/bin/* \
/usr/sbin/* \
/usr/lib/*.so \
/etc/init.d/* \
/etc/lighttpd/*.conf 

$(DEPDIR)/lighttpd.do_prepare: $(DEPENDS_lighttpd)
	$(PREPARE_lighttpd)
	touch $@

$(DEPDIR)/lighttpd.do_compile: bootstrap $(DEPDIR)/lighttpd.do_prepare
	cd $(DIR_lighttpd) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--datarootdir=/usr/share && \
		$(MAKE)
	touch $@

$(DEPDIR)/lighttpd: $(DEPDIR)/lighttpd.do_compile
	$(start_build)
	cd $(DIR_lighttpd) && \
		$(INSTALL_lighttpd)
	cd $(DIR_lighttpd) && \
		$(INSTALL) -d $(PKDIR)/etc/lighttpd && \
		$(INSTALL) -c -m644 doc/lighttpd.conf $(PKDIR)/etc/lighttpd && \
		$(INSTALL) -d $(PKDIR)/etc/init.d && \
		$(INSTALL) -c -m644 doc/rc.lighttpd.redhat $(PKDIR)/etc/init.d/lighttpd
	$(INSTALL) -d $(PKDIR)/etc/lighttpd && $(INSTALL) -m755 root/etc/lighttpd/lighttpd.conf $(PKDIR)/etc/lighttpd
	$(INSTALL) -d $(PKDIR)/etc/init.d && $(INSTALL) -m755 root/etc/init.d/lighttpd $(PKDIR)/etc/init.d
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# TRANSMISSION
#
BEGIN[[
transmission
  2.77
  {PN}-{PV}
  extract:http://mirrors.m0k.org/transmission/files/{PN}-{PV}.tar.bz2
  nothing:file://../root/etc/init.d/transmission.init
  nothing:file://../root/etc/transmission.json
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_transmission = "A free, lightweight BitTorrent client"
PKGR_transmission = r3
RDEPENDS_transmission = curl openssl libevent
FILES_transmission = \
/usr/bin/* \
/usr/share/transmission/*

define postinst_transmission
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ transmission start 100 S . stop 2 6 .
endef
define postrm_transmission
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ transmission remove
endef

$(DEPDIR)/transmission.do_prepare: $(DEPENDS_transmission)
	$(PREPARE_transmission)
	touch $@

$(DEPDIR)/transmission.do_compile: bootstrap libevent-dev curl $(DEPDIR)/transmission.do_prepare
	cd $(DIR_transmission) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--disable-nls \
			--disable-mac \
			--disable-libappindicator \
			--disable-libcanberra \
			--with-gnu-ld \
			--enable-daemon \
			--enable-cli \
			--disable-gtk \
			--enable-largefile \
			--enable-lightweight \
			--build=$(build) \
			--host=$(target) && \
		$(MAKE)
	touch $@

$(DEPDIR)/transmission: $(DEPDIR)/transmission.do_compile
	$(start_build)
	cd $(DIR_transmission) && \
		$(INSTALL_transmission) && \
		$(INSTALL_DIR) $(PKDIR)/etc && \
		$(INSTALL_DIR) $(PKDIR)/etc/transmission && \
		$(INSTALL_FILE) transmission.json $(PKDIR)/etc/transmission/settings.json && \
		$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
		$(INSTALL_BIN) transmission.init $(PKDIR)/etc/init.d/transmission
	$(extra_build)
	touch $@

#
# SMBNETFS
#
BEGIN[[
smbnetfs
  0.5.3a
  {PN}-{PV}
  extract:https://sourceforge.net/projects/{PN}/files/{PN}/SMBNetFS-{PV}/{PN}-{PV}.tar.bz2
  patch-0:file://{PN}.diff
  nothing:file://{PN}-init.file
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_smbnetfs = "SMBNetFS is a Linux/FreeBSD filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows."
define preinst_smbnetfs
#!/bin/sh
if [ -f /etc/smbnetfs.user.conf ]; then cp /etc/smbnetfs.user.conf /etc/smbnetfs.user.conf.org; fi
endef
define postinst_smbnetfs
#!/bin/sh
if [ -f /etc/smbnetfs.user.conf.org ]; then mv /etc/smbnetfs.user.conf.org /etc/smbnetfs.user.conf; fi
update-rc.d -r $$OPKG_OFFLINE_ROOT/ smbnetfs start 30 3 . stop 30 0 .
endef
define prerm_smbnetfs
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ smbnetfs remove
endef

$(DEPDIR)/smbnetfs.do_prepare: $(DEPENDS_smbnetfs)
	$(PREPARE_smbnetfs)
	touch $@

$(DEPDIR)/smbnetfs.do_compile: bootstrap fuse samba $(DEPDIR)/smbnetfs.do_prepare
	cd $(DIR_smbnetfs)  && \
		$(BUILDENV) \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--prefix=/usr \
			--build=$(build) \
			--host=$(target) \
			--target=$(target)  && \
		$(MAKE)
	touch $@

$(DEPDIR)/smbnetfs: \
$(DEPDIR)/%smbnetfs: $(DEPDIR)/smbnetfs.do_compile
	$(start_build)
	cd $(DIR_smbnetfs)  && \
		install -D -m 0600 conf/smbnetfs.conf.spark $(PKDIR)/etc/smbnetfs.conf; \
		install -D -m 0600 conf/smbnetfs.user.conf $(PKDIR)/etc/smbnetfs.user.conf; \
		$(INSTALL_smbnetfs)
	install -D -m 0755 Patches/smbnetfs-init.file $(PKDIR)/etc/init.d/smbnetfs
	$(tocdk_build)
	$(toflash_build)	
	touch $@
