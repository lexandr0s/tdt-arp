#
# AR-P buildsystem smart Makefile
#
package[[ target_udev

BDEPENDS_${P} = \
$(target_filesystem) $(target_libattr) $(target_libacl) $(target_glib2) $(target_libusb_compat) $(target_usbutils)

PR_${P} = 2

${P}_VERSION = 162-40
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).diff
${P}_PATCHES = usbhd-automount.rules
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]

define DO_PACKAGE_${P}
	chmod +x $(PKDIR)/etc/init.d/*
endef

call[[ rpm ]]
call[[ ipk ]]

NAME_${P} = udev
RDEPENDS_${P} = libattr1 libacl libusb-0.1 libglib util-linux-blkid util-linux-fdisk
FILES_${P} = /etc/* /lib/* /sbin/* /usr/sbin/udevadm /usr/lib/*
define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ udev start 5 S . stop 99 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ udevadm start 6 S . stop 99 0 6 .
endef
define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ udev remove
endef

call[[ ipkbox ]]

]]package
