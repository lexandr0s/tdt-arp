#
# AR-P buildsystem smart Makefile
#
package[[ target_libeplayer3

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib) $(target_driver) $(target_libass) $(target_ffmpeg)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = libeplayer3
RDEPENDS_${P} = kernel_module_player2 kernel_module_stgfb ffmpeg libass
FILES_${P} = \
	/bin/eplayer3 \
	/bin/meta \
	/lib/libeplayer3.s*


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
