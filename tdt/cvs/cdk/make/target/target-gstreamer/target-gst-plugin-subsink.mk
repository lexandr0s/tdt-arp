#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugin_subsink

BDEPENDS_${P} = $(target_glibc) $(target_gstreamer) $(target_gst_plugins_base)

ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://git.code.sf.net/p/openpli/gstsubsink.git;r=0cb20d6024
]]rule

call[[ git ]]

else

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://openpli.git.sourceforge.net/gitroot/openpli/gstsubsink:r=8182abe751364f6eb1ed45377b0625102aeb68d5
]]rule

call[[ git ]]

endif

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
	touch NEWS README AUTHORS ChangeLog && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
	autoheader && \
	autoconf && \
	automake --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--build=$(build) \
		--prefix=/usr \
		--enable-orc \
	&& \
	$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = GStreamer subsink plugin
RDEPENDS_${P} = libglib libxml2 libffi6 libz1 libc6 gstreamer
FILES_${P} = /usr/lib/gstreamer-0.10/libgstsubsink.so
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
