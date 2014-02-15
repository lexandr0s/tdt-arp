#
# target-filesystem
#
BEGIN[[
filesystemtarget
  0.1
  {PN}-{PV}
  pdircreate:{PN}-{PV}
;
]]END

NAME_filesystemtarget = filesystem
DESCRIPTION_filesystemtarget = filesystem
SRC_URI_filesystemtarget = root /
$(DEPDIR)/filesystemtarget: $(DEPENDS_filesystemtarget)
	$(PREPARE_filesystemtarget)
	$(start_build)
	$(INSTALL_DIR) $(PKDIR)/bin && \
	$(INSTALL_DIR) $(PKDIR)/sbin && \
	$(INSTALL_DIR) $(PKDIR)/boot && \
	$(INSTALL_DIR) $(PKDIR)/dev && \
	$(INSTALL_DIR) $(PKDIR)/dev.static && \
	$(INSTALL_DIR) $(PKDIR)/etc && \
	$(INSTALL_DIR)  $(PKDIR)/etc/rc.d/rc{0,1,2,3,4,5,6,S}.d
	ln -sf ../init.d $(PKDIR)/etc/rc.d
	$(INSTALL_DIR) $(PKDIR)/etc/fonts && \
	$(INSTALL_DIR) $(PKDIR)/etc/cron && \
	$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/modprobe.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/network && \
	$(INSTALL_DIR) $(PKDIR)/etc/network/if-down.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/network/if-post-up.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/network/if-pre-down.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/network/if-up.d && \
	$(INSTALL_DIR) $(PKDIR)/etc/tuxbox && \
	$(INSTALL_DIR) $(PKDIR)/etc/enigma2 && \
	$(INSTALL_DIR) $(PKDIR)/etc/opkg && \
	$(INSTALL_DIR) $(PKDIR)/usr/lib/locale && \
	$(INSTALL_DIR) $(PKDIR)/media && \
	$(INSTALL_DIR) $(PKDIR)/media/dvd && \
	$(INSTALL_DIR) $(PKDIR)/media/net && \
	$(INSTALL_DIR) $(PKDIR)/mnt && \
	$(INSTALL_DIR) $(PKDIR)/mnt/usb && \
	$(INSTALL_DIR) $(PKDIR)/mnt/hdd && \
	$(INSTALL_DIR) $(PKDIR)/mnt/nfs && \
	$(INSTALL_DIR) $(PKDIR)/root && \
	$(INSTALL_DIR) $(PKDIR)/proc && \
	$(INSTALL_DIR) $(PKDIR)/sys && \
	$(INSTALL_DIR) $(PKDIR)/tmp && \
	$(INSTALL_DIR) $(PKDIR)/usr && \
	$(INSTALL_DIR) $(PKDIR)/usr/bin && \
	$(INSTALL_DIR) $(PKDIR)/media/hdd && \
	$(INSTALL_DIR) $(PKDIR)/media/hdd/music && \
	$(INSTALL_DIR) $(PKDIR)/media/hdd/picture && \
	$(INSTALL_DIR) $(PKDIR)/usr/share/keymaps && \
	$(INSTALL_DIR) $(PKDIR)/usr/share/udhcpc && \
	ln -sf /usr/local/share/keymaps $(PKDIR)/usr/share/keymaps && \
	ln -sf /media/hdd $(PKDIR)/hdd && \
	$(INSTALL_DIR) $(PKDIR)/lib && \
	$(INSTALL_DIR) $(PKDIR)/lib/modules && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware && \
	$(INSTALL_DIR) $(PKDIR)/usr/share/zoneinfo && \
	$(INSTALL_DIR) $(PKDIR)/ram && \
	$(INSTALL_DIR) $(PKDIR)/var && \
	$(INSTALL_DIR) $(PKDIR)/var/etc && \
	$(INSTALL_DIR) $(PKDIR)/var/run/lirc && \
	$(INSTALL_DIR) $(PKDIR)/usr/lib/opkg && \
	cp -dp $(targetprefix)/etc/services $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/group $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(PKDIR)/etc/ && \
	cp -dp $(targetprefix)/etc/network/options $(PKDIR)/etc/network/
	$(toflash_build)
	touch $@

#
# INIT-SCRIPTS customized
#
BEGIN[[
initscripten
  0.12
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/inittab
  nothing:file://../root/release/hostname
  nothing:file://../root/release/inetd
# for 'nothing:' only 'cp' is executed so '*' is ok.
  nothing:file://../root/release/initmodules_*
  nothing:file://../root/release/halt_*
  nothing:file://../root/release/mountall
  nothing:file://../root/release/mountsysfs
  nothing:file://../root/release/networking
  nothing:file://../root/release/rc
  nothing:file://../root/release/reboot
  nothing:file://../root/release/sendsigs
  nothing:file://../root/release/telnetd
  nothing:file://../root/release/syslogd
  nothing:file://../root/release/crond
  nothing:file://../root/release/umountfs
  nothing:file://../root/release/lircd
  nothing:file://../root/etc/init.d/avahi-daemon
  nothing:file://../root/etc/init.d/busybox-cron
  nothing:file://../root/etc/init.d/rdate
;
]]END

NAME_initscripten = init_scripts
DESCRIPTION_initscripten = init scripts and rules for system start
RDEPENDS_initscripten = filesystem
initscripten_initd_files = \
halt \
hostname \
inetd \
initmodules \
mountall \
mountsysfs \
networking \
reboot \
sendsigs \
syslogd \
telnetd \
crond \
lircd \
umountfs \
avahi-daemon \
busybox-cron \
rdate 

define postinst_initscripten
#!/bin/sh
$(foreach f,$(initscripten_initd_files),  initdconfig --add $f
)
endef

define prerm_initscripten
#!/bin/sh
$(foreach f,$(initscripten_initd_files),  initdconfig --del $f
)
endef

$(DEPDIR)/initscripten: filesystemtarget $(DEPENDS_initscripten)
	$(PREPARE_initscripten)
	$(start_build)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d

# select initmodules
	cd $(DIR_initscripten) && \
	mv initmodules$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(HL101),_$(HL101)) initmodules
# select halt
	cd $(DIR_initscripten) && \
	mv halt$(if $(HL101),_$(HL101))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) halt
# init.d scripts
	cd $(DIR_initscripten) && \
		$(INSTALL) inittab $(PKDIR)/etc/ && \
		$(INSTALL) -m 755 rc $(PKDIR)/etc/init.d/rc && \
		$(foreach f,$(initscripten_initd_files), $(INSTALL) -m 755 $f $(PKDIR)/etc/init.d && ) true
	$(toflash_build)
	touch $@
#
# Configs default customized
#
BEGIN[[
default_confs
  0.1
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/bootscreen/bootlogo.mvi
  nothing:file://../root/etc/motd
  nothing:file://../root/etc/fstab
  nothing:file://../root/etc/image-version
  nothing:file://../root/etc/network/interfaces
  nothing:file://../root/bin/autologin
  nothing:file://../root/bin/fw_*
  nothing:file://../root/bin/setspark.sh
  nothing:file://../root/bin/vdstandby
  nothing:file://../root/etc/vdstandby.cfg
  nothing:file://../root/sbin/flash_*
  nothing:file://../root/sbin/nand*
  nothing:file://../root/etc/inetd.conf
  nothing:file://../root/etc/profile
  nothing:file://../root/etc/resolv.conf
  nothing:file://../root/etc/tuxbox/satellites.xml
  nothing:file://../root/etc/tuxbox/cables.xml
  nothing:file://../root/etc/tuxbox/terrestrial.xml
  nothing:file://../root/etc/tuxbox/timezone.xml
  nothing:file://../root/etc/init.d/udhcpc
  nothing:file://../root/usr/share/udhcpc/default.script
;
]]END

PACKAGES_default_confs = bootlogo \
			 config_satellites \
			 config_cables \
			 config_terrestrial \
			 default_configs \
			 default_bins

DESCRIPTION_bootlogo = Enigma2 bootlogo
PACKAGE_ARCH_bootlogo = all
RDEPENDS_bootlogo = filesystem
FILES_bootlogo = /boot/bootlogo.mvi

DESCRIPTION_config_cables = cables.xml config
PKGV_config_cables = 0.1
PACKAGE_ARCH_config_cables = all
RDEPENDS_config_cables = filesystem
FILES_config_cables = /etc/tuxbox/cables.xml

DESCRIPTION_config_terrestrial = terrestrial.xml config
PKGV_config_terrestrial = 0.1
PACKAGE_ARCH_config_terrestrial = all
RDEPENDS_config_terrestrial = filesystem
FILES_config_terrestrial = /etc/tuxbox/terrestrial.xml

DESCRIPTION_default_bins = default bins and scripts
RDEPENDS_default_bins = filesystem
FILES_default_bins = /bin/autologin \
		    /bin/vdstandby \
		    /sbin/flash_* \
		    /sbin/nand* \
		    /etc/init.d/udhcpc \
		    /usr/share/udhcpc/default.script \
		    /bin/setspark.sh \
		    /bin/fw_*

DESCRIPTION_default_configs = default configs
RDEPENDS_default_configs = filesystem
FILES_default_configs = /etc/network/interfaces \
		       /etc/motd \
		       /etc/fstab \
		       /etc/image-version \
		       /etc/vdstandby.cfg \
		       /etc/inetd.conf \
		       /etc/profile \
		       /etc/resolv.conf \
		       /etc/videomode \
		       /etc/tuxbox/timezone.xml

DESCRIPTION_config_satellites = satellites.xml config
PKGV_config_satellites = 0.1
PACKAGE_ARCH_config_satellites = all
RDEPENDS_config_satellites = filesystem
FILES_config_satellites = /etc/tuxbox/satellites.xml

$(DEPDIR)/default_confs: initscripten distrofeed $(DEPENDS_default_confs)
	$(PREPARE_default_confs)
	$(start_build)
	cd $(DIR_default_confs) && \
		$(INSTALL_DIR) $(PKDIR)/etc && \
		$(INSTALL_DIR) $(PKDIR)/etc/network && \
		$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
		$(INSTALL_DIR) $(PKDIR)/sbin && \
		$(INSTALL_DIR) $(PKDIR)/bin && \
		$(INSTALL_DIR) $(PKDIR)/boot && \
		$(INSTALL_DIR) $(PKDIR)/etc/tuxbox && \
		$(INSTALL_DIR) $(PKDIR)/usr/share/udhcpc && \
	cd $(DIR_default_confs) && \
		$(INSTALL_FILE) bootlogo.mvi $(PKDIR)/boot && \
		$(INSTALL_FILE) motd $(PKDIR)/etc && \
		$(INSTALL_FILE) fstab $(PKDIR)/etc && \
		$(INSTALL_FILE) interfaces $(PKDIR)/etc/network && \
		$(INSTALL_BIN) autologin $(PKDIR)/bin && \
		$(INSTALL_BIN) fw_* $(PKDIR)/bin && \
		$(INSTALL_BIN) setspark.sh $(PKDIR)/bin && \
		$(INSTALL_BIN) vdstandby $(PKDIR)/bin && \
		$(INSTALL_FILE) vdstandby.cfg $(PKDIR)/etc && \
		$(INSTALL_BIN) flash_*  $(PKDIR)/sbin && \
		$(INSTALL_BIN) nand* $(PKDIR)/sbin && \
		$(INSTALL_FILE) inetd.conf $(PKDIR)/etc && \
		$(INSTALL_FILE) profile $(PKDIR)/etc && \
		$(INSTALL_FILE) resolv.conf $(PKDIR)/etc && \
		$(INSTALL_FILE) satellites.xml $(PKDIR)/etc/tuxbox && \
		$(INSTALL_FILE) cables.xml $(PKDIR)/etc/tuxbox && \
		$(INSTALL_FILE) terrestrial.xml $(PKDIR)/etc/tuxbox && \
		$(INSTALL_FILE) timezone.xml $(PKDIR)/etc/tuxbox && \
		$(INSTALL_BIN) udhcpc $(PKDIR)/etc/init.d && \
		echo "576i50" > $(PKDIR)/etc/videomode
		ln -sfv /etc/timezone.xml $(PKDIR)/etc/tuxbox/timezone.xml
	$(toflash_build)
	touch $@	

#
# distro-feed-configs
#
NAME_distrofeed = distro_feed_configs
DESCRIPTION_distrofeed =  Configuration files for online package repositories aka feeds
PKGV_distrofeed = 0.1
SRC_URI_distrofeed = OpenAR-P
FILES_URI_distrofeed = /etc/opkg/all-feed.conf \
		       /etc/opkg/nonfree-feed.conf
define conffiles_dist
/etc/opkg/all-feed.conf
/etc/opkg/nonfree-feed.conf
endef

$(DEPDIR)/distrofeed: $(DEPENDS_distrofeed)
	$(start_build)
	$(INSTALL_DIR) $(PKDIR)/etc/opkg && \
	echo "src/gz official-all http://amiko.sat-universum.de" > $(PKDIR)/etc/opkg/all-feed.conf && \
	echo "src/gz non-free-feed http://softanet.net/feed" > $(PKDIR)/etc/opkg/nonfree-feed.conf
	$(toflash_build)
	touch $@


