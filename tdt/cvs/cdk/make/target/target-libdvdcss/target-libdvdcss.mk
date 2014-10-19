#
# AR-P buildsystem smart Makefile
#
package[[ target_libdvdcss

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.2.12
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://download.videolan.org/pub/${PN}/${PV}/${PN}-${PV}.tar.bz2
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-doc \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)

	touch $@

call[[ ipk ]]

NAME_${P} = libdvdcss2
DESCRIPTION_${P} = libdvdcss is a simple library designed for accessing DVDs like a block \
 device without having to bother about the decryption.
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
