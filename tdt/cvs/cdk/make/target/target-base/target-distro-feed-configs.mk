#
# AR-P buildsystem smart Makefile
#
package[[ target_distro_feed_configs

BDEPENDS_${P} =

PV_${P} = 0.1
PR_${P} = 1
SRC_URI_${P} = Open AR-P 
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Configuration files for online package repositories aka feeds

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/opkg
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P}) \

	echo "src/gz spark-all http://amiko.sat-universum.de" > $(PKDIR)/etc/opkg/all-spark-feed.conf && \
	echo "src/gz non-free-feed http://nonfree.sat-universum.de" > $(PKDIR)/etc/opkg/nonfree-feed.conf

	touch $@

call[[ ipkbox ]]

]]package
