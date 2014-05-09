#
# AR-P buildsystem smart Makefile
#
package[[ target_libmad

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 0.15.1b
PR_${P} = 1

call[[ base ]]

rule[[
  extract:ftp://ftp.mars.org/pub/mpeg/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		autoheader && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debugging \
			--enable-shared=yes \
			--enable-speed \
			--enable-sso \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Library for interacting with ID3 tags in MP3 files  Library for \
 interacting with ID3 tags in MP3 files.
NAME_${P} = libid3tag0
RDEPENDS_${P} = libz1 libc6
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
