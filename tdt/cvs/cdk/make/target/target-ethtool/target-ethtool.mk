#
# AR-P buildsystem smart Makefile
#
package[[ target_ethtool

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 6
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.openwrt.org/sources/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
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

DESCRIPTION_${P} = ethtool
RDEPENDS_${P} = libc6
FILES_${P} = /usr/sbin/*

call[[ ipkbox ]]

]]package
