#
# AR-P buildsystem smart Makefile
#
package[[ target_lirc

BDEPENDS_${P} = $(target_glibc)
# FIXME
DEPENDS_${P} = $(target_linux_kernel)

PV_${P} = 0.9.0
PR_${P} = 2

call[[ base ]]

rule[[
  extract:http://prdownloads.sourceforge.net/${PN}/${PN}-${PV}.tar.gz
  patch:file://{PN}-neutrino-uinput-hack.diff
  patch:file://{PN}-try_first_last_remote.diff
  patch:file://{PN}-uinput-repeat-fix.diff
  patch:file://{PN}-repeat_and_delay_hack.patch
  patch:file://{PN}-rename_input_device.patch
  nothing:file://lircd_hl101.conf
  nothing:file://lircd_hl101.conf.03_00_02
  nothing:file://lircd_hl101.conf.03_00_07
  nothing:file://lircd_spark7162.conf
  nothing:file://lircd_spark.conf
  nothing:file://lircd_spark.conf.09_00_07
  nothing:file://lircd_spark.conf.09_00_08
  nothing:file://lircd_spark.conf.09_00_0B
  nothing:file://lircd_spark.conf.09_00_1D
]]rule

CONFIG_FLAGS_${P} = 

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -Os -D__KERNEL_STRICT_NAMES -DUINPUT_NEUTRINO_HACK" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-driver=userspace \
			--enable-sandboxed \
		&& \
		make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)

	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)

	$(INSTALL_DIR) $(PKDIR)/etc
	$(INSTALL_DIR) $(PKDIR)/var/run/lirc/
	$(INSTALL_FILE) ${DIR}/lircd_$(TARGET).conf $(PKDIR)/etc/lircd.conf
ifdef CONFIG_HL101
	$(INSTALL_FILE) ${DIR}/lircd_hl101.conf.03_00_02 $(PKDIR)/etc/lircd.conf.03_00_02
	$(INSTALL_FILE) ${DIR}/lircd_hl101.conf.03_00_07 $(PKDIR)/etc/lircd.conf.03_00_07
endif
ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
	$(INSTALL_FILE) ${DIR}/lircd_spark.conf.09_00_0B $(PKDIR)/etc/lircd.conf.09_00_0B
	$(INSTALL_FILE) ${DIR}/lircd_spark.conf.09_00_07 $(PKDIR)/etc/lircd.conf.09_00_07
	$(INSTALL_FILE) ${DIR}/lircd_spark.conf.09_00_08 $(PKDIR)/etc/lircd.conf.09_00_08
	$(INSTALL_FILE) ${DIR}/lircd_spark.conf.09_00_1D $(PKDIR)/etc/lircd.conf.09_00_1D
endif
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = lirc
FILES_lirc = \
	/usr/bin/lircd \
	/usr/lib/*.so* \
	/etc/lircd* \
	/var/run/lirc/

ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
define conffiles_${P}
/etc/lircd.conf
/etc/lircd.conf.09_00_0B
/etc/lircd.conf.09_00_07
/etc/lircd.conf.09_00_08
/etc/lircd.conf.09_00_1D
endef
else
define conffiles_${P}
/etc/lircd.conf
/etc/lircd.conf.03_00_02
/etc/lircd.conf.03_00_07
endef
endif

call[[ ipkbox ]]

]]package
