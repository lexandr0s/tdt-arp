#
# AR-P buildsystem smart Makefile
#
package[[ target_bootelf

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = firmware non public

call[[ base ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P})
	$(PKDIR_clean)

	$(INSTALL_DIR) $(PKDIR)/lib/firmware/
	$(INSTALL_DIR) $(PKDIR)/boot/
ifdef CONFIG_SPARK
	$(INSTALL_FILE) $(archivedir)/boot/video_7111.elf $(PKDIR)/boot/video.elf
	$(INSTALL_FILE) $(archivedir)/boot/audio_7111.elf $(PKDIR)/boot/audio.elf
endif
ifdef CONFIG_SPARK7162
	$(INSTALL_FILE) $(archivedir)/boot/video_7111.elf $(PKDIR)/boot/video.elf
	$(INSTALL_FILE) $(archivedir)/boot/audio_7111.elf $(PKDIR)/boot/audio.elf
endif
ifdef CONFIG_HL101
	$(INSTALL_FILE) $(archivedir)/boot/video_7109.elf $(PKDIR)/boot/video.elf
	$(INSTALL_FILE) $(archivedir)/boot/audio_7109.elf $(PKDIR)/boot/audio.elf
endif
	ln -sf /boot/video.elf $(PKDIR)/lib/firmware/video.elf
	ln -sf /boot/audio.elf $(PKDIR)/lib/firmware/audio.elf

	touch $@

NAME_${P} = boot-elf
SRC_URI_${P} = unknown

call[[ ipkbox ]]

]]package
