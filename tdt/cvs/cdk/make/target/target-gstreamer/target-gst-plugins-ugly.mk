#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_ugly

BDEPENDS_${P} = $(target_gstreamer) $(target_gst_plugins_base) $(target_libid3tag) $(target_libmad) $(target_orc) $(target_libcdio) $(target_lame) $(target_a52dec) $(target_libmpeg2)

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

PV_${P} = 0.10.19
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
		--disable-debug \
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
gst_plugins_ugly



RDEPENDS_gst_plugins_ugly_a52dec =gstreamer libgstpbutils libgstaudio libxml2 libz1 gst_plugins_ugly libffi6 libglib libc6 liba52 libgstinterfaces liborc
FILES_gst_plugins_ugly_a52dec = /usr/lib/gstreamer-0.10/libgsta52dec.so

RDEPENDS_gst_plugins_ugly_asf = libgstriff libz1 libgstpbutils libgstaudio libc6 libxml2 gstreamer gst_plugins_ugly libffi6 libgsttag libgstrtp libgstsdp libglib libgstinterfaces libgstrtsp
FILES_gst_plugins_ugly_asf = /usr/lib/gstreamer-0.10/libgstasf.so

RDEPENDS_gst_plugins_ugly_cdio = libz1 libxml2 libffi6 gstreamer gst_plugins_ugly libgsttag libc6 libglib libgstcdda libcdio12
FILES_gst_plugins_ugly_cdio = /usr/lib/gstreamer-0.10/libgstcdio.so

RDEPENDS_gst_plugins_ugly_dvdlpcmdec = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib gst_plugins_ugly
FILES_gst_plugins_ugly_dvdlpcmdec = /usr/lib/gstreamer-0.10/libgstdvdlpcmdec.so

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
FILES_gst_plugins_ugly = /usr/lib/gstreamer-0.10/libgstiv

call[[ ipkbox ]]

]]package
 
