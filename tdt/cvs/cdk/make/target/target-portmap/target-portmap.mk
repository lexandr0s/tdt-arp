#
# AR-P buildsystem smart Makefile
#
package[[ target_portmap

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 6.0
PR_${P} = 1

DIR_${P} = ${WORK}/${PN}_${PV}

call[[ base ]]

rule[[
  extract:http://fossies.org/unix/misc/old/${PN}-${PV}.tgz
  patch:file://${PN}_${PV}.diff
  nothing:file://portmap.init
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(MAKE)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install BASEDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = "the program supports access control in the style of the tcp wrapper (log_tcp) packag"
RDEPENDS_${P} = 
FILES_${P} = /sbin/* /etc/init.d/

define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ portmap start 41 S . stop 10 0 6 .
endef

define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ portmap remove
endef

call[[ ipkbox ]]

]]package
