#
# XBMC
#
ifeq ($(strip $(CONFIG_BUILD_XBMC)),y)
package[[ target_xbmc

BDEPENDS_${P} = $(target_boost) $(target_libass) $(target_libmpeg2) $(target_python) $(target_python_twisted) $(target_libmodplug) $(target_taglib) $(target_libstgles) $(target_libnfs) $(target_libmicrohttpd) $(target_tinyxml) $(target_gstreamer) $(target_libjpeg) $(target_curl) $(target_util_linux) $(target_libalsa) $(target_libdvbsipp) $(target_libgif) $(target_libmme_host) $(target_libmmeimage)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Framebuffer-based digital media application


CONFIG_FLAGS_${P} = \
			SWIG_EXE=none \
			JRE_EXE=none \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--enable-webserver \
			--enable-nfs \
			--disable-x11 \
			--disable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
			--disable-afpclient \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-hal \
			--disable-avahi \
			--disable-optical-drive \
			--disable-libbluray \
			--disable-texturepacker \
			--disable-libcec \
			--enable-gstreamer \
			--disable-paplayer \
			--enable-gstplayer \
			--enable-dvdplayer \
			--disable-pulse \
			--disable-alsa \
			--disable-ssh \
			use_texturepacker_native=yes \
			USE_TEXTUREPACKER_NATIVE_ROOT=-I$(targetprefix)/usr \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python$(PYTHON_VERSION) \
			PY_PATH=$(targetprefix)/usr \

ifdef CONFIG_SPARK
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

ifdef CONFIG_SPARK7162
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

call[[ base ]]

rule[[

ifdef CONFIG_XBMC0
  git://github.com/xbmc/xbmc.git:r=12.2-Frodo
  patch:file://xbmc-nightly.0.diff
  patch:file://xbmc-texture.patch
endif

ifdef CONFIG_XBMC1
  git://github.com/xbmc/xbmc.git:r=460e79416c5cb13010456794f36f89d49d25da75
  patch:file://xbmc-nightly.1.diff
endif

]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(MAKE) -C $(DIR_${P}) install DESTDIR=$(PKDIR)
	if [ -e $(PKDIR)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(PKDIR)/usr/lib/xbmc/xbmc.bin; \
	fi

	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################
PACKAGES_${P} = xbmc_core xbmc_addons xbmc_language
DESCRIPTION_${P} = xbmc
#BDEPENDS_${P} = libstgles \
			libmad \
			libsamplerate \
			libogg \
			libvorbis \
			libmodplug \
			curl \
			libflac \
			bzip2 \
			tiff \
			lzo \
			libz \
			fontconfig \
			libfribidi \
			freetype \
			jasper \
			sqlite \
			libpng \
			libpcre \
			libcdio \
			yajl \
			libmicrohttpd \
			tinyxml \
			python \
			gstreamer \
			gst_plugins_dvbmediasink \
			expat \
			sdparm \
			lirc \
			libnfs \
			driver-ptinp \
			taglib \
			directfb \
			tvheadend
PKGR_xbmc =r1
SRC_URI_xbmc = git://github.com/xbmc/xbmc.git
DESCRIPTION_xbmc_core = "xbmc core"

FILES_xbmc_core = /usr/bin/xbmc \
		/usr/lib/xbmc/* \
		/usr/share/icons/* \
		/usr/share/xbmc/media/* \
		/usr/share/xbmc/sounds/* \
		/usr/share/xbmc/system/* \
		/usr/share/xbmc/userdata/* \
		/usr/share/xbmc/FEH.py

DESCRIPTION_xbmc_addons = "xbmc addons"
FILES_xbmc_addons = \
		/usr/share/xbmc/addons/library.xbmc.gui/* \
		/usr/share/xbmc/addons/library.xbmc.pvr/* \
		/usr/share/xbmc/addons/library.xbmc.addon/* \
		/usr/share/xbmc/addons/repository.xbmc.org/* \
		/usr/share/xbmc/addons/xbmc.metadata/* \
		/usr/share/xbmc/addons/xbmc.addon/* \
		/usr/share/xbmc/addons/xbmc.core/* \
		/usr/share/xbmc/addons/xbmc.gui/* \
		/usr/share/xbmc/addons/xbmc.json/* \
		/usr/share/xbmc/addons/xbmc.pvr/* \
		/usr/share/xbmc/addons/webinterface.default/* \
		/usr/share/xbmc/addons/skin.confluence/*

DESCRIPTION_xbmc_language = "xbmc language files"
FILES_xbmc_language = \
		/usr/share/xbmc/language/Russian/* \
		/usr/share/xbmc/language/English/* \
		/usr/share/xbmc/language/German/*

call[[ ipkbox ]]

]]package
endif
