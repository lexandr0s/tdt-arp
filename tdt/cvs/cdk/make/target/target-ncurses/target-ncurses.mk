#
# AR-P buildsystem smart Makefile
#
package[[ target_ncurses

BDEPENDS_${P} = $(target_filesystem) $(target_glibc)

PR_${P} = 1

${P}_VERSION = 5.5-10
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_target_rpm ]]
call[[ ipk ]]

PACKAGES_${P} = libncurses5 \
		libpanel5 \
		libmenu5 \
		libform5

DESCRIPTION_${P} =  ncurses panel library
RDEPENDS_libncurses5 = libc6
FILES_libncurses5 = /lib/*  /usr/lib/libncurses.so
define postinst_libncurses5
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
 
RDEPENDS_libpanel5 = libncurses5 libc6
FILES_libpanel5 = /usr/lib/libpanel.so.*
define postinst_libpanel5
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libmenu5 = libncurses5 libc6
FILES_libmenu5 = /usr/lib/libmenu.so.*
define postinst_libmenu5
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libform5 = libncurses5 libc6
FILES_libform5 = /usr/lib/libform.so.*
define postinst_libform5
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
