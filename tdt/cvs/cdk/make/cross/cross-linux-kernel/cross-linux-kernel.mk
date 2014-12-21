#
# HOST-KERNEL-SOURCE
#
package[[ cross_kernel

BDEPENDS_${P} = $(cross_filesystem)

PR_${P} = 2
ifdef CONFIG_GIT_KERNEL_ARP
PV_${P} = $(KERNEL_VERSION)
endif

${P}_patches = \
	linux-sh4-linuxdvb_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-sound_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-time_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-init_mm_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-copro_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-strcpy_stm24_$(KERNEL_LABEL).patch \
	linux-squashfs-lzma_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-ext23_as_ext4_stm24_$(KERNEL_LABEL).patch \
	bpa2_procfs_stm24_$(KERNEL_LABEL).patch \
	linux-ftdi_sio.c_stm24_$(KERNEL_LABEL).patch \
	linux-sh4-lzma-fix_stm24_$(KERNEL_LABEL).patch

ifeq ($(CONFIG_KERNEL_0211),y)
${P}_patches += linux-tune_stm24.patch
endif

ifeq ($(CONFIG_KERNEL_0215)$(CONFIG_KERNEL_0217),y)
${P}_patches += linux-tune_stm24_$(KERNEL_LABEL).patch
${P}_patches += linux-sh4-ratelimit-bug_stm24_$(KERNEL_LABEL).patch
endif

ifeq ($(CONFIG_KERNEL_0211)$(CONFIG_KERNEL_0215)$(CONFIG_KERNEL_0217),y)
${P}_patches += linux-sh4-mmap_stm24.patch
endif

ifeq ($(CONFIG_KERNEL_0211)$(CONFIG_KERNEL_0215)$(CONFIG_KERNEL_0217),y)
${P}_patches += linux-sh4-directfb_stm24_$(KERNEL_LABEL).patch
endif

${P}_patches += patch_swap_notify_core_support.diff

ifdef CONFIG_DEBUG_ARP
DEBUG_STR=.debug
else
DEBUG_STR=
endif

${P}_config = linux-sh4-$(KERNEL_UPSTREAM)-$(KERNEL_LABEL)_$(TARGET).config$(DEBUG_STR)



ifdef CONFIG_GIT_KERNEL_ARP
DEPENDS_${P} += $(addprefix ${SDIR}/,$(${P}_patches) $(${P}_config))

call[[ base ]]

rule[[
ifdef CONFIG_KERNEL_0211
  git://git.stlinux.com/stm/linux-sh4-2.6.32.y.git;b=stmicro;r=3bce06ff873fb5098c8cd21f1d0e8d62c00a4903
endif
ifdef CONFIG_KERNEL_0215
  git://git.stlinux.com/stm/linux-sh4-2.6.32.y.git;b=stmicro;r=5384bd391266210e72b2ca34590bd9f543cdb5a3
endif
ifdef CONFIG_KERNEL_0217
  git://git.stlinux.com/stm/linux-sh4-2.6.32.y.git;b=stmicro;r=b43f8252e9f72e5b205c8d622db3ac97736351fc
endif
]]rule

call[[ git ]]
call[[ ipk ]]
else
${P}_VERSION := $(KERNEL_VERSION)
${P}_SPEC = stm-host-kernel-sh4.spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-host-kernel-source-sh4-$(KERNEL_VERSION)-$(KERNEL_RELEASE).src.rpm

DEPENDS_${P} += $(addprefix ${SDIR}/,$(${P}_patches) $(${P}_config))

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm_do_compile ]]
endif

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile $(DEPENDS_${P})
	$(PREPARE_${P})
	mkdir $(DIR_${P})
# FIXME:
	cp -r $(prefix)/BUILDROOT/*/$(kernelprefix)/*/* $(DIR_${P})

# 	rm -rf $(KERNEL_DIR)
# 	rm -rf linux{,-sh4}
# 	rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^)

	cd $(DIR_${P}) && cat $(addprefix ${SDIR}/,$(${P}_patches)) | patch -p1
	cp ${SDIR}/$(${P}_config) $(DIR_${P})/.config
	rm $(DIR_${P})/localversion*
	echo "_$(KERNEL_STM)_$(KERNEL_LABEL)" > $(DIR_${P})/localversion-stm
# 	if [ `grep -c "CONFIG_BPA2_DIRECTFBOPTIMIZED" $(KERNEL_DIR)/.config` -eq 0 ]; then echo "# CONFIG_BPA2_DIRECTFBOPTIMIZED is not set" >> $(KERNEL_DIR)/.config; fi

	cd $(DIR_${P}) && $(MAKE) ARCH=sh oldconfig
	cd $(DIR_${P}) && $(MAKE) ARCH=sh include/asm
	cd $(DIR_${P}) && $(MAKE) ARCH=sh include/linux/version.h
	rm $(DIR_${P})/.config
	
	install -d $(PKDIR)/$(crossprefix)/sources/kernel
	mv $(DIR_${P})/* $(PKDIR)/$(crossprefix)/sources/kernel

	touch $@

#
# KERNEL-HEADERS
#
# $(DEPDIR)/kernel-headers: linux-kernel.do_prepare
# 	cd $(KERNEL_DIR) && \
# 		$(INSTALL) -d $(targetprefix)/usr/include && \
# 		cp -a include/linux $(targetprefix)/usr/include && \
# 		cp -a include/asm-sh $(targetprefix)/usr/include/asm && \
# 		cp -a include/asm-generic $(targetprefix)/usr/include && \
# 		cp -a include/mtd $(targetprefix)/usr/include
# 	touch $@

]]package