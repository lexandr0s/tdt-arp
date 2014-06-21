#
# AR-P buildsystem smart Makefile
#
package[[ target_libmmeimage

BDEPENDS_${P} = $(target_glibc) $(target_libjpeg)

PR_${P} = $(PR_tdt_tools).2

DESCRIPTION_${P} = libmmeimage
FILES_${P} = /lib/libmmeimage.s*

MAKE_FLAGS_${P} = DRIVER_TOPDIR=$(DIR_target_driver)

call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
