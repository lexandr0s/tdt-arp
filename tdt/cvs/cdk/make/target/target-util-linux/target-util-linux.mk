#
# AR-P buildsystem smart Makefile
#
package[[ target_util_linux

BDEPENDS_${P} = $(target_filesystem) $(target_glibc) $(target_ncurses)

PR_${P} = 1

${P}_VERSION = 2.16.1-29
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_target_rpm ]]
call[[ ipk ]]

PACKAGES_${P} = util_linux_agetty \
		util_linux_sfdisk \
		util_linux_blkid \
		util_linux_cfdisk \
		util_linux_fdisk \
		libblkid1 \
		libuuid1
 

DESCRIPTION_${P} = Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
FILES_util_linux_agetty = /sbin/agetty

FILES_util_linux_sfdisk = /sbin/sfdisk

RDEPENDS_util_linux_blkid = libblkid1
FILES_util_linux_blkid = /sbin/blkid

RDEPENDS_util_linux_cfdisk = libblkid1 libncurses5
FILES_util_linux_cfdisk = /sbin/cfdisk

FILES_util_linux_fdisk = /sbin/fdisk

RDEPENDS_libblkid1 = libuuid1
FILES_libblkid1 = /usr/lib/libblkid.so.*

FILES_libuuid1 = /usr/lib/libuuid.so.*

call[[ ipkbox ]]

]]package
