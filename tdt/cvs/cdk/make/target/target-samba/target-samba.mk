#
# AR-P buildsystem smart Makefile
#
package[[ target_samba

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 3.6.24
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.${PN}.org/${PN}/ftp/stable/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

CONFIG_FLAGS_${P} = \
		--includedir=/usr/include \
		--exec-prefix=/usr \
		--disable-pie \
		--disable-avahi \
		--disable-cups \
		--disable-relro \
		--disable-swat \
		--disable-shared-libs \
		--disable-socket-wrapper \
		--disable-nss-wrapper \
		--disable-smbtorture4 \
		--disable-fam \
		--disable-iprint \
		--disable-dnssd \
		--disable-pthreadpool \
		--disable-dmalloc \
		--with-included-iniparser \
		--with-included-popt \
		--with-sendfile-support \
		--without-aio-support \
		--without-cluster-support \
		--without-ads \
		--without-krb5 \
		--without-dnsupdate \
		--without-automount \
		--without-ldap \
		--without-pam \
		--without-pam_smbpass \
		--without-winbind \
		--without-wbclient \
		--without-syslog \
		--without-nisplus-home \
		--without-quotas \
		--without-sys-quotas \
		--without-utmp \
		--without-acl-support \
		--with-configdir=/etc/samba \
		--with-privatedir=/etc/samba \
		--with-mandir=no \
		--with-piddir=/var/run \
		--with-logfilebase=/var/log \
		--with-lockdir=/var/lock \
		--with-swatdir=/usr/share/swat \
		--disable-cups

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P})/source3 && \
		./autogen.sh && \
		$(BUILDENV) \
		libreplace_cv_HAVE_GETADDRINFO=no \
		libreplace_cv_READDIR_NEEDED=no \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P})/source3 && $(MAKE) install DESTDIR=$(PKDIR)

	$(INSTALL) -d $(PKDIR)/etc/samba && \
	$(INSTALL) -c -m644 $(DIR_${P})/examples/smb.conf.spark $(PKDIR)/etc/samba/smb.conf && \
	$(INSTALL) -d $(PKDIR)/etc/init.d && \
	$(INSTALL) -c -m755 $(DIR_${P})/examples/samba.spark $(PKDIR)/etc/init.d/samba
	touch $@

call[[ ipk ]]

PACKAGES_${P} = samba_lib samba

DESCRIPTION_samba = samba
RDEPENDS_samba = libc6 libreadline6
FILES_samba = /usr/sbin/* /etc/init.d/* /etc/samba/smb.conf
define conffiles_samba
	/etc/samba/smb.conf
endef
define postinst_samba
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ samba defaults
endef
define postrm_samba
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ samba remove
endef
define preinst_samba
#!/bin/sh
if [ -z $$OPKG_OFFLINE_ROOT -a -f "/etc/init.d/samba" ]; then
	/etc/init.d/samba stop
fi
update-rc.d -r $$OPKG_OFFLINE_ROOT/ samba remove
endef
define prerm_samba
#!/bin/sh
	/etc/init.d/samba stop
endef

DESCRIPTION_samba_lib = samba_lib
RDEPENDS_samba = libc6
FILES_samba_lib = /usr/lib/*.so.*
define postinst_samba_lib
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
