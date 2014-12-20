#
# AR-P buildsystem smart Makefile
#
package[[ target_libeplayer3

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib) $(target_driver) $(target_libass) $(target_ffmpeg)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = libeplayer3
RDEPENDS_${P} = kernel_module_player2 kernel_module_stgfb ffmpeg libass
CONFIG_FLAGS_${P} += --prefix=/usr
FILES_${P} = \
	/usr/bin/eplayer3 \
	/usr/bin/meta \
	/usr/lib/libeplayer3.s*


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
