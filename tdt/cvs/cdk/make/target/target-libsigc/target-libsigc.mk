#
# AR-P buildsystem smart Makefile
#
package[[ target_libsigc

BDEPENDS_${P} = $(target_gcc_lib)

PV_${P} = 1.2.7
PR_${P} = 1

DIR_${P} = $(workprefix)/libsigc++-${PV}

call[[ base ]]

rule[[
  extract:http://ftp.gnome.org/pub/GNOME/sources/libsigc++/1.2/libsigc++-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libsigc-1.2
DESCRIPTION_${P} =  A library for loose coupling of C++ method calls
RDEPENDS_${P} = libstdc++6 libgcc1
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package