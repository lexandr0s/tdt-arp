#
# AR-P buildsystem smart Makefile
#
package[[ target_libdvbsipp

BDEPENDS_${P} = $(target_gcc_lib)

PV_${P} = 0.3.7
PR_${P} = 1

PN_${P} = libdvbsi++
DESCRIPTION_${P} = libdvbsi++ is a open source C++ library for parsing DVB Service Information and MPEG-2 Program Specific Information.

call[[ base ]]

rule[[
  extract:http://www.saftware.de/${PN}/${PN}-${PV}.tar.bz2
  patch:file://${PN}-${PV}.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

#CXXFLAGS="-I $(targetprefix)/usr/include/c++/4.7.3" \

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		autoheader && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libdvbsi++1
RDEPENDS_${P} = libgcc1 libstdc++6
FILES_${P} = /usr/lib/libdvbsi++.so.*

call[[ ipkbox ]]

]]package
