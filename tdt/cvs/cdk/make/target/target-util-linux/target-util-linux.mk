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
 

DESCRIPTION_util_linux_agetty = Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
FILES_util_linux_agetty = /sbin/agetty

DESCRIPTION_util_linux_sfdisk = A suite of basic system administration utilities. \
 Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
FILES_util_linux_sfdisk = /sbin/sfdisk

DESCRIPTION_util_linux_blkid =  Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
FILES_util_linux_blkid = /sbin/blkid

DESCRIPTION_util_linux_cfdisk = A suite of basic system administration utilities. \
 Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
RDEPENDS_util_linux_cfdisk = libblkid1 libncurses5
FILES_util_linux_cfdisk = /sbin/cfdisk

DESCRIPTION_util_linux_fdisk = A suite of basic system administration utilities. \
 Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
FILES_util_linux_fdisk = /sbin/fdisk

DESCRIPTION_libblkid1 = A suite of basic system administration utilities. \
 Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
RDEPENDS_libblkid1 = libuuid1
FILES_libblkid1 = /usr/lib/libblkid.so.*

DESCRIPTION_libuuid1 = A suite of basic system administration utilities. \
 Util-linux includes a suite of basic system administration utilities \
 commonly found on most Linux systems.  Some of the more important \
 utilities include disk partitioning, kernel message management, \
 filesystem creation, and system login.
FILES_libuuid1 = /usr/lib/libuuid.so.*

call[[ ipkbox ]]

]]package
