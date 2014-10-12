#
# AR-P buildsystem smart Makefile
#
package[[ target_iptables

BDEPENDS_${P} = $(target_linux_kernel)

PR_${P} = 1

${P}_VERSION = 1.4.10-15
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

RDEPENDS_${P} = linux-kernel libc6
FILES_${P} = /etc/* /usr/bin/* /usr/lib/*.so* /usr/libexec/* /usr/sbin/*

define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ iptables start 20 2 3 4 5 . stop 20 6 .
endef

define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ iptables remove
endef

call[[ ipkbox ]]

]]package
