#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_base

BDEPENDS_${P} = $(target_freetype) $(target_glib2) $(target_orc) $(target_gstreamer) $(target_libalsa) $(target_libogg) $(target_libvorbis) $(target_libtheora) $(target_liboil) $(target_tremor) $(target_cdparanoia)

ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://anongit.freedesktop.org/gstreamer/gst-plugins-base;b=0.10;r=bdb3316
  patch:file://disable-vorbis-encoder.patch
  patch:file://gst-plugins-base-tremor.patch 
  patch:file://configure.ac-fix-subparse-plugin.patch 
  patch:file://revert-0dfdd9186e143daa568521c4e55c9923e5cbc466.patch
  nothing:file://orc.m4-fix-location-of-orcc-when-cross-compiling.patch
]]rule

call[[ git ]]

else

PV_${P} = 0.10.36
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.bz2
  patch:file://gst-plugins-base-tremor.patch
  patch:file://configure.ac-fix-subparse-plugin.patch
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
		--libexecdir=/usr/lib/gstreamer/ \
		--prefix=/usr \
		--disable-freetypetest \
		--disable-pango \
		--disable-gnome_vfs \
		--enable-orc \
		--with-audioresample-format=int \
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
libgstapp \
libgstaudio \
libgstcdda \
libgstfft \
libgstinterfaces \
libgstnetbuffer \
libgstpbutils\
libgstriff \
libgstrtp \
libgstrtsp \
libgstsdp \
libgsttag \
libgstvideo \
gst_plugins_base_adder \
gst_plugins_base_alsa \
gst_plugins_base_app \
gst_plugins_base_audioconvert \
gst_plugins_base_audiorate \
gst_plugins_base_audioresample \
gst_plugins_base_audiotestsrc \
gst_plugins_base_cdparanoia \
gst_plugins_base_decodebin2 \
gst_plugins_base_decodebin \
gst_plugins_base_encodebin \
gst_plugins_base_ffmpegcolorspace \
gst_plugins_base_gdp \
gst_plugins_base_gio \
gst_plugins_base_ogg \
gst_plugins_base_ivorbisdec \
gst_plugins_base_meta \
gst_plugins_base_playbin \
gst_plugins_base_subparse \
gst_plugins_base_tcp \
gst_plugins_base_theora \
gst_plugins_base_typefindfunctions \
gst_plugins_base_videorate \
gst_plugins_base_videoscale \
gst_plugins_base_videotestsrc \
gst_plugins_base_volume \
gst_plugins_base_vorbis \
gst_plugins_base

RDEPENDS_libgstapp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstapp = /usr/lib/libgstapp*.so.*
define postinst_libgstapp
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstaudio = libffi6 libgstpbutils libxml2 libz1 gstreamer libgstinterfaces libc6 libglib
FILES_libgstaudio = /usr/lib/libgstaudio*.so.*
define postinst_libgstaudio
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstcdda = libffi6 libxml2 libz1 gstreamer libgsttag libc6 libglib
FILES_libgstcdda = /usr/lib/libgstcdda*.so.*
define postinst_libgstcdda
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstfft = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstfft = /usr/lib/libgstfft*.so.*
define postinst_libgstfft
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstinterfaces = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstinterfaces = /usr/lib/libgstinterfaces*.so.*
define postinst_libgstinterfaces
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstnetbuffer = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstnetbuffer = /usr/lib/libgstnetbuffer*.so.*
define postinst_libgstnetbuffer
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstpbutils = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstpbutils = /usr/lib/libgstpbutils*.so.*
define postinst_libgstpbutils
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstriff = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libgsttag libc6 libglib
FILES_libgstriff = /usr/lib/libgstriff*.so.*
define postinst_libgstriff
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstrtp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstrtp = /usr/lib/libgstrtp*.so.*
define postinst_libgstrtp
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstrtsp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstrtsp = /usr/lib/libgstrtsp*.so.*
define postinst_libgstrtsp
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstsdp = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgstsdp = /usr/lib/libgstsdp*.so.*
define postinst_libgstsdp
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgsttag = libz1 libxml2 libffi6 gstreamer libc6 libglib
FILES_libgsttag = /usr/lib/libgsttag*.so.*
define postinst_libgsttag
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_libgstvideo = libffi6 libxml2 libz1 gstreamer libc6 libglib liborc
FILES_libgstvideo = /usr/lib/libgstvideo*.so.*
define postinst_libgstvideo
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

RDEPENDS_gst_plugins_base_adder = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_adder = /usr/lib/gstreamer-0.10/libgstadder.so

RDEPENDS_gst_plugins_base_alsa = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib libasound2 gst_plugins_base
FILES_gst_plugins_base_alsa = /usr/lib/gstreamer-0.10/libgstalsa.so

RDEPENDS_gst_plugins_base_app = libffi6 libxml2 libz1 gstreamer libgstapp libc6 libglib gst_plugins_base
FILES_gst_plugins_base_app = /usr/lib/gstreamer-0.10/libgstapp.so

RDEPENDS_gst_plugins_base_audioconvert = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_audioconvert = /usr/lib/gstreamer-0.10/libgstaudioconvert.so

RDEPENDS_gst_plugins_base_audiorate = libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_audiorate = /usr/lib/gstreamer-0.10/libgstaudiorate.so

RDEPENDS_gst_plugins_base_audioresample = libffi6 libxml2 libz1 gstreamer liborc_test libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_audioresample = /usr/lib/gstreamer-0.10/libgstaudioresample.so

RDEPENDS_gst_plugins_base_audiotestsrc = libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_audiotestsrc = /usr/lib/gstreamer-0.10/libgstaudiotestsrc.so

RDEPENDS_gst_plugins_base_cdparanoia = libz1 libcdparanoia libxml2 libffi6 gstreamer libgsttag libc6 libglib libgstcdda gst_plugins_base
FILES_gst_plugins_base_cdparanoia = /usr/lib/gstreamer-0.10/libgstcdparanoia.so

RDEPENDS_gst_plugins_base_decodebin2 = libffi6 libgstpbutils libxml2 libz1 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_decodebin2 = /usr/lib/gstreamer-0.10/libgstdecodebin2.so

RDEPENDS_gst_plugins_base_decodebin = libffi6 libgstpbutils libxml2 libz1 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_decodebin = /usr/lib/gstreamer-0.10/libgstdecodebin.so

RDEPENDS_gst_plugins_base_encodebin = libffi6 libgstpbutils libxml2 libz1 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_encodebin = /usr/lib/gstreamer-0.10/libgstencodebin.so

RDEPENDS_gst_plugins_base_ffmpegcolorspace = libffi6 libgstvideo libxml2 libz1 gstreamer libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_ffmpegcolorspace = /usr/lib/gstreamer-0.10/libgstffmpegcolorspace.so

RDEPENDS_gst_plugins_base_gdp = libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_gdp = /usr/lib/gstreamer-0.10/libgstgdp.so

RDEPENDS_gst_plugins_base_gio = libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_gio = /usr/lib/gstreamer-0.10/libgstgio.so

RDEPENDS_gst_plugins_base_ogg = libgstriff libogg0 libz1 libgstpbutils libgstaudio libxml2 gstreamer libgstinterfaces libffi6 libgsttag libc6 libglib gst_plugins_base
FILES_gst_plugins_base_ogg = /usr/lib/gstreamer-0.10/libgstogg.so

RDEPENDS_gst_plugins_base_ivorbisdec = libogg0 gstreamer libgstpbutils libgstaudio libxml2 libz1 libvorbisidec1 libgstinterfaces libffi6 libgsttag libc6 libglib gst_plugins_base
FILES_gst_plugins_base_ivorbisdec = /usr/lib/gstreamer-0.10/libgstivorbisdec.so

RDEPENDS_gst_plugins_base_meta = gst_plugins_base_theora gst_plugins_base_app libgstvideo gst_plugins_base_gdp gst_plugins_base_vorbis gst_plugins_base_decodebin gst_plugins_base_audiorate \
gst_plugins_base_ivorbisdec gst_plugins_base_videotestsrc gst_plugins_base_playbin gst_plugins_base gst_plugins_base_audiotestsrc gst_plugins_base_typefindfunctions libgstnetbuffer \
libgstfft libgstinterfaces libgstsdp libgstcdda gst_plugins_base_videorate gst_plugins_base_glib libgstaudio gst_plugins_base_audioresample gst_plugins_base_decodebin2 libgstapp \
gst_plugins_base_encodebin gst_plugins_base_audioconvert gst_plugins_base_alsa gst_plugins_base_adder gst_plugins_base_ffmpegcolorspace libgstriff gst_plugins_base_subparse gst_plugins_base_apps \
libgstpbutils gst_plugins_base_volume gst_plugins_base_videoscale gst_plugins_base_cdparanoia gst_plugins_base_ogg libgsttag gst_plugins_base_tcp libgstrtp libgstrtsp gst_plugins_base_gio
FILES_gst_plugins_base_meta = /var/

RDEPENDS_gst_plugins_base_playbin = gstreamer libgstpbutils libgstvideo libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_playbin = /usr/lib/gstreamer-0.10/libgstplaybin.so

RDEPENDS_gst_plugins_base_subparse = libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_subparse = /usr/lib/gstreamer-0.10/libgstsubparse.so

RDEPENDS_gst_plugins_base_tcp= libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_tcp = /usr/lib/gstreamer-0.10/libgsttcp.so

RDEPENDS_gst_plugins_base_theora= libogg0 gstreamer libgstvideo libxml2 libz1 libffi6 libgsttag libc6 libglib liborc gst_plugins_base libtheora
FILES_gst_plugins_base_theora = /usr/lib/gstreamer-0.10/libgsttheora.so

RDEPENDS_gst_plugins_base_typefindfunctions= libffi6 libgstpbutils libxml2 libz1 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_typefindfunctions = /usr/lib/gstreamer-0.10/libgsttypefindfunctions.so

RDEPENDS_gst_plugins_base_videorate= libz1 libxml2 libffi6 gstreamer libc6 libglib gst_plugins_base
FILES_gst_plugins_base_videorate = /usr/lib/gstreamer-0.10/libgstvideorate.so

RDEPENDS_gst_plugins_base_videoscale= libffi6 libgstvideo libxml2 libz1 gstreamer libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_videoscale = /usr/lib/gstreamer-0.10/libgstvideoscale.so

RDEPENDS_gst_plugins_base_videotestsrc= libffi6 libxml2 libz1 gstreamer libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_videotestsrc = /usr/lib/gstreamer-0.10/libgstvideotestsrc.so

RDEPENDS_gst_plugins_base_volume= gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib liborc gst_plugins_base
FILES_gst_plugins_base_volume = /usr/lib/gstreamer-0.10/libgstvolume.so

RDEPENDS_gst_plugins_base_vorbis= libogg0 gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libgsttag libc6 libglib libvorbis gst_plugins_base
FILES_gst_plugins_base_vorbis = /usr/lib/gstreamer-0.10/libgstvorbis.so libgstvorbis.so

RDEPENDS_gst_plugins_base = 
FILES_gst_plugins_base = /usr/share/gst-plugins-base/license-translations.dict
call[[ ipkbox ]]

]]package
