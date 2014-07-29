#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugins_dvbmediasink

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib) $(target_driver) $(target_gstreamer) $(target_gst_plugins_base) $(target_gst_plugins_good) $(target_gst_plugins_bad) $(target_gst_plugins_ugly) $(target_gst_plugin_subsink)

PV_${P} = git
PR_${P} = 1

SRC_URI_${P} = http://gitorious.org/~schpuntik/open-duckbox-project-sh4/tdt-amiko

call[[ base ]]

GIT_DIR_${P} = $(appsdir)/misc/tools/gst-plugins-dvbmediasink

rule[[
  pdircreate:${DIR}
  plndir:$(GIT_DIR_${P}):${DIR}
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize -f -c && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = GStreamer Multimedia Framework dvbmediasink
RDEPENDS_${P} = gstreamer libgstpbutils libgstaudio libxml2 libz1 libgstinterfaces libffi6 libc6 libglib kernel_module_player2 kernel_module_stgfb
FILES_${P} = /usr/lib/gstreamer-0.10/*.s*

call[[ ipkbox ]]

]]package
