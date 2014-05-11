#
# AR-P buildsystem smart Makefile
#
package[[ target_wireless_tools

BDEPENDS_${P} = $(target_glibc) $(target_wpa_supplicant)

PV_${P} = 29
PR_${P} = 1

DIR_${P} = ${WORK}/wireless_tools.${PV}

call[[ base ]]

rule[[
  extract:http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install PREFIX=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  Tools for the Linux Standard Wireless Extension Subsystem
RDEPENDS_${P} = rfkill wpa-supplicant
FILES_${P} = /usr/lib/*.so* /usr/sbin/*

call[[ ipkbox ]]

]]package
