#
# AR-P buildsystem smart Makefile
#
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
		$(BUILDENV) \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr \
			--enable-shared \
			--with-target=cdk \
			--with-boxtype=$(TARGET) \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(CPPFLAGS_target_neutrino)" \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  libstb-hal
RDEPENDS_${P} = ffmpeg libpng16 libalsa

call[[ ipkbox ]]

]]package
