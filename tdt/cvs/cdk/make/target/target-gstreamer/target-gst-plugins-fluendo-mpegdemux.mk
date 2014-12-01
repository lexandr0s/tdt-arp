#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_fluendo_mpegdemux

BDEPENDS_${P} = $(target_glibc) $(target_gstreamer) $(target_gst_plugins_base)

PV_${P} = 0.10.85
PR_${P} = 1

PN_${P} = gst-fluendo-mpegdemux

call[[ base ]]

rule[[
  extract:http://core.fluendo.com/gstreamer/src/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}-0.10.69-add_dts_hd_detection.diff
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--build=$(build) \
		--prefix=/usr \
		--with-check=no \
	&& \
	$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =GStreamer Multimedia Framework fluendo
RDEPENDS_${P} = libglib libc6 gstreamer
FILES_${P} = /usr/lib/gstreamer-0.10/libgstflumpegdemux.so
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
