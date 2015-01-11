#
# AR-P buildsystem smart Makefile
#
package[[ target_smbnetfs

BDEPENDS_${P} = $(target_fuse) $(target_samba)

PV_${P} = 0.6.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://sourceforge.net/projects/${PN}/files/${PN}/SMBNetFS-${PV}/${PN}-${PV}.tar.bz2
  patch:file://${PN}.diff
  nothing:file://${PN}-init.file
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	
	$(INSTALL_DIR) $(PKDIR)/etc && \
	$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
	$(INSTALL_FILE) $(DIR_${P})/conf/smbnetfs.conf.spark $(PKDIR)/etc/smbnetfs.conf && \
	$(INSTALL_FILE) $(DIR_${P})/conf/smbnetfs.user.conf $(PKDIR)/etc/smbnetfs.user.conf && \
	$(INSTALL_BIN) $(DIR_${P})/smbnetfs-init.file $(PKDIR)/etc/init.d/smbnetfs
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = SMBNetFS is a Linux/FreeBSD filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows.
RDEPENDS_${P} = 

define preinst_${P}
#!/bin/sh
if [ -f /etc/smbnetfs.user.conf ]; then cp /etc/smbnetfs.user.conf /etc/smbnetfs.user.conf.org; fi
endef
define postinst_${P}
#!/bin/sh
if [ -f /etc/smbnetfs.user.conf.org ]; then mv /etc/smbnetfs.user.conf.org /etc/smbnetfs.user.conf; fi
update-rc.d -r $$OPKG_OFFLINE_ROOT/ smbnetfs start 30 3 . stop 30 0 .
endef
define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ smbnetfs remove
endef

FILES_${P} = /etc \
/usr/bin

call[[ ipkbox ]]

]]package
