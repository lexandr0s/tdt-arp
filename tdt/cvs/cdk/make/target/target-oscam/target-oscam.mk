#
# AR-P buildsystem smart Makefile
#
package[[ target_oscam

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = svn
PR_${P} = 1

call[[ base ]]

rule[[
  svn://www.oscam.cc/svn/oscam-mirror/trunk/
]]rule

call[[ svn ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(MAKE) CROSS=$(crossprefix)/bin/$(target)-  CONF_DIR=/var/keys
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		$(INSTALL_DIR) $(PKDIR)/usr/bin/cam && \
		$(INSTALL_BIN) Distribution/oscam*-sh4-linux $(PKDIR)/usr/bin/cam/oscam
		
	touch $@
	
NAME_${P} = enigma2-plugin-cams-oscam
DESCRIPTION_${P} = Open Source Conditional Access Module software
RDEPENDS_${P} = libssl1 libcrypto1
FILES_${P} = /usr/bin/cam/oscam

call[[ ipkbox ]]

]]package
