#
# AR-P buildsystem smart Makefile
#
package[[ target_libacl

BDEPENDS_${P} = $(target_glibc) $(target_libattr)

PR_${P} = 3

${P}_VERSION = 2.2.47-6
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

PACKAGES_${P} = acl libacl

RDEPENDS_acl = libacl libc6
FILES_acl = /usr/bin

RDEPENDS_libacl = libc6
FILES_libacl = /usr/lib/*
define postinst_libacl
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ ipkbox ]]

]]package
