#
# AR-P buildsystem smart Makefile
#
package[[ target_libattr

BDEPENDS_${P} = $(target_glibc)

PR_${P} = 1

DESCRIPTION_${P} = Utilities for manipulating filesystem extended attributes

${P}_VERSION = 2.4.47-5
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

PACKAGES_${P} = attr libattr1

RDEPENDS_attr = libattr1 libc6
FILES_attr = /usr/bin

RDEPENDS_libattr1 = libc6
FILES_libattr1 = /usr/lib/libattr.s*
define postinst_libattr1
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
