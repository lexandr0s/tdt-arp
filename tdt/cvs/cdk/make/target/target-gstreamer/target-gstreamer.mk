#
# AR-P buildsystem smart Makefile
#
package[[ target_gstreamer

BDEPENDS_${P} = $(target_glibc) $(target_glib2) $(target_libxml2) $(target_libbluray)

ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://anongit.freedesktop.org/gstreamer/gstreamer;b=0.10;r=1bcabb9
  patch:file://check_fix.patch
  #patch:file://gst-inspect-check-error.patch 
  #patch:file://multiqueue-sparsestreams.patch
]]rule

call[[ git ]]

else

PV_${P} = 0.10.36
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.bz2
  patch:file://check_fix.patch
]]rule

endif

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)
	cd $(DIR_${P})/common && \
	git submodule init && \
	git submodule update
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
		--disable-dependency-tracking \
		--disable-check \
		--disable-gst-debug \
		--disable-debug \
		--enable-introspection=no \
		ac_cv_func_register_printf_function=no \
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
RDEPENDS_${P} = libglib libxml2 libffi6 libz1 libc6 libbluray
FILES_${P} = \
/usr/bin/gst-* \
/usr/lib/libgstbase*.so.* \
/usr/lib/libgstcheck*.so.* \
/usr/lib/libgstcontroller*.so.* \
/usr/lib/libgstdataprotocol*.so.* \
/usr/lib/libgstnet*.so.* \
/usr/lib/libgstreamer*.so.* \
/usr/lib/gstreamer/gstreamer-0.10/gst-plugin-scanner \
/usr/lib/gstreamer-0.10/libgstcoreelements.so \
/usr/lib/gstreamer-0.10/libgstcoreindexers.so
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
