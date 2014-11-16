#
# CROSS GLIBC
#
package[[ target_glibc_headers

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 2.14.1-48
PR_${P} = 4

ST_PN_${P} = glibc

call[[ base ]]

rule[[
  dirextract:local://$(archivedir)/$(STLINUX)-sh4-${ST_PN}-${PV}.sh4.rpm
  dirextract:local://$(archivedir)/$(STLINUX)-sh4-${ST_PN}-dev-${PV}.sh4.rpm
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	install -d $(PKDIR)/usr/include
	mv $(DIR_${P})/opt/STM/STLinux-2.4/devkit/sh4/target/usr/include/* $(PKDIR)/usr/include/
	touch $@

call[[ ipk ]]

]]package