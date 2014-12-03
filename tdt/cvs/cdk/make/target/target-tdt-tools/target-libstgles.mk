#
# AR-P buildsystem smart Makefile
#
package[[ target_libstgles

BDEPENDS_${P} = $(target_glibc) $(target_directfb)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = libstgles
RDEPENDS_${P} = kernel_module_player2 kernel_module_stgfb directfb
CONFIG_FLAGS_${P} += --prefix=/usr
FILES_${P} = \
	/usr/lib/*.so


call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
