#
# AR-P buildsystem smart Makefile
#
package[[ target_directfb

BDEPENDS_${P} = $(target_glibc) $(target_freetype) $(host_fluxcomp) $(target_driver)

PV_${P} = 1.6.3
PR_${P} = 1

DIR_${P} = ${WORK}/DirectFB-${PV}

CONFIG_FLAGS_${P} = \
		--enable-static \
		--with-tests \
		--with-tools \
		--disable-osx \
		--disable-network \
		--disable-multicore \
		--disable-multi \
		--enable-voodoo \
		--disable-devmem \
		--disable-sdl \
		--disable-webp \
		--with-message-size=65536 \
		--disable-linotype \
		--disable-vnc \
		--disable-zlib \
		--with-inputdrivers=keyboard,linuxinput,ps2mouse,enigma2remote \
		--disable-x11 \
		--disable-fbdev \
		--enable-stmfbdev \
		--disable-video4linux \
		--disable-video4linux2 \
		--disable-debug-support \
		--disable-trace \
		--enable-mme \
		--disable-unique \
		--enable-gif \
		--enable-png \
		--enable-jpeg \
		--enable-freetype && \
		export top_builddir=`pwd`

call[[ base ]]

rule[[
  extract:http://ptxdist.sat-universum.de/DirectFB-${PV}.tar.bz2
  patch:file://${PN}-${PV}.stm.patch
  patch:file://${PN}-${PV}.no-vt.diff
  patch:file://${PN}-${PV}.enigma2remote.diff
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = directfb
RDEPENDS_${P} = libc6 libpng libjpeg tiff jasper

define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so* \
/usr/lib/directfb-1.6-0-pure/gfxdrivers/*.so* \
/usr/lib/directfb-1.6-0-pure/inputdrivers/*.so* \
/usr/lib/directfb-1.6-0-pure/interfaces/*.so* \
/usr/lib/directfb-1.6-0-pure/systems/libdirectfb_stmfbdev.so \
/usr/lib/directfb-1.6-0-pure/wm/*.so* \
/usr/bin/dfbinfo


call[[ ipkbox ]]

]]package
