#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_ugly

BDEPENDS_${P} = $(target_gst_plugins_base) $(target_libid3tag) $(target_libmad) $(target_orc) $(target_libcdio) $(target_lame) $(target_a52dec) $(target_libmpeg2)

ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://anongit.freedesktop.org/gstreamer/gst-plugins-ugly;b=0.10;r=9afc696
  nothing:file://orc.m4-fix-location-of-orcc-when-cross-compiling.patch
]]rule

call[[ git ]]

else

PV_${P} = 0.10.13
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.bz2
]]rule

endif


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)
	cd $(DIR_${P})/common && \
	git submodule init && \
	git submodule update && \
	patch -p1 < ../orc.m4-fix-location-of-orcc-when-cross-compiling.patch
endif
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--build=$(build) \
		--prefix=/usr \
		--enable-orc \
	&& \
	$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	rm -r $(PKDIR)/usr/share/locale
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = GStreamer Multimedia Framework
PACKAGES_${P} = \
gst_plugins_ugly_a52dec \
gst_plugins_ugly_asf \
gst_plugins_ugly_cdio \
gst_plugins_ugly_dvdlpcmdec \
gst_plugins_ugly_dvdread \
gst_plugins_ugly_dvdsub \
gst_plugins_ugly_iec958 \
gst_plugins_ugly_lame \
gst_plugins_ugly_mad \
gst_plugins_ugly_meta \
gst_plugins_ugly_mpeg2dec \
gst_plugins_ugly_mpegaudioparse \
gst_plugins_ugly_mpegstream \
gst_plugins_ugly_rmdemux \
gst_plugins_ugly_x264 \
gst_plugins_ugly \

#gst_plugins_ugly_ivorbisdec \
#gst_plugins_ugly_playbin \
#gst_plugins_ugly_subparse \
#gst_plugins_ugly_tcp \
#gst_plugins_ugly_theora \
#gst_plugins_ugly_typefindfunctions \
#gst_plugins_ugly_videorate \
#gst_plugins_ugly_videoscale \
#gst_plugins_ugly_videotestsrc \
#gst_plugins_ugly_volume \
#gst_plugins_ugly_vorbis \
#gst_plugins_ugly



RDEPENDS_gst_plugins_ugly_a52dec =gstreamer libgstpbutils libgstaudio libxml2 libz1 gst_plugins_ugly libffi6 libglib libc6 liba52 libgstinterfaces liborc
FILES_gst_plugins_ugly_a52dec = /usr/lib/gstreamer-0.10/libgsta52dec.so

RDEPENDS_gst_plugins_ugly_asf = libgstriff libz1 libgstpbutils libgstaudio libc6 libxml2 gstreamer gst_plugins_ugly libffi6 libgsttag libgstrtp libgstsdp libglib libgstinterfaces libgstrtsp
FILES_gst_plugins_ugly_asf = /usr/lib/gstreamer-0.10/libgstasf.so

RDEPENDS_gst_plugins_ugly_cdio = libz1 libxml2 libffi6 gstreamer gst_plugins_ugly libgsttag libc6 libglib libgstcdda libcdio12
FILES_gst_plugins_ugly_cdio = /usr/lib/gstreamer-0.10/libgstcdio.so

RDEPENDS_gst_plugins_ugly_dvdlpcmdec = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_advdlpcmdec = /usr/lib/gstreamer-0.10/libgstdvdlpcmdec.so

RDEPENDS_gst_plugins_ugly_dvdread = libffi6 libxml2 libz1 gstreamer gst_plugins_ugly libdvdread4 libc6 libglib
FILES_gst_plugins_ugly_dvdread = /usr/lib/gstreamer-0.10/libgstdvdread.so

RDEPENDS_gst_plugins_ugly_dvdsub = libz1 libxml2 libffi6 gstreamer gst_plugins_ugly libc6 libglib
FILES_gst_plugins_ugly_dvdsub = /usr/lib/gstreamer-0.10/libgstdvdsub.so

RDEPENDS_gst_plugins_ugly_iec958 = libz1 libxml2 libffi6 gstreamer gst_plugins_ugly libc6 libglib
FILES_gst_plugins_ugly_iec958 = /usr/lib/gstreamer-0.10/libgstiec958.so

RDEPENDS_gst_plugins_ugly_lame = gstreamer libgstpbutils libgstaudio libxml2 libz1 gst_plugins_ugly libffi6 libmp3lame0 libc6 libglib libgstinterfaces
FILES_gst_plugins_ugly_lame = /usr/lib/gstreamer-0.10/libgstlame.so

RDEPENDS_gst_plugins_ugly_mad = gstreamer libmad0 libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_mad = /usr/lib/gstreamer-0.10/libgstmad.so

RDEPENDS_gst_plugins_ugly_meta = gst_plugins_ugly_amrwbdec gst_plugins_ugly_glib gst_plugins_ugly_rmdemux gst_plugins_ugly_lame gst_plugins_ugly_mpeg2dec gst_plugins_ugly_dvdread gst_plugins_ugly_mpegstream gst_plugins_ugly_apps gst_plugins_ugly_a52dec gst_plugins_ugly_asf gst_plugins_ugly_dvdsub gst_plugins_ugly_dvdlpcmdec gst_plugins_ugly_iec958 gst_plugins_ugly_x264 gst_plugins_ugly_meta gst_plugins_ugly gst_plugins_ugly_cdio gst_plugins_ugly_mad gst_plugins_ugly_mpegaudioparse
FILES_gst_plugins_ugly_meta = /var

RDEPENDS_gst_plugins_ugly_mpeg2dec =  libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_ugly libc6 libglib libmpeg2 liborc
FILES_gst_plugins_ugly_mpeg2dec = /usr/lib/gstreamer-0.10/libgstmpeg2dec.so

RDEPENDS_gst_plugins_ugly_mpegaudioparse = libz1 libxml2 libffi6 gstreamer gst_plugins_ugly libc6 libglib
FILES_gst_plugins_ugly_mpegaudioparse = /usr/lib/gstreamer-0.10/libgstmpegaudioparse.so

RDEPENDS_gst_plugins_ugly_mpegstream =  gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_mpegstream = /usr/lib/gstreamer-0.10/libgstmpegstream.so

RDEPENDS_gst_plugins_ugly_rmdemux = gstreamer libgstpbutils libc6 libxml2 libz1 gst_plugins_ugly libffi6 libgstsdp libglib libgstrtsp
FILES_gst_plugins_ugly_rmdemux = /usr/lib/gstreamer-0.10/libgstrmdemux.so

RDEPENDS_gst_plugins_ugly_x264 = libx264 gstreamer libgstpbutils libgstvideo libxml2 libz1 gst_plugins_ugly libffi6 libc6 libglib liborc
FILES_gst_plugins_ugly_x264 = /usr/lib/gstreamer-0.10/libgstx264.so

RDEPENDS_gst_plugins_ugly =
FILES_gst_plugins_ugly = /usr/lib/gstreamer-0.10/libgstivorbisdec.so






RDEPENDS_gst_plugins_ugly_playbin = gstreamer libgstpbutils libgstvideo libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc gst_plugins_ugly
FILES_gst_plugins_ugly_playbin = /usr/lib/gstreamer-0.10/libgstplaybin.so

RDEPENDS_gst_plugins_ugly_subparse = libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_subparse = /usr/lib/gstreamer-0.10/libgstsubparse.so

RDEPENDS_gst_plugins_ugly_tcp= libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_tcp = /usr/lib/gstreamer-0.10/libgsttcp.so

RDEPENDS_gst_plugins_ugly_theora= libogg0 gstreamer libgstvideo libxml2 libz1 libffi6 libgsttag libc6 libglib liborc gst_plugins_ugly libtheora
FILES_gst_plugins_ugly_theora = /usr/lib/gstreamer-0.10/libgsttheora.so

RDEPENDS_gst_plugins_ugly_typefindfunctions= libffi6 libgstpbutils libxml2 libz1 gstreamer libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_typefindfunctions = /usr/lib/gstreamer-0.10/libgsttypefindfunctions.so

RDEPENDS_gst_plugins_ugly_videorate= libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_videorate = /usr/lib/gstreamer-0.10/libgstvideorate.so

RDEPENDS_gst_plugins_ugly_videoscale= libffi6 libgstvideo libxml2 libz1 gstreamer libc6 libglib liborc gst_plugins_ugly
FILES_gst_plugins_ugly_videoscale = /usr/lib/gstreamer-0.10/libgstvideoscale.so

RDEPENDS_gst_plugins_ugly_videotestsrc= libffi6 libxml2 libz1 gstreamer libc6 libglib liborc gst_plugins_ugly
FILES_gst_plugins_ugly_videotestsrc = /usr/lib/gstreamer-0.10/libgstvideotestsrc.so

RDEPENDS_gst_plugins_ugly_volume= gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc gst_plugins_ugly
FILES_gst_plugins_ugly_volume = /usr/lib/gstreamer-0.10/libgstvolume.so

RDEPENDS_gst_plugins_ugly_vorbis= libogg0 gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libgsttag libc6 libglib libvorbis gst_plugins_ugly
FILES_gst_plugins_ugly_vorbis = /usr/lib/gstreamer-0.10/libgstvorbis.so libgstvorbis.so

RDEPENDS_gst_plugins_ugly = 
FILES_gst_plugins_ugly = /usr/share/gst-plugins-base/license-translations.dict

RDEPENDS_libgstapp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstapp = /usr/lib/libgstapp*.so.*
define postinst_libgstapp
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstaudio = libffi6 libgstpbutils libxml2 libz1 gstreamer libgstinterfaces libc6 libglib
FILES_libgstaudio = /usr/lib/libgstaudio*.so.*
define postinst_libgstaudio
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstcdda = libffi6 libxml2 libz1 gstreamer libgsttag libc6 libglib
FILES_libgstcdda = /usr/lib/libgstcdda*.so.*
define postinst_libgstcdda
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstfft = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstfft = /usr/lib/libgstfft*.so.*
define postinst_libgstfft
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstinterfaces = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstinterfaces = /usr/lib/libgstinterfaces*.so.*
define postinst_libgstinterfaces
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstnetbuffer = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstnetbuffer = /usr/lib/libgstnetbuffer*.so.*
define postinst_libgstnetbuffer
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstpbutils = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstpbutils = /usr/lib/libgstpbutils*.so.*
define postinst_libgstpbutils
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstriff = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libgsttag libc6 libglib
FILES_libgstriff = /usr/lib/libgstriff*.so.*
define postinst_libgstriff
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstrtp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstrtp = /usr/lib/libgstrtp*.so.*
define postinst_libgstrtp
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstrtsp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstrtsp = /usr/lib/libgstrtsp*.so.*
define postinst_libgstrtsp
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstsdp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstsdp = /usr/lib/libgstsdp*.so.*
define postinst_libgstsdp
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgsttag = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgsttag = /usr/lib/libgsttag*.so.*
define postinst_libgsttag
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstvideo = libffi6 libxml2 libz1 gstreamer libc6 libglib liborc
FILES_libgstvideo = /usr/lib/libgstvideo*.so.*
define postinst_libgstvideo
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
 
