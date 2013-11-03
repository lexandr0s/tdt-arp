# tuxbox/xbmc
BEGIN[[
xbmc
  git
  {PN}-nightly
ifdef ENABLE_XBD0
  git://github.com/xbmc/xbmc.git:r=12.2-Frodo
  patch:file://xbmc-nightly.0.diff
  patch:file://xbmc-texture.patch
endif

ifdef ENABLE_XBD1
  git://github.com/xbmc/xbmc.git:r=460e79416c5cb13010456794f36f89d49d25da75
  patch:file://xbmc-nightly.1.diff
endif

;
]]END

DESCRIPTION_xbmc = xbmc
BDEPENDS_xbmc = libstgles \
			libass \
			libmpeg2 \
			libmad \
			libjpeg \
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
PACKAGES_xbmc = xbmc_core xbmc_addons xbmc_language
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

$(DEPDIR)/xbmc-nightly.do_prepare: bootstrap libboost $(DEPENDS_xbmc)
	$(PREPARE_xbmc)
	touch $@

$(DIR_xbmc)/config.status: $(DEPDIR)/xbmc-nightly.do_prepare
	cd $(DIR_xbmc) && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			SWIG_EXE=none \
			JRE_EXE=none \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--disable-sdl \
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
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python$(PYTHON_VERSION) \
			PY_PATH=$(targetprefix)/usr 

$(DEPDIR)/xbmc-nightly.do_compile: $(DIR_xbmc)/config.status
	cd $(DIR_xbmc) && \
		$(MAKE) all
	touch $@


$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(call parent_pk,xbmc)
	$(start_build)
	$(get_git_version)
	$(MAKE) -C $(DIR_xbmc) install DESTDIR=$(PKDIR)
	if [ -e $(PKDIR)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(PKDIR)/usr/lib/xbmc/xbmc.bin; \
	fi
	$(tocdk_build)
	$(toflash_build)
	touch $@

xbmc-nightly-clean:
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	cd $(DIR_xbmc) && $(MAKE) clean
	
xbmc-nightly-distclean:
	rm -f $(DEPDIR)/xbmc-nightly
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	rm -f $(DEPDIR)/xbmc-nightly.do_prepare
	rm -rf $(DIR_xbmc)

#
# TVHEADEND
#
BEGIN[[
tvheadend
  git
  {PN}-{PV}
  nothing:git://github.com/tvheadend/tvheadend.git
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_tvheadend = "tvheadend"
SRC_URI_tvheadend = "https://tvheadend.org/"
#BDEPENDS_tvheadend = xbmc
PKGR_tvheadend =r1
FILES_tvheadend = \
	/usr/bin/tvheadend \
	/usr/share/tvheadend/*

FILES_tvheadend_init = \


$(DEPDIR)/tvheadend.do_prepare: bootstrap directfb $(DEPENDS_tvheadend)
	$(PREPARE_tvheadend)
	touch $@

$(DEPDIR)/tvheadend.do_compile: $(DEPDIR)/tvheadend.do_prepare
	cd $(DIR_tvheadend) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--enable-bundle \
		--platform=linux \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/tvheadend: $(DEPDIR)/tvheadend.do_compile
	$(start_build)
	cd $(DIR_tvheadend) && \
		$(INSTALL_tvheadend)
	$(tocdk_build)
	$(toflash_build)
	touch $@
