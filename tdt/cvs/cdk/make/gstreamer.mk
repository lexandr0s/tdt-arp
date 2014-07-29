##############################   GSTREAMER + PLUGINS   #########################



#
# GST-PLUGINS-GOOD
#
BEGIN[[
gst_plugins_good
  0.10.31
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  patch:file://{PN}-0.10.29_avidemux_only_send_pts_on_keyframe.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_good = "GStreamer Multimedia Framework good plugins"

FILES_gst_plugins_good = \
/usr/lib/libgst* \
/usr/lib/gstreamer-0.10/libgstaudioparsers.so \
/usr/lib/gstreamer-0.10/libgstautodetect.so \
/usr/lib/gstreamer-0.10/libgstavi.so \
/usr/lib/gstreamer-0.10/libgstflac.so \
/usr/lib/gstreamer-0.10/libgstflv.so \
/usr/lib/gstreamer-0.10/libgsticydemux.so \
/usr/lib/gstreamer-0.10/libgstid3demux.so \
/usr/lib/gstreamer-0.10/libgstmatroska.so \
/usr/lib/gstreamer-0.10/libgstrtp.so \
/usr/lib/gstreamer-0.10/libgstrtpmanager.so \
/usr/lib/gstreamer-0.10/libgstrtsp.so \
/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so \
/usr/lib/gstreamer-0.10/libgstudp.so \
/usr/lib/gstreamer-0.10/libgstapetag.so \
/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so \
/usr/lib/gstreamer-0.10/libgstisomp4.so \
/usr/lib/gstreamer-0.10/libgstwavparse.so

$(DEPDIR)/gst_plugins_good.do_prepare: bootstrap gstreamer gst_plugins_base libsoup libflac $(DEPENDS_gst_plugins_good)
	$(PREPARE_gst_plugins_good)
	touch $@

$(DEPDIR)/gst_plugins_good.do_compile: $(DEPDIR)/gst_plugins_good.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_good) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-esd \
		--disable-aalib \
		--disable-esdtest \
		--disable-aalib \
		--disable-shout2 \
		--disable-shout2test \
		--disable-x  && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_good: $(DEPDIR)/gst_plugins_good.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_good) && \
		$(INSTALL_gst_plugins_good)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-BAD
#
BEGIN[[
gst_plugins_bad
  0.10.23
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  patch:file://{PN}-0.10.22-mpegtsdemux_remove_bluray_pgs_detection.diff
  patch:file://{PN}-0.10.22-mpegtsdemux_speedup.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_bad = "GStreamer Multimedia Framework bad plugins"

FILES_gst_plugins_bad = \
/usr/lib/libgst* \
/usr/lib/gstreamer-0.10/libgstassrender.so \
/usr/lib/gstreamer-0.10/libgstcdxaparse.so \
/usr/lib/gstreamer-0.10/libgstfragmented.so \
/usr/lib/gstreamer-0.10/libgstmpegdemux.so \
/usr/lib/gstreamer-0.10/libgstvcdsrc.so \
/usr/lib/gstreamer-0.10/libgstmpeg4videoparse.so \
/usr/lib/gstreamer-0.10/libgsth264parse.so \
/usr/lib/gstreamer-0.10/libgstneonhttpsrc.so \
/usr/lib/gstreamer-0.10/libgstrtmp.so

$(DEPDIR)/gst_plugins_bad.do_prepare: bootstrap gstreamer gst_plugins_base libmodplug $(DEPENDS_gst_plugins_bad)
	$(PREPARE_gst_plugins_bad)
	touch $@

$(DEPDIR)/gst_plugins_bad.do_compile: $(DEPDIR)/gst_plugins_bad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_bad) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-check=no \
		--disable-sdl \
		--disable-modplug \
		ac_cv_openssldir=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_bad: $(DEPDIR)/gst_plugins_bad.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_bad) && \
		$(INSTALL_gst_plugins_bad)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-UGLY
#
BEGIN[[
gst_plugins_ugly
  0.10.19
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_ugly = "GStreamer Multimedia Framework ugly plugins"

FILES_gst_plugins_ugly = \
/usr/lib/gstreamer-0.10/libgstasf.so \
/usr/lib/gstreamer-0.10/libgstdvdsub.so \
/usr/lib/gstreamer-0.10/libgstmad.so \
/usr/lib/gstreamer-0.10/libgstmpegaudioparse.so \
/usr/lib/gstreamer-0.10/libgstmpegstream.so

$(DEPDIR)/gst_plugins_ugly.do_prepare: bootstrap gstreamer gst_plugins_base $(DEPENDS_gst_plugins_ugly)
	$(PREPARE_gst_plugins_ugly)
	touch $@

$(DEPDIR)/gst_plugins_ugly.do_compile: $(DEPDIR)/gst_plugins_ugly.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_ugly) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-mpeg2dec && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_ugly: $(DEPDIR)/gst_plugins_ugly.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_ugly) && \
		$(INSTALL_gst_plugins_ugly)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-FFMPEG
#
BEGIN[[
gst_ffmpeg
  0.10.13
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  patch:file://{PN}-0.10.12_lower_rank.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_ffmpeg = "GStreamer Multimedia Framework ffmpeg module"

FILES_gst_ffmpeg = \
/usr/lib/gstreamer-0.10/libgstffmpeg.so \
/usr/lib/gstreamer-0.10/libgstffmpegscale.so \
/usr/lib/gstreamer-0.10/libgstpostproc.so

$(DEPDIR)/gst_ffmpeg.do_prepare: bootstrap gstreamer gst_plugins_base $(DEPENDS_gst_ffmpeg)
	$(PREPARE_gst_ffmpeg)
	touch $@

$(DEPDIR)/gst_ffmpeg.do_compile: $(DEPDIR)/gst_ffmpeg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_ffmpeg) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		\
		--with-ffmpeg-extra-configure=" \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffmpeg \
		--disable-ffprobe \
		--enable-postproc \
		--enable-gpl \
		--enable-static \
		--enable-pic \
		--disable-protocols \
		--disable-devices \
		--disable-network \
		--disable-hwaccels \
		--disable-filters \
		--disable-doc \
		--enable-optimizations \
		--enable-cross-compile \
		--target-os=linux \
		--arch=sh4 \
		--cross-prefix=$(target)- \
		\
		--disable-muxers \
		--disable-encoders \
		--disable-decoders \
		--enable-decoder=ogg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		--enable-decoder=vp6 \
		--enable-decoder=vp6a \
		--enable-decoder=vp6f \
		\
		--disable-demuxers \
		--enable-demuxer=ogg \
		--enable-demuxer=vorbis \
		--enable-demuxer=flac \
		--enable-demuxer=mpegts \
		\
		--disable-bsfs \
		--enable-pthreads \
		--enable-bzlib"
	touch $@

$(DEPDIR)/gst_ffmpeg: $(DEPDIR)/gst_ffmpeg.do_compile
	$(start_build)
	cd $(DIR_gst_ffmpeg) && \
		$(INSTALL_gst_ffmpeg)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-FLUENDO-MPEGDEMUX
#
BEGIN[[
gst_plugins_fluendo_mpegdemux
  0.10.71
  gst-fluendo-mpegdemux-{PV}
  extract:http://core.fluendo.com/gstreamer/src/gst-fluendo-mpegdemux/gst-fluendo-mpegdemux-{PV}.tar.gz
  patch:file://{PN}-0.10.69-add_dts_hd_detection.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_fluendo_mpegdemux = "GStreamer Multimedia Framework fluendo"
FILES_gst_plugins_fluendo_mpegdemux = \
/usr/lib/gstreamer-0.10/*.so


$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare: bootstrap gstreamer gst_plugins_base $(DEPENDS_gst_plugins_fluendo_mpegdemux)
	$(PREPARE_gst_plugins_fluendo_mpegdemux)
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_fluendo_mpegdemux) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-check=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_fluendo_mpegdemux) && \
		$(INSTALL_gst_plugins_fluendo_mpegdemux)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGIN-SUBSINK
#
BEGIN[[
gst_plugin_subsink
  git
  {PN}
  nothing:git://openpli.git.sourceforge.net/gitroot/openpli/gstsubsink:r=8182abe751364f6eb1ed45377b0625102aeb68d5
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugin_subsink = GStreamer Multimedia Framework gstsubsink
PKGR_gst_plugin_subsink = r1
FILES_gst_plugin_subsink = \
/usr/lib/gstreamer-0.10/*.so

$(DEPDIR)/gst_plugin_subsink.do_prepare: bootstrap gstreamer gst_ffmpeg gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugins_fluendo_mpegdemux $(DEPENDS_gst_plugin_subsink)
	$(PREPARE_gst_plugin_subsink)
	touch $@

$(DEPDIR)/gst_plugin_subsink.do_compile: $(DEPDIR)/gst_plugin_subsink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugin_subsink) && \
	touch NEWS README AUTHORS ChangeLog && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
	autoheader && \
	autoconf && \
	automake --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugin_subsink: $(DEPDIR)/gst_plugin_subsink.do_compile
	$(start_build)
	cd $(DIR_gst_plugin_subsink) && \
		$(INSTALL_gst_plugin_subsink)
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-DVBMEDIASINK
#
BEGIN[[
gst_plugins_dvbmediasink
  git
  {PN}-{PV}
  plink:$(appsdir)/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_dvbmediasink = "GStreamer Multimedia Framework dvbmediasink"
SRC_URI_gst_plugins_dvbmediasink = "https://code.google.com/p/tdt-amiko/"

FILES_gst_plugins_dvbmediasink = \
/usr/lib/gstreamer-0.10/libgstdvbaudiosink.so \
/usr/lib/gstreamer-0.10/libgstdvbvideosink.so

$(DEPDIR)/gst_plugins_dvbmediasink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugin_subsink $(DEPENDS_gst_plugins_dvbmediasink)
	$(PREPARE_gst_plugins_dvbmediasink)
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink.do_compile: $(DEPDIR)/gst_plugins_dvbmediasink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_dvbmediasink) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink: $(DEPDIR)/gst_plugins_dvbmediasink.do_compile
	$(start_build)
	$(get_git_version)
	cd $(DIR_gst_plugins_dvbmediasink) && \
		$(INSTALL_gst_plugins_dvbmediasink)
	$(tocdk_build)
	$(toflash_build)
	touch $@
