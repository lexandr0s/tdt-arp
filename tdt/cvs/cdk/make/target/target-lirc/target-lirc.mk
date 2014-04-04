#
# AR-P buildsystem smart Makefile
#
package[[ target_lirc

BDEPENDS_${P} = $(target_glibc)
# FIXME
DEPENDS_${P} = $(target_linux_kernel)

PV_${P} = 0.9.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://prdownloads.sourceforge.net/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}-try_first_last_remote.diff
]]rule

CONFIG_FLAGS_${P} = 

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -Os -D__KERNEL_STRICT_NAMES" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--mandir=\$${prefix}/share/man \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-devdir=/dev \
			--with-moduledir=/lib/modules \
			--with-major=61 \
			--with-driver=userspace \
			--enable-debug \
			--with-syslog=LOG_DAEMON \
			--enable-sandboxed \
		&& \
		make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)

	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)

	$(INSTALL_DIR) $(PKDIR)/etc
	$(INSTALL_DIR) $(PKDIR)/var/run/lirc/
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_$(TARGET).conf $(PKDIR)/etc/lircd.conf
ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_0B $(PKDIR)/etc/lircd.conf.09_00_0B
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_07 $(PKDIR)/etc/lircd.conf.09_00_07
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_08 $(PKDIR)/etc/lircd.conf.09_00_08
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd_spark.conf.09_00_1D $(PKDIR)/etc/lircd.conf.09_00_1D
endif
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = lirc
FILES_lirc = \
	/usr/bin/lircd \
	/usr/lib/*.so* \
	/etc/lircd*

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
endef
endif

call[[ ipkbox ]]

]]package
