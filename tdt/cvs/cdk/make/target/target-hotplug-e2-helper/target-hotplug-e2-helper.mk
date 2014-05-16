#
# AR-P buildsystem smart Makefile
#
package[[ target_hotplug_e2_helper

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://openpli.git.sourceforge.net/gitroot/openpli/hotplug-e2-helper
  patch:file://${PN}-support_fw_upload.patch
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./autogen.sh &&\
		$(BUILDENV) \
		./configure \
			--build=$(build) \
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

DESCRIPTION_${P} = hotplug_e2_helper
RDEPENDS_${P} = libc6
FILES_${P} = /usr/bin/bdpoll /usr/bin/hotplug_e2_helper

call[[ ipkbox ]]

]]package
