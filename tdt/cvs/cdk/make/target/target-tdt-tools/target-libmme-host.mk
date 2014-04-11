#
# AR-P buildsystem smart Makefile
#
package[[ target_libmme_host

BDEPENDS_${P} = $(target_glibc)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = libmme-host
FILES_${P} = /lib/libmme_host.*

MAKE_FLAGS_${P} = DRIVER_TOPDIR=$(DIR_target_driver)

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package