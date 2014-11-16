#
# AR-P buildsystem smart Makefile
#
package[[ target_image

DEPENDS_${P} = $(target_rootfs)

PV_${P} = 0.1
PR_${P} = 1

call[[ base ]]

$(TARGET_${P}).do_image: $(DEPENDS_${P})
	@echo "Create image ..."
ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
	cd $(prefix)/../flash/spark && \
		echo -e "1\n1" | ./spark.sh
endif
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_image

]]package
