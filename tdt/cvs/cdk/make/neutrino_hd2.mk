#
# NEUTRINO HD
#
#
BEGIN[[
neutrino_hd
  git
  {PN}-nightly

ifdef ENABLE_NHD0
  git://gitorious.org/neutrino-hd/neutrino-hd.git
endif

ifdef ENABLE_NHD1
  #svn://neutrinohd2.googlecode.com/svn/trunk/neutrino-hd
endif

ifdef ENABLE_NHD2
  git://gitorious.org/neutrino-mp/neutrino-mp.git
endif
;
]]END


N_CPPFLAGS = -I$(driverdir)/bpamem

ifdef ENABLE_SPARK
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

ifdef ENABLE_SPARK7162
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom
endif

N_CONFIG_OPTS = --enable-silent-rules --enable-freesatepg

ifdef ENABLE_EXTERNALLCD
N_CONFIG_OPTS += --enable-graphlcd
endif

$(DEPDIR)/neutrino-hd-nightly.do_prepare: $(DEPENDS_neutrino_hd)
	$(PREPARE_neutrino_hd)
	touch $@

$(DIR_neutrino_hd)/config.status: bootstrap freetype $(EXTERNALLCD_DEP) jpeg libpng libgif libid3tag curl libmad libvorbisidec libboost libflac openssl sdparm 
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_neutrino_hd) && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--enable-libeplayer3 \
			--with-boxtype=none \
			--enable-pcmsoftdecoder \
			--with-tremor \
			--enable-libass \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/usr/local/share/config \
			--with-gamesdir=/usr/local/share/games \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"


$(DEPDIR)/neutrino-hd-nightly.do_compile: $(DIR_neutrino_hd)/config.status
	cd $(DIR_neutrino_hd) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-hd-nightly: neutrino-hd-nightly.do_prepare neutrino-hd-nightly.do_compile
	$(MAKE) -C $(DIR_neutrino_hd) install DESTDIR=$(PKDIR) && \
	make $(PKDIR)/var/etc/.version
	$(target)-strip $(PKDIR)/usr/local/bin/neutrino
	$(target)-strip $(PKDIR)/usr/local/bin/pzapit
	$(target)-strip $(PKDIR)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-hd-nightly-clean:
	rm -f $(DEPDIR)/neutrino-hd-nightly
	cd $(DIR_neutrino_hd) && \
		$(MAKE) distclean

neutrino-hd-nightly-distclean:
	rm -f $(DEPDIR)/neutrino-hd-nightly
	rm -f $(DEPDIR)/neutrino-hd-nightly.do_compile
	rm -f $(DEPDIR)/neutrino-hd-nightly.do_prepare
	rm -rf $(DIR_neutrino_hd)