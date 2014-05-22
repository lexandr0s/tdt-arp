#
# AR-P buildsystem smart Makefile
#
package[[ target_mediaportal

BDEPENDS_${P} = $(target_python) $(target_enigma2)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://github.com/OpenAR-P/MediaPortal.git
]]rule

call[[ git ]]

CONFIG_FLAGS_${P} = \
	--with-libsdl=no \
	--datadir=/usr/share \
	--libdir=/usr/lib \
	--bindir=/usr/bin \
	--sysconfdir=/etc \
	PY_PATH=$(targetprefix)/usr \
	$(PLATFORM_CPPFLAGS)

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = enigma2-plugin-extensions-mediaportal
DESCRIPTION_${P} = "Enigma2 MediaPortal"
RDEPENDS_${P} = python_core python_json python_xml python_html python_misc python_twisted_core python_twisted_web python_compression python_robotparser python_mechanize librtmp0
FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/MediaPortal

call[[ ipkbox ]]

]]package
