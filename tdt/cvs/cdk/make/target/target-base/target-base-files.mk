#
# AR-P buildsystem smart Makefile
#
package[[ target_base_files

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.2
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Miscellaneous files for the base system.

call[[ base ]]

# TODO:
# /etc/nsswitch.conf
# /etc/host.conf
# -/etc/profile.d/empty
# +/etc/motd
# +/var/run
# +/hdd
# +/var/cache
# +/etc/fstab
# -/etc/inputrc
# +/tmp
# -/etc/skel/.bashrc
# +/etc/hostname
# -/etc/skel/.profile
# -/etc/default/usbd
# +/etc/filesystems
# +/etc/mtab
# +/mnt
# /etc/issue
# /etc/issue.net


rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/proc
  install:-d:$(PKDIR)/sys
  install:-d:$(PKDIR)/tmp
  install:-d:$(PKDIR)/var/run
  install:-d:$(PKDIR)/var/log
  install:-d:$(PKDIR)/var/lock
  install:-d:$(PKDIR)/var/lib
  install:-d:$(PKDIR)/var/cache
  install:-d:$(PKDIR)/var/lib/urandom
  install:-d:$(PKDIR)/etc
  install:-d:$(PKDIR)/mnt
  install:-d:$(PKDIR)/media/hdd
  install:-d:$(PKDIR)/media/dvd
  install:-d:$(PKDIR)/media/net
  install:-d:$(PKDIR)/root
  install:-d:$(PKDIR)/bin
  install:-d:$(PKDIR)/dev
  install:-d:$(PKDIR)/dev.static
  install_file:$(PKDIR)/etc/motd:file://motd
  install_file:$(PKDIR)/etc/fstab:file://fstab
  install_bin:$(PKDIR)/bin/vdstandby:file://vdstandby
  install_file:$(PKDIR)/etc/vdstandby.cfg:file://vdstandby.cfg
  install_file:$(PKDIR)/etc/profile:file://profile
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})

	ln -sf /media $(PKDIR)/mnt
	ln -sf /media/hdd $(PKDIR)/hdd
	ln -sf /proc/mounts $(PKDIR)/etc/mtab
	echo "$(TARGET)" > $(PKDIR)/etc/hostname
	echo "576i50" > $(PKDIR)/etc/videomode

	touch $@

call[[ ipkbox ]]

]]package
