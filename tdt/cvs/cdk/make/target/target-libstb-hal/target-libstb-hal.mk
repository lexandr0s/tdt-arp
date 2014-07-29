#
# AR-P buildsystem smart Makefile
#
ifeq ($(strip $(CONFIG_BUILD_NEUTRINO)),y)

package[[ target_libstb_hal

BDEPENDS_${P} = $(target_glibc) $(target_ffmpeg) $(target_libalsa) $(target_libpng)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[

ifdef CONFIG_NEUTRINO_SRC_MASTER
  git://github.com/OpenAR-P/libstb-hal.git 
endif

ifdef CONFIG_NEUTRINO_SRC_MARTII
  git://gitorious.org/neutrino-mp/martiis-libstb-hal.git
endif

]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr \
			--enable-shared \
			--with-target=cdk \
			--with-boxtype=$(TARGET) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(CPPFLAGS_N)" \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(MAKE) -C $(DIR_${P}) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  libstb-hal
RDEPENDS_${P} = ffmpeg libpng16 libasound2

call[[ ipkbox ]]

]]package

endif
