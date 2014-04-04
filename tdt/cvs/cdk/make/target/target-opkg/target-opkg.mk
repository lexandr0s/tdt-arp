#
# AR-P buildsystem smart Makefile
#
package[[ target_opkg

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 0.2.0
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

call[[ base ]]

rule[[
  extract:http://${PN}.googlecode.com/files/${PN}-${PV}.tar.gz
]]rule

CONFIG_FLAGS_${P} = \
	--enable-maintainer-mode \
	--disable-curl \
	--disable-gpg \
	--with-opkglibdir=/usr/lib


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)

	$(INSTALL_DIR) $(PKDIR)/etc/opkg
	( echo "arch all 1" ; \
	  echo "arch sh4 10"; \
	  echo "arch $(box_arch) 16"; \
	) >> $(PKDIR)/etc/opkg/opkg.conf
	ln -sf opkg-cl $(PKDIR)/usr/bin/opkg
	ln -sf opkg-cl $(PKDIR)/usr/bin/ipkg-cl
	ln -sf opkg-cl $(PKDIR)/usr/bin/ipkg
	
	touch $@

NAME_${P} = ${PN}
DESCRIPTION_${P} = lightweight package management system
FILES_${P} = \
	/etc/opkg \
	/usr/bin \
	/usr/lib

call[[ ipkbox ]]


]]package