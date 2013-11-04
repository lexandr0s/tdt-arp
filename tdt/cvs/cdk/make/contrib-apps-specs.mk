#
# CONSOLE_DATA
#
BEGIN[[
console_data
  1.03
  {PN}-{PV}
  extract:ftp://ftp.debian.org/debian/pool/main/c/{PN}/{PN}_{PV}.orig.tar.gz
  make:install
;
]]END

$(DEPDIR)/console_data: bootstrap $(DEPENDS_console_data)
	$(PREPARE_console_data)
	cd $(DIR_console_data) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(targetprefix) \
			--with-main_compressor=gzip && \
		$(INSTALL_console_data)
#	@CLEANUP_console_data@
	touch $@

#
# SYSVINIT/INITSCRIPTS
#
BEGIN[[
sysvinit
  2.86
  {PN}-{PV}
  extract:ftp://ftp.cistron.nl/pub/people/miquels/{PN}/{PN}-{PV}.tar.gz
  nothing:http://ftp.de.debian.org/debian/pool/main/s/{PN}/{PN}_{PV}.ds1-38.diff.gz
;
]]END

SYSVINIT := sysvinit
INITSCRIPTS := initscripts
FILES_sysvinit = \
/sbin/fsck.nfs \
/sbin/killall5 \
/sbin/init \
/sbin/halt \
/sbin/poweroff \
/sbin/shutdown \
/sbin/reboot

SYSVINIT_VERSION := 2.86-15
SYSVINIT_SPEC := stm-target-$(SYSVINIT).spec
SYSVINIT_SPEC_PATCH :=
SYSVINIT_PATCHES :=
SYSVINIT_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm
INITSCRIPTS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(SYSVINIT_VERSION).sh4.rpm

$(SYSVINIT_RPM) $(INITSCRIPTS_RPM): \
		$(if $(SYSVINIT_SPEC_PATCH),Patches/$(SYSVINIT_SPEC_PATCH)) \
		$(if $(SYSVINIT_PATCHES),$(SYSVINIT_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(SYSVINIT)-$(SYSVINIT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SYSVINIT_SPEC_PATCH),( cd SPECS && patch -p1 $(SYSVINIT_SPEC) < $(buildprefix)/Patches/$(SYSVINIT_SPEC_PATCH) ) &&) \
	$(if $(SYSVINIT_PATCHES),cp $(SYSVINIT_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(SYSVINIT_SPEC)

$(DEPDIR)/$(SYSVINIT): \
$(DEPDIR)/%$(SYSVINIT): $(SYSVINIT_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@

$(DEPDIR)/$(INITSCRIPTS): \
$(DEPDIR)/%$(INITSCRIPTS): $(INITSCRIPTS_RPM) | $(DEPDIR)/%filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@
	

#
# NETBASE
#
NETBASE := netbase
NETBASE_VERSION := 4.34-9
NETBASE_SPEC := stm-target-$(NETBASE).spec
NETBASE_SPEC_PATCHES :=
NETBASE_PATCHES :=
NETBASE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm

$(NETBASE_RPM): \
		$(if $(NETBASE_SPEC_PATCH),Patches/$(NETBASE_SPEC_PATCH)) \
		$(if $(NETBASE_PATCHES),$(NETBASE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(NETBASE)-$(NETBASE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	$(if $(NETBASE_SPEC_PATCH),( cd SPECS && patch -p1 $(NETBASE_SPEC) < $(buildprefix)/Patches/$(NETBASE_PATCH) ) &&) \
	$(if $(NETBASE_PATCHES),cp $(NETBASE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NETBASE).spec

$(DEPDIR)/$(NETBASE): \
$(DEPDIR)/%$(NETBASE): $(NETBASE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@
	

#
# BC
#
BC := bc
BC_VERSION := 1.06-6
BC_SPEC := stm-target-$(BC).spec
BC_SPEC_PATCH :=
BC_PATCHES :=
BC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm

$(BC_RPM): \
		$(if $(BC_SPEC_PATCH),Patches/$(BC_SPEC_PATCH)) \
		$(if $(BC_PATCHES),$(BC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BC)-$(BC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BC_SPEC_PATCH),( cd SPECS && patch -p1 $(BC_SPEC) < $(buildprefix)/Patches/$(BC_PATCH) ) &&) \
	$(if $(BC_PATCHES),cp $(BC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BC_SPEC)

$(DEPDIR)/$(BC): \
$(DEPDIR)/%$(BC): $(BC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@
	

#
# FINDUTILS
#
FINDUTILS := findutils
FINDUTILS_VERSION := 4.1.20-13
FINDUTILS_SPEC := stm-target-$(FINDUTILS).spec
FINDUTILS_SPEC_PATCH :=
FINDUTILS_PATCHES := 
FINDUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm

$(FINDUTILS_RPM): \
		$(if $(FINDUTILS_SPEC_PATCH),Patches/$(FINDUTILS_SPEC_PATCH)) \
		$(if $(FINDUTILS_PATCHES),$(FINDUTILS_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(FINDUTILS)-$(FINDUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(FINDUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(FINDUTILS_SPEC) < $(buildprefix)/Patches/$(FINDUTILS_PATCH) ) &&) \
	$(if $(FINDUTILS_PATCHES),cp $(FINDUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(FINDUTILS_SPEC)

$(DEPDIR)/$(FINDUTILS): $(DEPDIR)/%$(FINDUTILS): $(FINDUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $<
	touch $@
	

#
# DISTRIBUTIONUTILS
#
DISTRIBUTIONUTILS := distributionutils
DESCRIPTION_distributionutils = utilities to setup system
FILES_distributionutils = /usr/sbin/initdconfig
DISTRIBUTIONUTILS_DOC := distributionutils-doc
DISTRIBUTIONUTILS_VERSION := 3.2.1-10
DISTRIBUTIONUTILS_SPEC := stm-target-$(DISTRIBUTIONUTILS).spec
DISTRIBUTIONUTILS_SPEC_PATCH :=
DISTRIBUTIONUTILS_PATCHES :=
DISTRIBUTIONUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm
DISTRIBUTIONUTILS_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS_DOC)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm


$(DISTRIBUTIONUTILS_RPM) $(DISTRIBUTIONUTILS_DOC_RPM): \
		$(if $(DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(DISTRIBUTIONUTILS_PATCHES),$(DISTRIBUTIONUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(DISTRIBUTIONUTILS_SPEC) < $(buildprefix)/Patches/$(DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(DISTRIBUTIONUTILS_PATCHES),cp $(DISTRIBUTIONUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(DISTRIBUTIONUTILS_SPEC)

$(DEPDIR)/$(DISTRIBUTIONUTILS): \
$(DEPDIR)/%$(DISTRIBUTIONUTILS): $(DISTRIBUTIONUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@

$(DEPDIR)/$(DISTRIBUTIONUTILS_DOC): \
$(DEPDIR)/%$(DISTRIBUTIONUTILS_DOC): $(DISTRIBUTIONUTILS_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@

#
# HOST-MTD-UTILS
#
MTD_UTILS := mtd-utils
MTD_UTILS_VERSION := TODO
MTD_UTILS_SPEC := stm-target-$(MTD_UTILS).spec
MTD_UTILS_SPEC_PATCH :=
MTD_UTILS_PATCHES :=
MTD_UTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MTD_UTILS)-$(MTD_UTILS_VERSION).sh4.rpm

$(MTD_UTILS_RPM): \
		$(if $(MTD_UTILS_SPEC_PATCH),Patches/$(MTD_UTILS_SPEC_PATCH)) \
		$(if $(MTD_UTILS_PATCHES),$(MTD_UTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(MTD_UTILS)-$(MTD_UTILS_VERSION).src.rpm libz
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MTD_UTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(MTD_UTILS_SPEC) < $(buildprefix)/Patches/$(MTD_UTILS_PATCH) ) &&) \
	$(if $(MTD_UTILS_PATCHES),cp $(MTD_UTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(MTD_UTILS_SPEC)

$(DEPDIR)/$(MTD_UTILS): \
$(DEPDIR)/%$(MTD_UTILS): $(MTD_UTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	touch $@
	

#
# BASH
#
BASH := bash
BASH_VERSION := 3.0-16
BASH_SPEC := stm-target-$(BASH).spec
BASH_SPEC_PATCH :=
BASH_PATCHES :=
BASH_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASH)-$(BASH_VERSION).sh4.rpm

$(BASH_RPM): \
		$(if $(BASH_SPEC_PATCH),Patches/$(BASH_SPEC_PATCH)) \
		$(if $(BASH_PATCHES),$(BASH_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(DEPDIR)/$(LIBTERMCAP_DEV) \
		$(archivedir)/$(STLINUX)-target-$(BASH)-$(BASH_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASH_SPEC_PATCH),( cd SPECS && patch -p1 $(BASH_SPEC) < $(buildprefix)/Patches/$(BASH_PATCH) ) &&) \
	$(if $(BASH_PATCHES),cp $(BASH_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BASH_SPEC)

$(DEPDIR)/$(BASH): $(DEPDIR)/%$(BASH): $(DEPDIR)/%$(GLIBC) $(DEPDIR)/%$(LIBTERMCAP) $(BASH_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts --force -Uhvv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

$(BASH).do_clean: %$(BASH).do_clean:
	export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && \
	$(hostprefix)/bin/target-shellconfig --list || true && \
	( $(hostprefix)/bin/target-shellconfig --del /bin/bash ) &> /dev/null || echo "Unable to unregister shell" && \
	$(hostprefix)/bin/target-shellconfig --list && \
	rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) -ev --noscripts $(STLINUX)-sh4-$(BASH) || true && \
	[ "x$*" = "x" ] && [ -f .deps/$(subst -clean,,$@) ] && rm .deps/$(subst -clean,,$@) || true

#
# COREUTILS
#
COREUTILS := coreutils
COREUTILS_VERSION := 8.9-19
COREUTILS_SPEC := stm-target-$(COREUTILS).spec 
COREUTILS_SPEC_PATCH :=
COREUTILS_PATCHES := 
COREUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(COREUTILS)-$(COREUTILS_VERSION).sh4.rpm

$(COREUTILS_RPM): \
		$(if $(COREUTILS_SPEC_PATCH),Patches/$(COREUTILS_SPEC_PATCH)) \
		$(if $(COREUTILS_PATCHES),$(COREUTILS_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(COREUTILS)-$(COREUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(COREUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(COREUTILS_SPEC) < $(buildprefix)/Patches/$(COREUTILS_PATCH) ) &&) \
	$(if $(COREUTILS_PATCHES),cp $(COREUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(COREUTILS_SPEC)

$(DEPDIR)/$(COREUTILS): $(DEPDIR)/%$(COREUTILS): $(DEPDIR)/%$(GLIBC) $(COREUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

#
# NET-TOOLS
#
NET_TOOLS := net-tools
NET_TOOLS_VERSION := 1.60-9
NET_TOOLS_SPEC := stm-target-$(NET_TOOLS).spec
NET_TOOLS_SPEC_PATCH :=
NET_TOOLS_PATCHES :=
NET_TOOLS_RPM = RPMS/sh4/$(STLINUX)-sh4-$(NET_TOOLS)-$(NET_TOOLS_VERSION).sh4.rpm

$(NET_TOOLS_RPM): \
		$(if $(NET_TOOLS_SPEC_PATCH),Patches/$(NET_TOOLS_SPEC_PATCH)) \
		$(if $(NET_TOOLS_PATCHES),$(NET_TOOLS_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(NET_TOOLS)-$(NET_TOOLS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(NET_TOOLS_SPEC_PATCH),( cd SPECS && patch -p1 $(NET_TOOLS_SPEC) < $(buildprefix)/Patches/$(NET_TOOLS_PATCH) ) &&) \
	$(if $(NET_TOOLS_PATCHES),cp $(NET_TOOLS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(NET_TOOLS_SPEC)

$(DEPDIR)/$(NET_TOOLS): $(DEPDIR)/%$(NET_TOOLS): $(DEPDIR)/%$(GLIBC) $(NET_TOOLS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

#
# SED
#
SEDX := sed
SED_VERSION := 4.1.5-13
SED_SPEC := stm-target-$(SEDX).spec
SED_SPEC_PATCH :=
SED_PATCHES :=
SED_RPM = RPMS/sh4/$(STLINUX)-sh4-$(SEDX)-$(SED_VERSION).sh4.rpm

$(SED_RPM): \
		$(if $(SED_SPEC_PATCH),Patches/$(SED_SPEC_PATCH)) \
		$(if $(SED_PATCHES),$(SED_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(SEDX)-$(SED_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SED_SPEC_PATCH),( cd SPECS && patch -p1 $(SED_SPEC) < $(buildprefix)/Patches/$(SED_PATCH) ) &&) \
	$(if $(SED_PATCHES),cp $(SED_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(SED_SPEC)

$(DEPDIR)/$(SEDX): $(DEPDIR)/%$(SEDX): $(DEPDIR)/%$(GLIBC) $(SED_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

#
# DIFF
#
DIFF := diff
DIFF_DOC := diff-doc
DIFF_VERSION := 2.8.1-10
DIFF_SPEC := stm-target-$(DIFF).spec
DIFF_SPEC_PATCH :=
DIFF_PATCHES :=
DIFF_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DIFF)-$(DIFF_VERSION).sh4.rpm
DIFF_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DIFF)-doc-$(SED_VERSION).sh4.rpm

$(DIFF_RPM) $(DIFF_DOC_RPM): \
		$(if $(DIFF_SPEC_PATCH),Patches/$(DIFF_SPEC_PATCH)) \
		$(if $(DIFF_PATCHES),$(DIFF_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(DIFF)-$(DIFF_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(DIFF_SPEC_PATCH),( cd SPECS && patch -p1 $(DIFF_SPEC) < $(buildprefix)/Patches/$(DIFF_PATCH) ) &&) \
	$(if $(DIFF_PATCHES),cp $(DIFF_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(DIFF_SPEC)

$(DEPDIR)/$(DIFF): $(DEPDIR)/%$(DIFF): $(DEPDIR)/%$(GLIBC) $(DIFF_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) .deps/$(notdir $@) || true

$(DEPDIR)/%$(DIFF_DOC): $(DIFF_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

#
# FILE
#
FILE := file
FILE_VERSION := 4.17-7
FILE_SPEC := stm-target-$(FILE).spec
FILE_SPEC_PATCH :=
FILE_PATCHES :=
FILE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(FILE)-$(FILE_VERSION).sh4.rpm

$(FILE_RPM): \
		$(if $(FILE_SPEC_PATCH),Patches/$(FILE_SPEC_PATCH)) \
		$(if $(FILE_PATCHES),$(FILE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(FILE)-$(FILE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(FILE_SPEC_PATCH),( cd SPECS && patch -p1 $(FILE_SPEC) < $(buildprefix)/Patches/$(FILE_PATCH) ) &&) \
	$(if $(FILE_PATCHES),cp $(FILE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(FILE_SPEC)

$(DEPDIR)/$(FILE): $(DEPDIR)/%$(FILE): $(FILE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

#
# TAR
#
TAR := tar
TAR_VERSION := 1.18-11
TAR_SPEC := stm-target-$(TAR).spec
TAR_SPEC_PATCH :=
TAR_PATCHES :=
TAR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(TAR)-$(TAR_VERSION).sh4.rpm

$(TAR_RPM): \
		$(if $(TAR_SPEC_PATCH),Patches/$(TAR_SPEC_PATCH)) \
		$(if $(TAR_PATCHES),$(TAR_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(TAR)-$(TAR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(TAR_SPEC_PATCH),( cd SPECS && patch -p1 $(TAR_SPEC) < $(buildprefix)/Patches/$(TAR_PATCH) ) &&) \
	$(if $(TAR_PATCHES),cp $(TAR_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(TAR_SPEC)

$(DEPDIR)/$(TAR): $(DEPDIR)/%$(TAR): $(DEPDIR)/%$(GLIBC) $(TAR_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	

#
# STRACE
#
STRACE := strace
STRACE_VERSION := 4.5.16-21
STRACE_SPEC := stm-target-$(STRACE).spec
STRACE_SPEC_PATCH :=
STRACE_PATCHES :=
STRACE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(STRACE)-$(STRACE_VERSION).sh4.rpm

$(STRACE_RPM): \
		$(if $(STRACE_SPEC_PATCH),Patches/$(STRACE_SPEC_PATCH)) \
		$(if $(STRACE_PATCHES),$(STRACE_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(STRACE)-$(STRACE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(STRACE_SPEC_PATCH),( cd SPECS && patch -p1 $(STRACE_SPEC) < $(buildprefix)/Patches/$(STRACE_PATCH) ) &&) \
	$(if $(STRACE_PATCHES),cp $(STRACE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(STRACE_SPEC)

$(DEPDIR)/$(STRACE): $(DEPDIR)/%$(STRACE): $(DEPDIR)/%$(GLIBC) $(STRACE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@
	

#
# UTIL LINUX
# 
BEGIN[[
util_linux
  2.12r
  {PN}-{PV}
  extract:ftp://debian.lcs.mit.edu/pub/linux/utils/{PN}/v2.12/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-12.deb.diff.gz
  nothing:file://{PN}-stm.diff
;
]]END

UTIL_LINUX = util-linux
FILES_util_linux = \
/sbin/mkfs \
/sbin/blkid \
/sbin/sfdisk \
/usr/lib
UTIL_LINUX_VERSION = 2.16.1-22
UTIL_LINUX_SPEC = stm-target-$(UTIL_LINUX).spec
UTIL_LINUX_SPEC_PATCH =
UTIL_LINUX_PATCHES =
UTIL_LINUX_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UTIL_LINUX)-$(UTIL_LINUX_VERSION).sh4.rpm

$(UTIL_LINUX_RPM): \
		$(if $(UTIL_LINUX_SPEC_PATCH),Patches/$(UTIL_LINUX_SPEC_PATCH)) \
		$(if $(UTIL_LINUX_PATCHES),$(UTIL_LINUX_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(UTIL_LINUX)-$(UTIL_LINUX_VERSION).src.rpm \
		| $(NCURSES_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(UTIL_LINUX_SPEC_PATCH),( cd SPECS && patch -p1 $(UTIL_LINUX_SPEC) < $(buildprefix)/Patches/$(UTIL_LINUX_SPEC_PATCH) ) &&) \
	$(if $(UTIL_LINUX_PATCHES),cp $(UTIL_LINUX_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(UTIL_LINUX_SPEC)

$(DEPDIR)/$(UTIL_LINUX): $(UTIL_LINUX_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	$(REWRITE_LIBDEP)/lib{blkid,uuid}.la
	$(REWRITE_LIBDIR)/lib{blkid,uuid}.la
	$(start_build)
	$(fromrpm_build)
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true

#
# IPTABLES
# 
IPTABLES := iptables
IPTABLES_DEV := iptables-dev
IPTABLES_VERSION := 1.4.10-15
PKGR_dev := r0
IPTABLES_SPEC := stm-target-$(IPTABLES).spec
IPTABLES_SPEC_PATCH :=
IPTABLES_PATCHES :=
IPTABLES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(IPTABLES)-$(IPTABLES_VERSION).sh4.rpm
IPTABLES_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(IPTABLES_DEV)-$(IPTABLES_VERSION).sh4.rpm

RDEPENDS_iptables := linux-kernel

$(IPTABLES_RPM) $(IPTABLES_DEV_RPM) : \
		$(if $(IPTABLES_SPEC_PATCH),Patches/$(IPTABLES_SPEC_PATCH)) \
		$(if $(IPTABLES_PATCHES),$(IPTABLES_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(IPTABLES)-$(IPTABLES_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(IPTABLES_SPEC_PATCH),( cd SPECS && patch -p1 $(IPTABLES_SPEC) < $(buildprefix)/Patches/$(IPTABLES_SPEC_PATCH) ) &&) \
	$(if $(IPTABLES_PATCHES),cp $(IPTABLES_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(IPTABLES_SPEC)

$(DEPDIR)/$(IPTABLES_DEV): $(DEPDIR)/%$(IPTABLES_DEV): $(IPTABLES_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@

$(DEPDIR)/$(IPTABLES): $(DEPDIR)/%$(IPTABLES): $(IPTABLES_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@
	
