#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_good

BDEPENDS_${P} = $(target_gst_plugins_base) $(target_cdparanoia) $(target_cairo) $(target_libpng)  $(target_zlib) $(target_libid3tag) $(target_flac) $(target_speex) $(target_libsoup)
ifdef CONFIG_ENIGMA2_SRC_MAX
BDEPENDS_${P} += $(target_libjpeg_turbo)
RDEPENDS_gst_plugins_good_jpeg = libjpeg-turbo
else
BDEPENDS_${P} += $(target_libjpeg)
RDEPENDS_gst_plugins_good_jpeg = libjpeg8
endif

ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://anongit.freedesktop.org/gstreamer/gst-plugins-good;b=0.10;r=7768342
  patch:file://0001-accept-substream-syncwords-DTS-HD.patch
  patch:file://0002-gstflvdemux-max-width-height.patch
  patch:file://0003-qtdemux-don-t-assert-if-upstream-size-is-not-availab.patch
  patch:file://0004-MatroskaDemux-Set-profile-field-in-cap-for-aac-audio.patch
  patch:file://0005-FlvDemux-Set-profile-field-in-cap-for-aac-audio.patch
  patch:file://0006-Matroska-Demux-Handle-TrueHD-audio-codec-id.patch
  nothing:file://orc.m4-fix-location-of-orcc-when-cross-compiling.patch
]]rule

call[[ git ]]

else

PV_${P} = 0.10.31
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.bz2
  patch:file://0001-v4l2-fix-build-with-recent-kernels-the-v4l2_buffer-i.patch
  patch:file://0001-v4l2_calls-define-V4L2_CID_HCENTER-and-V4L2_CID_VCEN.patch
  patch:file://${PN}-0.10.29_avidemux_only_send_pts_on_keyframe.patch
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
		--disable-esd \
		--disable-gtk-doc \
		--disable-aalib \
		--disable-esdtest \
		--disable-aalib \
		--disable-shout2 \
		--disable-libcaca \
		--disable-hal \
		--disable-examples \
		--disable-taglib \
	&& \
	$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	rm -r $(PKDIR)/usr/share/locale
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = GStreamer Multimedia Framework good plugins
PACKAGES_${P} = \
gst_plugins_good_alaw \
gst_plugins_good_alpha \
gst_plugins_good_alphacolor \
gst_plugins_good_annodex \
gst_plugins_good_apetag \
gst_plugins_good_audiofx \
gst_plugins_good_audioparsers \
gst_plugins_good_auparse \
gst_plugins_good_autodetect \
gst_plugins_good_avi \
gst_plugins_good_cairo \
gst_plugins_good_cutter \
gst_plugins_good_debug \
gst_plugins_good_deinterlace \
gst_plugins_good_efence \
gst_plugins_good_effectv \
gst_plugins_good_equalizer \
gst_plugins_good_flac \
gst_plugins_good_flv \
gst_plugins_good_flxdec \
gst_plugins_good_icydemux \
gst_plugins_good_id3demux \
gst_plugins_good_imagefreeze \
gst_plugins_good_interleave \
gst_plugins_good_isomp4 \
gst_plugins_good_jpeg \
gst_plugins_good_level \
gst_plugins_good_matroska \
gst_plugins_good_meta \
gst_plugins_good_mulaw \
gst_plugins_good_multifile \
gst_plugins_good_multipart \
gst_plugins_good_navigationtest \
gst_plugins_good_oss4audio \
gst_plugins_good_ossaudio \
gst_plugins_good_png \
gst_plugins_good_replaygain \
gst_plugins_good_rtp \
gst_plugins_good_rtpmanager \
gst_plugins_good_rtsp \
gst_plugins_good_shapewipe \
gst_plugins_good_smpte \
gst_plugins_good_souphttpsrc \
gst_plugins_good_spectrum \
gst_plugins_good_speex \
gst_plugins_good_udp \
gst_plugins_good_video4linux2 \
gst_plugins_good_videobox \
gst_plugins_good_videocrop \
gst_plugins_good_videofilter \
gst_plugins_good_videomixer \
gst_plugins_good_wavenc \
gst_plugins_good_wavparse \
gst_plugins_good_y4menc \
gst_plugins_good


RDEPENDS_gst_plugins_good_alaw = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_alaw = /usr/lib/gstreamer-0.10/libgstalaw.so

RDEPENDS_gst_plugins_good_alpha = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_alpha = /usr/lib/gstreamer-0.10/libgstalpha.so

RDEPENDS_gst_plugins_good_alphacolor = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_alphacolor = /usr/lib/gstreamer-0.10/libgstalphacolor.so

RDEPENDS_gst_plugins_good_annodex = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_annodex = /usr/lib/gstreamer-0.10/libgstannodex.so

RDEPENDS_gst_plugins_good_apetag = libffi6 libgstpbutils libxml2 libz1 gstreamer gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_apetag = /usr/lib/gstreamer-0.10/libgstapetag.so

RDEPENDS_gst_plugins_good_audiofx = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstfft libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_audiofx = /usr/lib/gstreamer-0.10/libgstaudiofx.so

RDEPENDS_gst_plugins_good_audioparsers = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_audioparsers = /usr/lib/gstreamer-0.10/libgstaudioparsers.so

RDEPENDS_gst_plugins_good_auparse = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_auparse = /usr/lib/gstreamer-0.10/libgstauparse.so

RDEPENDS_gst_plugins_good_autodetect = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_autodetect = /usr/lib/gstreamer-0.10/libgstautodetect.so

RDEPENDS_gst_plugins_good_avi = libgstriff gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_avi = /usr/lib/gstreamer-0.10/libgstavi.so

RDEPENDS_gst_plugins_good_cairo = gstreamer libpng16 libgstvideo libpixman libxml2 libz1 libfreetype6 libffi6 gst_plugins_good libcairo2 libc6 libglib libcairo-gobject2 libexpat1 liborc libfontconfig1
FILES_gst_plugins_good_cairo = /usr/lib/gstreamer-0.10/libgstcairo.so

RDEPENDS_gst_plugins_good_cutter = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_cutter = /usr/lib/gstreamer-0.10/libgstcutter.so

RDEPENDS_gst_plugins_good_debug = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_debug = /usr/lib/gstreamer-0.10/libgstdebug.so

RDEPENDS_gst_plugins_good_deinterlace = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_deinterlace = /usr/lib/gstreamer-0.10/libgstdeinterlace.so

RDEPENDS_gst_plugins_good_efence = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_efence = /usr/lib/gstreamer-0.10/libgstefence.so

RDEPENDS_gst_plugins_good_effectv = libffi6 libgstvideo libxml2 libz1 gstreamer gst-plugins-good libc6 libglib liborc
FILES_gst_plugins_good_effectv = /usr/lib/gstreamer-0.10/libgsteffectv.so

RDEPENDS_gst_plugins_good_equalizer = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_equalizer = /usr/lib/gstreamer-0.10/libgstequalizer.so

RDEPENDS_gst_plugins_good_flac = libogg0 gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib libflac8
FILES_gst_plugins_good_flac = /usr/lib/gstreamer-0.10/libgstflac.so

RDEPENDS_gst_plugins_good_flv = libffi6 libgstpbutils libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_flv = /usr/lib/gstreamer-0.10/libgstflv.so

RDEPENDS_gst_plugins_good_flxdec= libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_flxdec = /usr/lib/gstreamer-0.10/libgstflxdec.so

RDEPENDS_gst_plugins_good_goom2k1= libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_goom2k1 = /usr/lib/gstreamer-0.10/libgstgoom2k1.so

RDEPENDS_gst_plugins_good_goom= libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_goom = /usr/lib/gstreamer-0.10/libgstgoom.so

RDEPENDS_gst_plugins_good_icydemux= libffi6 libxml2 libz1 gstreamer gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_icydemux = /usr/lib/gstreamer-0.10/libgsticydemux.so

RDEPENDS_gst_plugins_good_id3demux= libffi6 libgstpbutils libxml2 libz1 gstreamer gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_id3demux = /usr/lib/gstreamer-0.10/libgstid3demux.so

RDEPENDS_gst_plugins_good_imagefreeze= libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_imagefreeze = /usr/lib/gstreamer-0.10/libgstimagefreeze.so

RDEPENDS_gst_plugins_good_interleave= gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_interleave = /usr/lib/gstreamer-0.10/libgstinterleave.so

RDEPENDS_gst_plugins_good_isomp4= libgstriff gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libgstrtp libc6 libglib
FILES_gst_plugins_good_isomp4 = /usr/lib/gstreamer-0.10/libgstisomp4.so

RDEPENDS_gst_plugins_good_jpeg += libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_jpeg += /usr/lib/gstreamer-0.10/libgstjpeg.so

RDEPENDS_gst_plugins_good_level = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_level = /usr/lib/gstreamer-0.10/libgstlevel.so

RDEPENDS_gst_plugins_good_matroska =  libgstriff gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib libbz2
FILES_gst_plugins_good_matroska = /usr/lib/gstreamer-0.10/libgstmatroska.so

RDEPENDS_gst_plugins_good_meta = gst_plugins_good_video4linux2 gst_plugins_good_cairo gst_plugins_good_isomp4 gst_plugins_good_flxdec gst_plugins_good_png gst_plugins_good_level gst_plugins_good_goom2k1 gst_plugins_good_matroska gst_plugins_good_apps gst_plugins_good_flac gst_plugins_good_id3demux gst_plugins_good_wavparse gst_plugins_good_videobox gst_plugins_good_audiofx gst_plugins_good_videomixer gst_plugins_good_deinterlace gst_plugins_good_jpeg gst_plugins_good_interleave gst_plugins_good_oss4audio gst_plugins_good_rtsp gst_plugins_good_flv gst_plugins_good_alphacolor gst_plugins_good_autodetect gst_plugins_good_shapewipe gst_plugins_good_replaygain gst_plugins_good_videocrop gst_plugins_good_cutter gst_plugins_good-rtpmanager gst_plugins_good_audioparsers gst_plugins_good_udp gst_plugins_good_rtp gst_plugins_good_alpha gst_plugins_good_debug gst_plugins_good_meta gst_plugins_good_wavenc gst_plugins_good_y4menc gst_plugins_good_goom gst_plugins_good_smpte gst_plugins_good_equalizer gst_plugins_good_multifile gst_plugins_good_speex gst_plugins_good_navigationtest gst_plugins_good_multipart gst_plugins_good_effectv gst_plugins_good_ossaudio gst_plugins_good_imagefreeze gst_plugins_good_videofilter gst_plugins_good_mulaw gst_plugins_good_glib gst_plugins_good_alaw gst_plugins_good gst_plugins_good_souphttpsrc gst_plugins_good_icydemux gst_plugins_good_avi gst_plugins_good_apetag gst_plugins_good_auparse gst_plugins_good_efence gst_plugins_good_spectrum gst_plugins_good_annodex
FILES_gst_plugins_good_meta = /var

RDEPENDS_gst_plugins_good_mulaw = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_mulaw = /usr/lib/gstreamer-0.10/libgstmulaw.so

RDEPENDS_gst_plugins_good_multifile = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_multifile = /usr/lib/gstreamer-0.10/libgstmultifile.so

RDEPENDS_gst_plugins_good_multipart = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_multipart = /usr/lib/gstreamer-0.10/libgstmultipart.so

RDEPENDS_gst_plugins_good_navigationtest = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_navigationtest = /usr/lib/gstreamer-0.10/libgstnavigationtest.so

RDEPENDS_gst_plugins_good_oss4audio = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_oss4audio = /usr/lib/gstreamer-0.10/libgstoss4audio.so

RDEPENDS_gst_plugins_good_ossaudio = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_ossaudio = /usr/lib/gstreamer-0.10/libgstossaudio.so

RDEPENDS_gst_plugins_good_png = libffi6 libpng16 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_png = /usr/lib/gstreamer-0.10/libgstpng.so

RDEPENDS_gst_plugins_good_replaygain = libffi6 libgstpbutils libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_replaygain = /usr/lib/gstreamer-0.10/libgstreplaygain.so

RDEPENDS_gst_plugins_good_rtp = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libgstrtp libc6 libglib
FILES_gst_plugins_good_rtp = /usr/lib/gstreamer-0.10/libgstrtp.so

RDEPENDS_gst_plugins_good_rtpmanager = libffi6 libxml2 libz1 gstreamer libgstnetbuffer gst_plugins_good libgstrtp libc6 libglib
FILES_gst_plugins_good_rtpmanager = /usr/lib/gstreamer-0.10/libgstrtpmanager.so

RDEPENDS_gst_plugins_good_rtsp =  libffi6 libc6 libxml2 libz1 gstreamer libgstinterfaces gst_plugins_good libgstrtp libgstsdp libglib libgstrtsp
FILES_gst_plugins_good_rtsp = /usr/lib/gstreamer-0.10/libgstrtsp.so

RDEPENDS_gst_plugins_good_shapewipe = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_shapewipe = /usr/lib/gstreamer-0.10/libgstshapewipe.so

RDEPENDS_gst_plugins_good_smpte = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_smpte = /usr/lib/gstreamer-0.10/libgstsmpte.so

RDEPENDS_gst_plugins_good_souphttpsrc = gstreamer libxml2 libz1 libsoup gst_plugins_good libgsttag libsqlite3 libc6 libglib libffi6
FILES_gst_plugins_good_souphttpsrc = /usr/lib/gstreamer-0.10/libgstsouphttpsrc.so

RDEPENDS_gst_plugins_good_spectrum = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstfft libgstinterfaces libffi6 gst_plugins_good libc6 libglib
FILES_gst_plugins_good_spectrum = /usr/lib/gstreamer-0.10/libgstspectrum.so


RDEPENDS_gst_plugins_good_speex =  speex gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_speex = /usr/lib/gstreamer-0.10/libgstspeex.so

RDEPENDS_gst_plugins_good_udp = libffi6 libxml2 libz1 gstreamer libgstnetbuffer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_udp = /usr/lib/gstreamer-0.10/libgstudp.so

RDEPENDS_gst_plugins_good_video4linux2 =  gstreamer libc6 libgstvideo libxml2 libz1 udev libgstinterfaces libffi6 gst_plugins_good libglib liborc
FILES_gst_plugins_good_video4linux2 = /usr/lib/gstreamer-0.10/libgstvideo4linux2.so

RDEPENDS_gst_plugins_good_videobox = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_videobox = /usr/lib/gstreamer-0.10/libgstvideobox.so

RDEPENDS_gst_plugins_good_videocrop = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_videocrop = /usr/lib/gstreamer-0.10/libgstvideocrop.so

RDEPENDS_gst_plugins_good_videofilter = libffi6 libgstvideo libxml2 libz1 gstreamer libgstinterfaces gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_videofilter = /usr/lib/gstreamer-0.10/libgstvideofilter.so

RDEPENDS_gst_plugins_good_videomixer = libffi6 libgstvideo libxml2 libz1 gstreamer gst_plugins_good libc6 libglib liborc
FILES_gst_plugins_good_videomixer = /usr/lib/gstreamer-0.10/libgstvideomixer.so

RDEPENDS_gst_plugins_good_wavenc = libgstriff gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_wavenc = /usr/lib/gstreamer-0.10/libgstwavenc.so

RDEPENDS_gst_plugins_good_wavparse = libgstriff gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 gst_plugins_good libgsttag libc6 libglib
FILES_gst_plugins_good_wavparse = /usr/lib/gstreamer-0.10/libgstwavparse.so

RDEPENDS_gst_plugins_good_y4menc = libffi6 libxml2 libz1 gstreamer gst_plugins_good libc6 libglib
FILES_gst_plugins_good_y4menc = /usr/lib/gstreamer-0.10/libgsty4menc.so

RDEPENDS_gst_plugins_good =
FILES_gst_plugins_good = /usr/share/gstreamer-0.10/presets/GstIirEqualizer10Bands.prs /usr/share/gstreamer-0.10/presets/GstIirEqualizer3Bands.prs
call[[ ipkbox ]]

]]package
