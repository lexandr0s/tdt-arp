#
# AR-P buildsystem smart Makefile
#
package[[ target_distro_feed_configs

BDEPENDS_${P} =

PV_${P} = 0.2
PR_${P} = 1
SRC_URI_${P} = Open AR-P
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Configuration files for online package repositories aka feeds

call[[ base ]]

rule[[
  pdircreate:${DIR}
  install:-d:$(PKDIR)/etc/opkg
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	echo $(CONFIG_FEED_SPARK)$(CONFIG_FEED_SPARK7162)$(CONFIG_FEED_HL101) > $(PKDIR)/etc/opkg/all-spark-feed.conf
	echo $(CONFIG_NONFREE_FEED) > $(PKDIR)/etc/opkg/nonfree-feed.conf

	touch $@

call[[ ipkbox ]]

]]package
