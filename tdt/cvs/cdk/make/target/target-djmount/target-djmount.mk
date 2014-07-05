#
# AR-P buildsystem smart Makefile
#
package[[ target_djmount

BDEPENDS_${P} = $(target_glibc) $(target_fuse) $(target_curl) $(target_libupnp)

PV_${P} = 0.71
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${PN}-${PV}.tar.gz
  nothing:file://djmount-init
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
	&& \
	make all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d
	$(INSTALL_BIN) $(DIR_${P})/djmount-init $(PKDIR)/etc/init.d/djmount
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  mount UPnP server content as a linux filesystem
RDEPENDS_${P} = libfuse2 libc6 libupnp3
FILES_${P} = /usr/bin/* /etc/init.d/djmount

define postinst_${P}
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ djmount start 97 S .
fi
endef

define postrm_${P}
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ djmount remove
fi
endef

define preinst_${P}
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/djmount" ]; then
	/etc/init.d/djmount stop
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-f -r $$D"
	else
		OPT="-f"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ djmount remove
fi
endef

define prerm_${P}
#!/bin/sh
if [ -z "$ $$D" ]; then
	/etc/init.d/djmount stop
fi
endef
call[[ ipkbox ]]

]]package
