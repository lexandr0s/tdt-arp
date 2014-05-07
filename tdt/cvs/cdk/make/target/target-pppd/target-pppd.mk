#
# AR-P buildsystem smart Makefile
#
package[[ target_pppd

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.4.6
PR_${P} = 1

DIR_${P} = ${WORK}/ppp-${PV}

call[[ base ]]

rule[[
  extract:ftp://ftp.samba.org/pub/ppp/ppp-${PV}.tar.gz
  patch:file://${PN}.patch
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
			--target=$(target) \
			--with-kernel=$(buildprefix)/$(KERNEL_DIR) \
			--disable-kernel-module \
			--prefix=/usr \
		&& \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

NAME_${P} = pppd
DESCRIPTION_${P} = package which implements the Point-to-Point Protocol (PPP)
RDEPENDS_${P} = libc6
FILES_${P} = /usr/sbin/* \
	     /usr/lib/*

call[[ ipkbox ]]

]]package