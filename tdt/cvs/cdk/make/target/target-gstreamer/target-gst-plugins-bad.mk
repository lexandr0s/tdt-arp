#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_bad

BDEPENDS_${P} = $(target_gstreamer) $(target_gst_plugins_base) $(target_tremor) $(target_rtmpdump) $(target_libass) $(target_libmms) $(target_faad2)


ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://anongit.freedesktop.org/gstreamer/gst-plugins-bad;b=0.10;r=fb0d870
  patch:file://0003-mpegpsdemux_speedup.diff.patch
  patch:file://0004-mpegdemux-compile-fixes.patch
  patch:file://0005-hlsdemux-locking-fixes.patch
  patch:file://0006-hlsdemux-backport.patch
  patch:file://0007-Lower-rank-of-faad-to-prevent-using-it-if-not-necess.patch
  nothing:file://orc.m4-fix-location-of-orcc-when-cross-compiling.patch
]]rule

call[[ git ]]

else

PV_${P} = 0.10.23
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.bz2
  patch:file://${PN}-0.10.22-mpegtsdemux_remove_bluray_pgs_detection.diff
  patch:file://${PN}-0.10.22-mpegtsdemux_speedup.diff
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
	$(BUILDENV) \
	./autogen.sh \
		--host=$(target) \
		--build=$(build) \
		--libexecdir=/usr/lib/gstreamer/ \
		--prefix=/usr \
		--disable-sdl \
		--disable-modplug \
		--disable-mpeg2enc \
		--disable-mplex \
		--disable-vdpau \
		--disable-apexsink \
		--disable-cdaudio \
		--disable-mpeg2enc \
		--disable-mplex \
		--disable-librfb \
		--disable-vdpau \
		--disable-examples \
		--disable-sdltest \
		--disable-curl \
		--disable-rsvg \
		--disable-debug \
		--enable-orc \
		--disable-gtk-doc \
		ac_cv_openssldir=no \
	&& \
	$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	rm -r $(PKDIR)/usr/share/locale
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = GStreamer Multimedia Framework bad plugins
PACKAGES_${P} = \
gst_plugins_bad_adpcmdec \
gst_plugins_bad_adpcmenc \
gst_plugins_bad_aiff \
gst_plugins_bad_asfmux \
gst_plugins_bad_audiovisualizers \
gst_plugins_bad_autoconvert \
gst_plugins_bad_bayer \
gst_plugins_bad_bz2 \
gst_plugins_bad_camerabin2 \
gst_plugins_bad_camerabin \
gst_plugins_bad_cdxaparse \
gst_plugins_bad_cog \
gst_plugins_bad_coloreffects \
gst_plugins_bad_colorspace \
gst_plugins_bad_curl \
gst_plugins_bad_dataurisrc \
gst_plugins_bad_dccp \
gst_plugins_bad_debugutilsbad \
gst_plugins_bad_decklink \
gst_plugins_bad_dtmf \
gst_plugins_bad_dtsdec \
gst_plugins_bad_dvb \
gst_plugins_bad_dvbsuboverlay \
gst_plugins_bad_dvdspu \
gst_plugins_bad_faad \
gst_plugins_bad_faceoverlay \
gst_plugins_bad_fbdevsink \
gst_plugins_bad_festival \
gst_plugins_bad_fieldanalysis \
gst_plugins_bad_fragmented \
gst_plugins_bad_freeverb \
gst_plugins_bad_freeze \
gst_plugins_bad_frei0r \
gst_plugins_bad_gaudieffects \
gst_plugins_bad_geometrictransform \
gst_plugins_bad_glib \
gst_plugins_bad_gsettingselements \
gst_plugins_bad_h264parse \
gst_plugins_bad_hdvparse \
gst_plugins_bad_id3tag \
gst_plugins_bad_inter \
gst_plugins_bad_interlace \
gst_plugins_bad_ivfparse \
gst_plugins_bad_jp2kdecimator \
gst_plugins_bad_jpegformat \
gst_plugins_bad_legacyresample \
gst_plugins_bad_linsys \
gst_plugins_bad_liveadder \
gst_plugins_bad_meta \
gst_plugins_bad_mms \
gst_plugins_bad_mpegdemux \
gst_plugins_bad_mpegpsmux \
gst_plugins_bad_mpegtsmux \
gst_plugins_bad_mpegvideoparse \
gst_plugins_bad_mve \
gst_plugins_bad_mxf \
gst_plugins_bad_nsf \
gst_plugins_bad_nuvdemux \
gst_plugins_bad_patchdetect \
gst_plugins_bad_pcapparse \
gst_plugins_bad_pnm \
gst_plugins_bad_rawparse \
gst_plugins_bad_removesilence \
gst_plugins_bad_resindvd \
gst_plugins_bad_rfbsrc \
gst_plugins_bad_rtmp \
gst_plugins_bad_rtpmux \
gst_plugins_bad_rtpvp8 \
gst_plugins_bad_scaletempoplugin \
gst_plugins_bad_sdi \
gst_plugins_bad_sdpelem \
gst_plugins_bad_segmentclip \
gst_plugins_bad_shm \
gst_plugins_bad_siren \
gst_plugins_bad_smooth \
gst_plugins_bad_sndfile \
gst_plugins_bad_speed \
gst_plugins_bad_stereo \
gst_plugins_bad_subenc \
gst_plugins_bad_tta \
gst_plugins_bad_vcdsrc \
gst_plugins_bad_videofiltersbad \
gst_plugins_bad_videomaxrate \
gst_plugins_bad_videomeasure \
gst_plugins_bad_videoparsersbad \
gst_plugins_bad_videosignal \
gst_plugins_bad_vmnc \
gst_plugins_bad_vp8 \
gst_plugins_bad_y4mdec \
gst_plugins_bad \
libgstbasecamerabinsrc \
libgstbasevideo \
libgstcodecparsers \
libgstphotography \
libgstsignalprocessor \

RDEPENDS_gst_plugins_bad_adpcmdec = gst_plugins_bad gstreamer libgstpbutils libgstaudio libffi6 libxml2 libz1 libgstinterfaces libc6 libglib
FILES_gst_plugins_bad_adpcmdec = /usr/lib/gstreamer-0.10/libgstadpcmdec.so

RDEPENDS_gst_plugins_bad_adpcmenc = gst_plugins_bad gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib
FILES_gst_plugins_bad_adpcmenc = /usr/lib/gstreamer-0.10/libgstadpcmenc.so

RDEPENDS_gst_plugins_bad_aiff = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_aiff = /usr/lib/gstreamer-0.10/libgstaiff.so

RDEPENDS_gst_plugins_bad_asfmux = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgstrtp libc6 libglib
FILES_gst_plugins_bad_asfmux = /usr/lib/gstreamer-0.10/libgstasfmux.so

RDEPENDS_gst_plugins_bad_audiovisualizers = gst_plugins_bad libz1 libgstpbutils libgstaudio libgstvideo libxml2 gstreamer libgstfft libgstinterfaces libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_audiovisualizers = /usr/lib/gstreamer-0.10/libgstaudiovisualizers.so

RDEPENDS_gst_plugins_bad_autoconvert = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_autoconvert = /usr/lib/gstreamer-0.10/libgstautoconvert.so

RDEPENDS_gst_plugins_bad_bayer = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_bayer = /usr/lib/gstreamer-0.10/libgstbayer.so

RDEPENDS_gst_plugins_bad_bz2 = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib libbz2
FILES_gst_plugins_bad_bz2 = /usr/lib/gstreamer-0.10/libgstbz2.so

RDEPENDS_gst_plugins_bad_camerabin2 = gst_plugins_bad gstreamer libgstphotography libgstpbutils libxml2 libz1 libgstbasecamerabinsrc libgstinterfaces libffi6 libgsttag libc6 libglib libgstapp
FILES_gst_plugins_bad_camerabin2 = /usr/lib/gstreamer-0.10/libgstcamerabin2.so

RDEPENDS_gst_plugins_bad_camerabin = gst_plugins_bad gstreamer libgstphotography libxml2 libz1 libgstinterfaces libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_camerabin = /usr/lib/gstreamer-0.10/libgstcamerabin.so

RDEPENDS_gst_plugins_bad_cdxaparse = gst_plugins_bad libgstriff libz1 libgstpbutils libgstaudio libxml2 gstreamer libgstinterfaces libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_cdxaparse = /usr/lib/gstreamer-0.10/libgstcdxaparse.so

RDEPENDS_gst_plugins_bad_cog = gst_plugins_bad gstreamer libpng16 libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_cog = /usr/lib/gstreamer-0.10/libgstcog.so

RDEPENDS_gst_plugins_bad_coloreffects = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_coloreffects = /usr/lib/gstreamer-0.10/libgstcoloreffects.so

RDEPENDS_gst_plugins_bad_colorspace = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_colorspace = /usr/lib/gstreamer-0.10/libgstcolorspace.so

RDEPENDS_gst_plugins_bad_curl = gst_plugins_bad, gstreamer libcap2 libxml2 libz1 librtmp1 libffi6 libcurl4 libgnutls26 libc6 libglib libgpg-error0 libgcrypt11 libtasn1
FILES_gst_plugins_bad_curl = /usr/lib/gstreamer-0.10/libgstcurl.so

RDEPENDS_gst_plugins_bad_dataurisrc = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_dataurisrc = /usr/lib/gstreamer-0.10/libgstdataurisrc.so

RDEPENDS_gst_plugins_bad_dccp = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_dccp = /usr/lib/gstreamer-0.10/libgstdccp.so

RDEPENDS_gst_plugins_bad_debugutilsbad = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_debugutilsbad = /usr/lib/gstreamer-0.10/libgstdebugutilsbad.so

RDEPENDS_gst_plugins_bad_decklink = gst_plugins_bad libgcc1 libz1 libc6 libgstvideo libxml2 gstreamer libgstinterfaces libffi6 libstdc++6 libglib liborc
FILES_gst_plugins_bad_decklink = /usr/lib/gstreamer-0.10/libgstdecklink.so

RDEPENDS_gst_plugins_bad_dtmf = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgstrtp libc6 libglib
FILES_gst_plugins_bad_dtmf = /usr/lib/gstreamer-0.10/libgstdtmf.so

RDEPENDS_gst_plugins_bad_dtsdec= gst_plugins_bad libdca0 libz1 libgstpbutils libgstaudio libxml2 gstreamer libgstinterfaces libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_dtsdec = /usr/lib/gstreamer-0.10/libgstdtsdec.so

RDEPENDS_gst_plugins_bad_dvb= gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_dvb = /usr/lib/gstreamer-0.10/libgstdvb.so

RDEPENDS_gst_plugins_bad_dvbsuboverlay = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_dvbsuboverlay = /usr/lib/gstreamer-0.10/libgstdvbsuboverlay.so

RDEPENDS_gst_plugins_bad_dvdspu = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_dvdspu = /usr/lib/gstreamer-0.10/libgstdvdspu.so

RDEPENDS_gst_plugins_bad_faad= gst_plugins_bad libfaad2 libz1 libgstpbutils libgstaudio libxml2 gstreamer libgstinterfaces libffi6 libc6 libglib
FILES_gst_plugins_bad_faad = /usr/lib/gstreamer-0.10/libgstfaad.so

RDEPENDS_gst_plugins_bad_faceoverlay= gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_faceoverlay = /usr/lib/gstreamer-0.10/libgstfaceoverlay.so

RDEPENDS_gst_plugins_bad_fbdevsink= gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_fbdevsink = /usr/lib/gstreamer-0.10/libgstfbdevsink.so

RDEPENDS_gst_plugins_bad_festival= gst_plugins_bad gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib
FILES_gst_plugins_bad_festival = /usr/lib/gstreamer-0.10/libgstfestival.so

RDEPENDS_gst_plugins_bad_fieldanalysis=  gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_fieldanalysis = /usr/lib/gstreamer-0.10/libgstfieldanalysis.so

RDEPENDS_gst_plugins_bad_fragmented = gst_plugins_bad gstreamer libgstpbutils libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_fragmented = /usr/lib/gstreamer-0.10/libgstfragmented.so

RDEPENDS_gst_plugins_bad_freeverb =  gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_freeverb = /usr/lib/gstreamer-0.10/libgstfreeverb.so

RDEPENDS_gst_plugins_bad_freeze = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_freeze = /usr/lib/gstreamer-0.10/libgstfreeze.so

RDEPENDS_gst_plugins_bad_frei0r =  gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_frei0r = /usr/lib/gstreamer-0.10/libgstfrei0r.so

RDEPENDS_gst_plugins_bad_gaudieffects = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_gaudieffects = /usr/lib/gstreamer-0.10/libgstgaudieffects.so

RDEPENDS_gst_plugins_bad_geometrictransform = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_geometrictransform = /usr/lib/gstreamer-0.10/libgstgeometrictransform.so

RDEPENDS_gst_plugins_bad_glib =
FILES_gst_plugins_bad_glib = /usr/share/glib-2.0/schemas/*

RDEPENDS_gst_plugins_bad_gsettingselements = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_gsettingselements = /usr/lib/gstreamer-0.10/libgstgsettingselements.so

RDEPENDS_gst_plugins_bad_h264parse = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_h264parse = /usr/lib/gstreamer-0.10/libgsth264parse.so

RDEPENDS_gst_plugins_bad_hdvparse = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_hdvparse = /usr/lib/gstreamer-0.10/libgsthdvparse.so

RDEPENDS_gst_plugins_bad_id3tag = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_id3tag = /usr/lib/gstreamer-0.10/libgstid3tag.so

RDEPENDS_gst_plugins_bad_inter = gst_plugins_bad libz1 libgstpbutils libgstaudio libgstvideo libxml2 gstreamer libgstinterfaces libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_inter = /usr/lib/gstreamer-0.10/libgstinter.so

RDEPENDS_gst_plugins_bad_interlace = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_interlace = /usr/lib/gstreamer-0.10/libgstinterlace.so

RDEPENDS_gst_plugins_bad_ivfparse =  gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_ivfparse = /usr/lib/gstreamer-0.10/libgstivfparse.so

RDEPENDS_gst_plugins_bad_jp2kdecimator = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_jp2kdecimator = /usr/lib/gstreamer-0.10/libgstjp2kdecimator.so

RDEPENDS_gst_plugins_bad_jpegformat = gst_plugins_bad gstreamer libxml2 libz1 libgstinterfaces libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_jpegformat = /usr/lib/gstreamer-0.10/libgstjpegformat.so

RDEPENDS_gst_plugins_bad_legacyresample = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_legacyresample = /usr/lib/gstreamer-0.10/libgstlegacyresample.so

RDEPENDS_gst_plugins_bad_linsys = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_linsys = /usr/lib/gstreamer-0.10/libgstlinsys.so

RDEPENDS_gst_plugins_bad_liveadder =   gst_plugins_bad gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib
FILES_gst_plugins_bad_liveadder = /usr/lib/gstreamer-0.10/libgstliveadder.so

RDEPENDS_gst_plugins_bad_meta = gst_plugins_bad_mve gst_plugins_bad_cog gst_plugins_bad_h264parse gst_plugins_bad_rtpvp8 gst_plugins_bad_videomeasure gst_plugins_bad_colorspace gst_plugins_bad_smooth gst_plugins_bad_curl libgstsignalprocessor gst_plugins_bad_freeverb gst_plugins_bad_dtmf gst_plugins_bad_videofiltersbad gst_plugins_bad_gsettingselements gst_plugins_bad_faceoverlay gst_plugins_bad_mpegvideoparse gst_plugins_bad_festival gst_plugins_bad_bayer gst_plugins_bad gst_plugins_bad_linsys gst_plugins_bad_mxf gst_plugins_bad_sdi gst_plugins_bad_liveadder gst_plugins_bad_fragmented libgstcodecparsers gst_plugins_bad_id3tag gst_plugins_bad_dataurisrc gst_plugins_bad_inter gst_plugins_bad_shm libgstphotography gst_plugins_bad_geometrictransform gst_plugins_bad_patchdetect gst_plugins_bad_tta libgstbasecamerabinsrc gst_plugins_bad_vcdsrc libgstbasevideo gst_plugins_bad_aiff gst_plugins_bad_vp8 gst_plugins_bad_nsf gst_plugins_bad_debugutilsbad gst_plugins_bad_camerabin gst_plugins_bad_siren gst_plugins_bad_bz2 gst_plugins_bad_removesilence gst_plugins_bad_glib gst_plugins_bad_videosignal gst_plugins_bad_mms gst_plugins_bad_legacyresample gst_plugins_bad_mpegtsmux gst_plugins_bad_subenc gst_plugins_bad_resindvd gst_plugins_bad_dtsdec gst_plugins_bad_meta gst_plugins_bad_apps gst_plugins_bad_adpcmenc gst_plugins_bad_mpegdemux gst_plugins_bad_speed gst_plugins_bad_jpegformat gst_plugins_bad_interlace gst_plugins_bad_rawparse gst_plugins_bad_pcapparse gst_plugins_bad_autoconvert gst_plugins_bad_fbdevsink gst_plugins_bad_camerabin2 gst_plugins_bad_cdxaparse gst_plugins_bad_segmentclip gst_plugins_bad_jp2kdecimator gst_plugins_bad_nuvdemux gst_plugins_bad_rtpmux gst_plugins_bad_sdpelem gst_plugins_bad_hdvparse gst_plugins_bad_coloreffects gst_plugins_bad_dvbsuboverlay gst_plugins_bad_rfbsrc gst_plugins_bad_stereo gst_plugins_bad_fieldanalysis gst_plugins_bad_faad gst_plugins_bad_dvb gst_plugins_bad_rtmp gst_plugins_bad_asfmux gst_plugins_bad_dccp gst_plugins_bad_videomaxrate gst_plugins_bad_gaudieffects gst_plugins_bad_mpegpsmux gst_plugins_bad_freeze gst_plugins_bad_dvdspu gst_plugins_bad_adpcmdec gst_plugins_bad_vmnc gst_plugins_bad_frei0r gst_plugins_bad_pnm gst_plugins_bad_audiovisualizers gst_plugins_bad_decklink gst_plugins_bad_ivfparse gst_plugins_bad_scaletempoplugin gst_plugins_bad_sndfile gst_plugins_bad_y4mdec gst_plugins_bad_mpegtsdemux gst_plugins_bad_videoparsersbad
FILES_gst_plugins_bad_meta = /var

RDEPENDS_gst_plugins_bad_mms =  gst_plugins_bad libmms0 gstreamer libc6 libffi6 libz1 libxml2 libglib
FILES_gst_plugins_bad_mms = /usr/lib/gstreamer-0.10/libgstmms.so

RDEPENDS_gst_plugins_bad_mpegdemux = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_mpegdemux = /usr/lib/gstreamer-0.10/libgstmpegdemux.so

RDEPENDS_gst_plugins_bad_mpegpsmux = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_mpegpsmux = /usr/lib/gstreamer-0.10/libgstmpegpsmux.so

RDEPENDS_gst_plugins_bad_mpegtsdemux = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgsttag libc6 libglib
FILES_gst_plugins_bad_mpegtsdemux = /usr/lib/gstreamer-0.10/libgstmpegtsdemux.so

RDEPENDS_gst_plugins_bad_mpegtsmux = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_mpegtsmux = /usr/lib/gstreamer-0.10/libgstmpegtsmux.so

RDEPENDS_gst_plugins_bad_mpegvideoparse = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_mpegvideoparse = /usr/lib/gstreamer-0.10/libgstmpegvideoparse.so

RDEPENDS_gst_plugins_bad_mve = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_mve = /usr/lib/gstreamer-0.10/libgstmve.so

RDEPENDS_gst_plugins_bad_mxf = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_mxf = /usr/lib/gstreamer-0.10/libgstmxf.so

RDEPENDS_gst_plugins_bad_nsf = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_nsf = /usr/lib/gstreamer-0.10/libgstnsf.so

RDEPENDS_gst_plugins_bad_nuvdemux = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_nuvdemux = /usr/lib/gstreamer-0.10/libgstnuvdemux.so

DEPENDS_gst_plugins_bad_patchdetect = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_patchdetect = /usr/lib/gstreamer-0.10/libgstpatchdetect.so

RDEPENDS_gst_plugins_bad_pcapparse = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_pcapparse = /usr/lib/gstreamer-0.10/libgstpcapparse.so

RDEPENDS_gst_plugins_bad_pnm = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_pnm = /usr/lib/gstreamer-0.10/libgstpnm.so

RDEPENDS_gst_plugins_bad_rawparse = gst_plugins_bad libz1 libgstpbutils libgstaudio libgstvideo libxml2 gstreamer libgstinterfaces libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_rawparse = /usr/lib/gstreamer-0.10/libgstrawparse.so

RDEPENDS_gst_plugins_bad_removesilence = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_removesilence = /usr/lib/gstreamer-0.10/libgstremovesilence.so

RDEPENDS_gst_plugins_bad_resindvd = gst_plugins_bad gstreamer libgstpbutils libgstvideo libxml2 libz1 libgstinterfaces libffi6 libdvdread4 libdvdnav4 libc6 libglib liborc
FILES_gst_plugins_bad_resindvd = /usr/lib/gstreamer-0.10/libgstresindvd.so

RDEPENDS_gst_plugins_bad_rfbsrc = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_rfbsrc = /usr/lib/gstreamer-0.10/libgstrfbsrc.so

RDEPENDS_gst_plugins_bad_rtmp = gst_plugins_bad libssl1 gstreamer libxml2 libz1 librtmp1 libffi6 libcrypto1 libc6 libglib
FILES_gst_plugins_bad_rtmp = /usr/lib/gstreamer-0.10/libgstrtmp.so

RDEPENDS_gst_plugins_bad_rtpmux = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgstrtp libc6 libglib
FILES_gst_plugins_bad_rtpmux = /usr/lib/gstreamer-0.10/libgstrtpmux.so

RDEPENDS_gst_plugins_bad_rtpvp8 = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libgstrtp libc6 libglib
FILES_gst_plugins_bad_rtpvp8 = /usr/lib/gstreamer-0.10/libgstrtpvp8.so

RDEPENDS_gst_plugins_bad_scaletempoplugin = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_scaletempoplugin = /usr/lib/gstreamer-0.10/libgstscaletempoplugin.so

RDEPENDS_gst_plugins_bad_sdi = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_sdi = /usr/lib/gstreamer-0.10/libgstsdi.so

RDEPENDS_gst_plugins_bad_sdpelem = gst_plugins_bad gstreamer libc6 libxml2 libz1 libgstinterfaces libffi6 libgstrtp libgstsdp libglib
FILES_gst_plugins_bad_sdpelem = /usr/lib/gstreamer-0.10/libgstsdpelem.so

RDEPENDS_gst_plugins_bad_segmentclip = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_segmentclip = /usr/lib/gstreamer-0.10/libgstsegmentclip.so

RDEPENDS_gst_plugins_bad_shm = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_shm = /usr/lib/gstreamer-0.10/libgstshm.so

RDEPENDS_gst_plugins_bad_siren = gst_plugins_bad gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib
FILES_gst_plugins_bad_siren = /usr/lib/gstreamer-0.10/libgstsiren.so

RDEPENDS_gst_plugins_bad_smooth = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_smooth = /usr/lib/gstreamer-0.10/libgstsmooth.so

RDEPENDS_gst_plugins_bad_sndfile = gst_plugins_bad libsndfile1 libffi6 libxml2 gstreamer libc6 libglib libz1
FILES_gst_plugins_bad_sndfile = /usr/lib/gstreamer-0.10/libgstsndfile.so

RDEPENDS_gst_plugins_bad_speed = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_speed = /usr/lib/gstreamer-0.10/libgstspeed.so

RDEPENDS_gst_plugins_bad_stereo = gst_plugins_bad gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib
FILES_gst_plugins_bad_stereo = /usr/lib/gstreamer-0.10/libgststereo.so

RDEPENDS_gst_plugins_bad_subenc = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_subenc = /usr/lib/gstreamer-0.10/libgstsubenc.so

RDEPENDS_gst_plugins_bad_tta = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_tta = /usr/lib/gstreamer-0.10/libgsttta.so

RDEPENDS_gst_plugins_bad_vcdsrc = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_vcdsrc = /usr/lib/gstreamer-0.10/libgstvcdsrc.so

RDEPENDS_gst_plugins_bad_videofiltersbad = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_videofiltersbad = /usr/lib/gstreamer-0.10/libgstvideofiltersbad.so

RDEPENDS_gst_plugins_bad_videomaxrate = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_videomaxrate = /usr/lib/gstreamer-0.10/libgstvideomaxrate.so

RDEPENDS_gst_plugins_bad_videomeasure = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_videomeasure = /usr/lib/gstreamer-0.10/libgstvideomeasure.so

RDEPENDS_gst_plugins_bad_videoparsersbad = gst_plugins_bad gstreamer libgstpbutils libgstvideo libxml2 libz1 libffi6 libgstcodecparsers libc6 libglib liborc
FILES_gst_plugins_bad_videoparsersbad = /usr/lib/gstreamer-0.10/libgstvideoparsersbad.so

RDEPENDS_gst_plugins_bad_videosignal = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libc6 libglib liborc
FILES_gst_plugins_bad_videosignal = /usr/lib/gstreamer-0.10/libgstvideosignal.so

RDEPENDS_gst_plugins_bad_vmnc = gst_plugins_bad gstreamer libxml2 libz1 libffi6 libc6 libglib
FILES_gst_plugins_bad_vmnc = /usr/lib/gstreamer-0.10/libgstvmnc.so

RDEPENDS_gst_plugins_bad_vp8 = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libgsttag libc6 libglib liborc
FILES_gst_plugins_bad_vp8 = /usr/lib/gstreamer-0.10/libgstvp8.so

RDEPENDS_gst_plugins_bad_y4mdec = gst_plugins_bad gstreamer libgstvideo libxml2 libz1 libffi6 libgsttag libc6 libglib liborc
FILES_gst_plugins_bad_y4mdec = /usr/lib/gstreamer-0.10/libgsty4mdec.so

RDEPENDS_gst_plugins_bad =
FILES_gst_plugins_bad = /usr/share/gstreamer-0.10/presets/GstVP8Enc.prs

RDEPENDS_libgstbasecamerabinsrc = libffi6 libxml2 libz1 gstreamer libc6 libglib libgstapp
FILES_libgstbasecamerabinsrc = /usr/lib/libgstbasecamerabinsrc*.so.*
define postinst_libgstbasecamerabinsrc
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstbasevideo = libffi6 libgstvideo libxml2 libz1 gstreamer libc6 libglib liborc
FILES_libgstbasevideo = /usr/lib/libgstbasevideo*.so.*
define postinst_libgstbasevideo
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstcodecparsers = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstcodecparsers = /usr/lib/libgstcodecparsers*.so.*
define postinst_libgstcodecparsers
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstphotography = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstphotography = /usr/lib/libgstphotography*.so.*
define postinst_libgstphotography
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libgstsignalprocessor = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib
FILES_libgstsignalprocessor = /usr/lib/libgstsignalprocessor*.so.*
define postinst_libgstsignalprocessor
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
