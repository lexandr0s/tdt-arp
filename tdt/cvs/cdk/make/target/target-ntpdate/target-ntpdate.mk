#
# AR-P buildsystem smart Makefile
#
package[[ target_ntpdate

PV_${P} = 4.2.6p5
PR_${P} = 1
DIR_${P} = ${WORK}/ntp-${PV}

call[[ base ]]

rule[[
  http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-${PV}.tar.gz
  patch:file://${PN}.patch
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--bindir=/usr/sbin \
			--with-net-snmp-config=no \
			--without-ntpsnmpd \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
		&& \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
		install -d $(PKDIR)/etc/default/
		install -m644 $(SDIR_${P})/ntpdate $(PKDIR)/etc/default
		install -d $(PKDIR)/usr/bin/
		install -m755 $(SDIR_${P})/ntpdate-sync $(PKDIR)/usr/bin/ntpdate-sync
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Network Time Protocol daemon and utilities
FILES_ntpdate = \
	/usr/sbin/ntpdate \
	/usr/bin/ntpdate-sync \
	/etc/default/ntpdate

call[[ ipkbox ]]

]]package
