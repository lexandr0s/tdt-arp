#
# NEUTRINO
#

package[[ target_neutrino

BDEPENDS_${P} = $(target_libjpeg) $(target_libstb_hal) $(target_libopenthreads) $(target_lua) $(target_curl) $(target_util_linux) $(target_libalsa) $(target_libdvbsipp) $(target_libgif) $(target_libmme_host) $(target_libmmeimage)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Framebuffer-based digital media application


CONFIG_FLAGS_${P} = \
		--enable-silent-rules \
		--enable-freesatepg \
		--with-boxtype=$(TARGET) \
		--enable-giflib \
		--with-tremor \
		--enable-lua \
		--enable-ffmpegdec \
		--enable-maintainer-mode \
		--with-libdir=/usr/lib \
		--bindir=/usr/bin \
		--with-configdir=/var/tuxbox/config \
		--with-gamesdir=/var/tuxbox/games \
		--with-plugindir=/var/plugins \
		--with-stb-hal-includes=$(workprefix)/target_libstb_hal/libstb-hal-git/include \
		--with-stb-hal-build=$(workprefix)/target_libstb_hal/libstb-hal-git \
		$(PLATFORM_CPPFLAGS) \
		CXXFLAGS="$(CXXFLAGS_${P})" \
		CPPFLAGS="$(CPPFLAGS_${P})"

CXXFLAGS_${P} += -Wall -W -Wshadow -fno-strict-aliasing -rdynamic -DNEW_LIBCURL -DCPU_FREQ -DMARTII -funsigned-char
CPPFLAGS_${P} += -I$(driverdir)/bpamem

ifdef CONFIG_SPARK
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

ifdef CONFIG_SPARK7162
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

#ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
#BOXTYPE = spark
#endif

# media framework
ifdef CONFIG_GSTREAMER
BDEPENDS_${P} += $(target_gstreamer)
CONFIG_FLAGS_${P} += --enable-mediafwgstreamer
endif
ifdef CONFIG_EPLAYER3
BDEPENDS_${P} += $(target_libeplayer3)
CONFIG_FLAGS_${P} += --enable-libeplayer3 LIBEPLAYER3_CPPFLAGS="-I$(appsdir)/misc/tools/libeplayer3/include"
RDEPENDS_${P} += libeplayer3
endif

# ???? lcd
ifdef CONFIG_EXTERNALLCD
CONFIG_FLAGS_${P} += --with-graphlcd
endif

call[[ base ]]

rule[[

ifdef CONFIG_NEUTRINO_SRC_MASTER
  git://github.com/OpenAR-P/neutrino-mp.git;b=master
endif

ifdef CONFIG_NEUTRINO_SRC_MARTII
  git://gitorious.org/neutrino-mp/martiis-neutrino-mp.git
endif

]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
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
	$(MAKE) -C $(DIR_${P}) install DESTDIR=$(PKDIR) \

	$(target)-strip $(PKDIR)/usr/bin/neutrino
	$(target)-strip $(PKDIR)/usr/bin/pzapit
	$(target)-strip $(PKDIR)/usr/bin/sectionsdcontrol
	rm -f $(PKDIR)/usr/share/fonts/md_khmurabi_10.ttf
	rm -f $(PKDIR)/usr/share/fonts/tuxtxt.ttf
	rm -f $(PKDIR)/usr/share/fonts/tuxtxt.otb

	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################

PACKAGES_${P} = \
	neutrino \
	neutrino_plugins \
	neutrino_configs \
	font_dejavulgcsansmono_bold \
	font_micron \
	font_micron_bold \
	font_micron_italic \
	font_neutrino \
	font_pakenham


RDEPENDS_neutrino += neutrino-plugins neutrino-configs liblua libssl1 libcrypto1 libcurl4 libid3tag0 libmad0 libvorbisidec1 libpng16 libjpeg8 libgif4 font-md-khmurabi font-tuxtxt font-dejavulgcsansmono-bold font-micron font-micron-bold font-micron-italic font-neutrino font-pakenham libfreetype6 ffmpeg libdvbsi++1 libopenthreads libusb_1.0 libasound2 libstb_hal libc6

FILES_neutrino = /usr/bin/* /usr/sbin/*
FILES_neutrino_plugins = /usr/share/tuxbox /usr/share/iso-codes/*
FILES_neutrino_configs = /var

FILES_font_dejavulgcsansmono_bold = /usr/share/fonts/DejaVuLGCSansMono-Bold.ttf
DESCRIPTION_font_dejavulgcsansmono_bold = ttf fonts

FILES_font_micron = /usr/share/fonts/micron.ttf
DESCRIPTION_font_micron = ttf fonts

FILES_font_micron_bold = /usr/share/fonts/micron_bold.ttf
DESCRIPTION_font_micron_bold = ttf fonts

FILES_font_micron_italic = /usr/share/fonts/micron_italic.ttf
DESCRIPTION_font_micron_italic = ttf fonts

FILES_font_neutrino = /usr/share/fonts/neutrino.ttf
DESCRIPTION_ont_neutrino = ttf fonts

FILES_font_pakenham = /usr/share/fonts/pakenham.ttf
DESCRIPTION_font_pakenham = ttf fonts

call[[ ipkbox ]]

]]package
