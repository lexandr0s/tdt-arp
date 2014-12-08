#
# AR-P buildsystem smart Makefile
#
package[[ target_mediaportal

BDEPENDS_${P} = $(target_python) $(target_python_mechanize)

PV_${P} = 5.4.0
PR_${P} = 2

call[[ base ]]

rule[[
  nothing:git://github.com/OpenAR-P/MediaPortal.git
]]rule

call[[ git ]]

CONFIG_FLAGS_${P} = \
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
		$(BUILDENV) \
		./autogen.sh && \
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
ifeq ($(strip $(CONFIG_GSTREAMER)),y)
RDEPENDS_${P} = python_json python_pyopenssl python_xml python_html python_misc python_twisted_core python_twisted_web python_compression python_robotparser python_mechanize gst_plugins_good_flv gst_plugins_bad_fragmented gst_plugins_bad_rtmp
else
RDEPENDS_${P} = python_core python_json python_xml python_html python_misc python_twisted_core python_twisted_web python_compression python_robotparser python_mechanize librtmp1
endif
FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/MediaPortal

call[[ ipkbox ]]

]]package
