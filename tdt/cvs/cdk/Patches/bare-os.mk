#
# FILESYSTEM
#
$(DEPDIR)/filesystem: bootstrap-cross
	$(INSTALL) -d $(targetprefix)/{bin,boot,dev,dev.static,etc,lib,mnt,opt,proc,root,sbin,sys,tmp,usr,var}
	$(INSTALL) -d $(targetprefix)/etc/{default,opt}
	$(INSTALL) -d $(targetprefix)/usr/{bin,include,lib,local,sbin,share,src}
	$(INSTALL) -d $(targetprefix)/usr/local/{bin,include,lib,man,sbin,share,src}
	$(INSTALL) -d $(targetprefix)/usr/local/man/{man1,man2,man3,man4,man5,man6,man7,man8}
	$(INSTALL) -d $(targetprefix)/usr/share/{aclocal,doc,info,locale,man,misc,nls}
	$(INSTALL) -d $(targetprefix)/usr/share/man/{man0p,man1,man1p,man2,man3,man3p,man4,man5,man6,man7,man8,man9}
	$(INSTALL) -d $(targetprefix)/var/{backups,cache,lib,local,lock,log,mail,opt,run,spool}
	ln -sf $(targetprefix)/lib $(targetprefix)/lib64
	ln -sf $(targetprefix)/usr/lib $(targetprefix)/usr/lib64
	$(INSTALL) -d $(targetprefix)/var/lib/misc
	$(INSTALL) -d $(targetprefix)/var/lock/subsys
	$(INSTALL) -d $(targetprefix)/etc/{init.d,rc.d,samba}
	$(INSTALL) -d $(targetprefix)/etc/rc.d/{rc3.d,rcS.d}
	ln -s ../init.d $(targetprefix)/etc/rc.d/init.d
	$(INSTALL) -d $(targetprefix)/etc/samba/private
	$(INSTALL) -d $(targetprefix)/media
	$(INSTALL) -d $(targetprefix)/var/bin
	touch $@

#
# GLIBC
#
GLIBC := glibc
GLIBC_DEV := glibc-dev
PACKAGES_glibc = libc6

DESCRIPTION_libc6 = Embedded GLIBC (GNU C Library) Embedded GLIBC (EGLIBC) \
is a variant of the GNU C Library (GLIBC) that is designed to work well on \
embedded systems. EGLIBC strives to be source and binary compatible with GLIBC.\
EGLIBC's goals include reduced footprint, configurable components, better \
support for cross-compilation and cross-testing.
define postinst_libc6
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libc6 = /etc/ld.so.conf \
	      /lib/* \
	      /sbin/ldconfig

NAME_glibc_dev = libc6_dev
DESCRIPTION_glibc_dev = Embedded GLIBC (GNU C Library) Embedded GLIBC (EGLIBC) \
is a variant of the GNU C Library (GLIBC) that is designed to work well on \
embedded systems. EGLIBC strives to be source and binary compatible with GLIBC.\
EGLIBC's goals include reduced footprint, configurable components, better \
support for cross-compilation and cross-testing.
FILES_glibc_dev = /usr/lib \
		  /usr/include

GLIBC_VERSION := 2.14.1-48
GLIBC_RAWVERSION := $(firstword $(subst -, ,$(GLIBC_VERSION)))
GLIBC_SPEC := stm-target-$(GLIBC).spec
GLIBC_SPEC_PATCH :=
GLIBC_PATCHES :=
GLIBC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm
GLIBC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm

$(GLIBC_RPM) $(GLIBC_DEV_RPM): \
		$(if $(GLIBC_SPEC_PATCH),Patches/$(GLIBC_SPEC_PATCH)) \
		$(if $(GLIBC_PATCHES),$(GLIBC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(GLIBC)-$(GLIBC_VERSION).src.rpm \
		| filesystem
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GLIBC_SPEC_PATCH),( cd SPECS && patch -p1 $(GLIBC_SPEC) < $(buildprefix)/Patches/$(GLIBC_SPEC_PATCH) ) &&) \
	$(if $(GLIBC_PATCHES),cp $(GLIBC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(GLIBC_SPEC)

$(DEPDIR)/$(GLIBC): $(GLIBC_RPM) | $(DEPDIR)/filesystem
	$(rpm_install) $(lastword $^)
	$(call parent_pk,glibc)
	$(start_build)
	$(fromrpm_build)
	touch $@

$(DEPDIR)/$(GLIBC_DEV): $(DEPDIR)/$(GLIBC) $(GLIBC_DEV_RPM)
	$(rpm_install) $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@

#
# BINUTILS
#
BINUTILS := binutils
BINUTILS_DEV := binutils-dev
BINUTILS_VERSION := 2.23.2-76
BINUTILS_SPEC := stm-target-$(BINUTILS).spec
BINUTILS_SPEC_PATCH := $(BINUTILS_SPEC).$(BINUTILS_VERSION).diff
BINUTILS_PATCHES := stm-target-$(BINUTILS).$(BINUTILS_VERSION).diff
BINUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS)-$(BINUTILS_VERSION).sh4.rpm
BINUTILS_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS_DEV)-$(BINUTILS_VERSION).sh4.rpm

$(BINUTILS_RPM) $(BINUTILS_DEV_RPM): \
		$(if $(BINUTILS_SPEC_PATCH),Patches/$(BINUTILS_SPEC_PATCH)) \
		$(if $(BINUTILS_PATCHES),$(BINUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BINUTILS)-$(BINUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BINUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(BINUTILS_SPEC) < $(buildprefix)/Patches/$(BINUTILS_SPEC_PATCH) ) &&) \
	$(if $(BINUTILS_PATCHES),cp $(BINUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(BINUTILS_SPEC)

$(DEPDIR)/$(BINUTILS): $(BINUTILS_RPM)
	$(rpm_install) $(lastword $^)
	touch $@

$(DEPDIR)/$(BINUTILS_DEV): $(BINUTILS_DEV_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	touch $@

#
# GMP
#
GMP := gmp
GMP_VERSION := 5.1.3-10
GMP_SPEC := stm-target-$(GMP).spec
GMP_SPEC_PATCH :=
GMP_PATCHES :=
GMP_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GMP)-$(GMP_VERSION).sh4.rpm
PACKAGES_gmp = libgmp10 \
		libgmpxx4
DESCRIPTION_libgmp10 =  GNU multiprecision arithmetic library  GMP is a free library for \
 arbitrary precision arithmetic, operating on   signed integers, rational \
 numbers, and floating point numbers
RDEPENDS_libgmp10 = libc6
define postinst_libgmp10
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libgmp10 = /usr/lib/libgmp.so.*

DESCRIPTION_libgmpxx4 =  GNU multiprecision arithmetic library  GMP is a free library for \
 arbitrary precision arithmetic, operating on   signed integers, rational \
 numbers, and floating point numbers
RDEPENDS_libgmpxx4 = libc6 libgcc1 libstdc++6 libgmp10
define postinst_libgmpxx4
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef
FILES_libgmpxx4 = /usr/lib/libgmpxx.so.*

$(GMP_RPM): \
		$(addprefix Patches/,$(GMP_SPEC_PATCH) $(GMP_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(GMP)-$(GMP_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GMP_SPEC_PATCH),( cd SPECS && patch -p1 $(GMP_SPEC) < $(buildprefix)/Patches/$(GMP_SPEC_PATCH) ) &&) \
	$(if $(GMP_PATCHES),cp $(addprefix Patches/,$(GMP_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(GMP_SPEC)

$(DEPDIR)/$(GMP): $(GMP_RPM)
	$(rpm_install) $(lastword $^)
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libgmp.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libgmp.la
	$(call parent_pk,gmp)
	$(start_build)
	$(fromrpm_build)
	touch $@

#
# MPFR
#
MPFR := mpfr
MPFR_VERSION := 3.1.2-10
MPFR_SPEC := stm-target-$(MPFR).spec
MPFR_SPEC_PATCH :=
MPFR_PATCHES :=
MPFR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MPFR)-$(MPFR_VERSION).sh4.rpm

$(MPFR_RPM): \
		$(GMP) \
		$(addprefix Patches/,$(MPFR_SPEC_PATCH) $(MPFR_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MPFR)-$(MPFR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MPFR_SPEC_PATCH),( cd SPECS && patch -p1 $(MPFR_SPEC) < $(buildprefix)/Patches/$(MPFR_SPEC_PATCH) ) &&) \
	$(if $(MPFR_PATCHES),cp $(addprefix Patches/,$(MPFR_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(MPFR_SPEC)

$(DEPDIR)/$(MPFR): $(MPFR_RPM)
	$(rpm_install) $(lastword $^)
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libmpfr.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libmpfr.la
	$(start_build)
	$(fromrpm_build)
	touch $@

#
# MPC
#
MPC := mpc
MPC_VERSION := 1.0.1-5
MPC_SPEC := stm-target-$(MPC).spec
MPC_SPEC_PATCH :=
MPC_PATCHES :=
MPC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MPC)-$(MPC_VERSION).sh4.rpm

$(MPC_RPM): \
		$(MPFR) \
		$(addprefix Patches/,$(MPC_SPEC_PATCH) $(MPC_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(MPC)-$(MPC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MPC_SPEC_PATCH),( cd SPECS && patch -p1 $(MPC_SPEC) < $(buildprefix)/Patches/$(MPC_SPEC_PATCH) ) &&) \
	$(if $(MPC_PATCHES),cp $(addprefix Patches/,$(MPC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(MPC_SPEC)

$(DEPDIR)/$(MPC): $(MPC_RPM)
	$(rpm_install) $(lastword $^)
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libmpc.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libmpc.la
	$(start_build)
	$(fromrpm_build)
	touch $@

#
# LIBELF
#
LIBELF := libelf
LIBELF_VERSION := 0.8.13-2
LIBELF_SPEC := stm-target-$(LIBELF).spec
LIBELF_SPEC_PATCH :=
LIBELF_PATCHES :=
LIBELF_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBELF)-$(LIBELF_VERSION).sh4.rpm

$(LIBELF_RPM): \
		$(addprefix Patches/,$(LIBELF_SPEC_PATCH) $(LIBELF_PATCHES)) \
		$(archivedir)/$(STLINUX)-target-$(LIBELF)-$(LIBELF_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBELF_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBELF_SPEC) < $(buildprefix)/Patches/$(LIBELF_SPEC_PATCH) ) &&) \
	$(if $(LIBELF_PATCHES),cp $(addprefix Patches/,$(LIBELF_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(LIBELF_SPEC)

$(DEPDIR)/$(LIBELF): $(LIBELF_RPM)
	$(rpm_install) $(lastword $^)
	touch $@

#
# GCC LIBSTDC++
#
GCC := gcc
LIBSTDC := libstdc++
NAME_libstdcxx = libstdc++6
DESCRIPTION_libstdcxx = libstdc++
RDEPENDS_libstdcxx = libgcc1
FILES_libstdcxx = /usr/lib/libstdc++.so.*
LIBSTDC_DEV := libstdc++-dev
NAME_libstdcxxdev = libstdc++6-dev
DESCRIPTION_libstdcxxdev = libstdc++
RDEPENDS_libstdcxxdev = libstdc++6
FILES_libstdcxxdev = /usr/include /usr/lib/*.*
LIBGCC := libgcc
ifdef GCC48
GCC_VERSION := 4.8.2-135
else
GCC_VERSION := 4.7.3-129
endif
GCC_SPEC := stm-target-$(GCC).spec
GCC_SPEC_PATCH := $(GCC_SPEC).$(GCC_VERSION).diff
GCC_PATCHES := stm-target-$(GCC).$(GCC_VERSION).diff
GCC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GCC)-$(GCC_VERSION).sh4.rpm
LIBSTDC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm
LIBSTDC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC_DEV)-$(GCC_VERSION).sh4.rpm
LIBGCC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBGCC)-$(GCC_VERSION).sh4.rpm

$(GCC_RPM) $(LIBSTDC_RPM) $(LIBSTDC_DEV_RPM) $(LIBGCC_RPM): \
		$(if $(GCC_SPEC_PATCH),Patches/$(GCC_SPEC_PATCH)) \
		$(if $(GCC_PATCHES),$(GCC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(GCC)-$(GCC_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV) $(MPFR) $(MPC) $(LIBELF)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(GCC_SPEC_PATCH),( cd SPECS && patch -p1 $(GCC_SPEC) < $(buildprefix)/Patches/$(GCC_SPEC_PATCH) ) &&) \
	$(if $(GCC_PATCHES),cp $(addprefix Patches/,$(GCC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(GCC_SPEC)

$(DEPDIR)/$(GCC): $(DEPDIR)/$(GLIBC_DEV) $(GCC_RPM)
	$(rpm_install) $(lastword $^)
	touch $@

$(DEPDIR)/$(LIBSTDC): $(LIBSTDC_RPM)
	$(rpm_install) $(lastword $^)
	$(call parent_pk,libstdcxx)
	$(start_build)
	$(fromrpm_build)
	touch $@

$(DEPDIR)/$(LIBSTDC_DEV): $(DEPDIR)/$(LIBSTDC) $(LIBSTDC_DEV_RPM)
	$(rpm_install) $(lastword $^)
	$(call parent_pk,libstdcxxdev)
	$(start_build)
	$(fromrpm_build)
	touch $@
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/lib{std,sup}c++.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/lib{std,sup}c++.la

$(DEPDIR)/$(LIBGCC): $(LIBGCC_RPM)
	$(rpm_install) $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@

# END OF BOOTSTRAP

#
# LIBTERMCAP
#
LIBTERMCAP := libtermcap
LIBTERMCAP_DEV := libtermcap-dev
LIBTERMCAP_DOC := libtermcap-doc
FILES_libtermcap = \
/usr/lib/*.so \
/usr/lib/*.so*
FILES_libtermcap_dev = \
/usr/lib/*.so \
/usr/lib/*.so*

LIBTERMCAP_VERSION := 2.0.8-10
LIBTERMCAP_RAWVERSION := $(firstword $(subst -, ,$(LIBTERMCAP_VERSION)))
LIBTERMCAP_SPEC := stm-target-$(LIBTERMCAP).spec
LIBTERMCAP_SPEC_PATCH :=
LIBTERMCAP_PATCHES :=
LIBTERMCAP_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).sh4.rpm
LIBTERMCAP_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DEV)-$(LIBTERMCAP_VERSION).sh4.rpm
LIBTERMCAP_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DOC)-$(LIBTERMCAP_VERSION).sh4.rpm

$(LIBTERMCAP_RPM) $(LIBTERMCAP_DEV_RPM) $(LIBTERMCAP_DOC_RPM): \
		$(if $(LIBTERMCAP_SPEC_PATCH),Patches/$(LIBTERMCAP_SPEC_PATCH)) \
		$(if $(LIBTERMCAP_PATCHES),$(LIBTERMCAP_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STM_SRC)-target-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBTERMCAP_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBTERMCAP_SPEC) < $(buildprefix)/Patches/$(LIBTERMCAP_SPEC_PATCH) ) &&) \
	$(if $(LIBTERMCAP_PATCHES),cp $(LIBTERMCAP_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(LIBTERMCAP_SPEC)

$(DEPDIR)/$(LIBTERMCAP): bootstrap $(LIBTERMCAP_RPM)
	$(rpm_install) $(lastword $^)
	ln -sf libtermcap.so.2 $(prefix)/cdkroot/usr/lib/libtermcap.so && \
	$(INSTALL) -m 644 $(buildprefix)/root/etc/termcap $(prefix)/cdkroot/etc
	$(start_build)
	$(fromrpm_build)
	touch $@


$(DEPDIR)/$(LIBTERMCAP_DEV): $(DEPDIR)/$(LIBTERMCAP) $(LIBTERMCAP_DEV_RPM)
	$(rpm_install) $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@


$(DEPDIR)/$(LIBTERMCAP_DOC): $(LIBTERMCAP_DOC_RPM)
	$(rpm_install) $(lastword $^)
	touch $@


#
# NCURSES
#
PACKAGES_ncurses = libncurses5 \
		  libpanel5 \
		  libmenu5 \
		  libform5

DESCRIPTION_libncurses5 =  ncurses panel library  ncurses panel library
RDEPENDS_libncurses5 = libc6
FILES_libncurses5 = /lib/*
define postinst_libncurses5
#!/bin/sh
if [ x"$$OPKG_OFFLINE_ROOT/" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

DESCRIPTION_libpanel5 =  ncurses panel library  ncurses panel library
RDEPENDS_libpanel5 = libncurses5 libc6
FILES_libpanel5 = /usr/lib/libpanel.so.*
define postinst_libpanel5
#!/bin/sh
if [ x"$$OPKG_OFFLINE_ROOT/" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

DESCRIPTION_libmenu5 =  ncurses panel library  ncurses panel library
RDEPENDS_libmenu5 = libncurses5 libc6
FILES_libmenu5 = /usr/lib/libpanel.so.*
define postinst_libmenu5
#!/bin/sh
if [ x"$$OPKG_OFFLINE_ROOT/" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

DESCRIPTION_libform5 =  ncurses panel library  ncurses panel library
RDEPENDS_libform5 = libncurses5 libc6
FILES_libform5 = /usr/lib/libpanel.so.*
define postinst_libform5
#!/bin/sh
if [ x"$$OPKG_OFFLINE_ROOT/" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

NCURSES := ncurses
NCURSES_BASE := ncurses-base
NCURSES_DEV := ncurses-dev
NCURSES_VERSION := 5.5-10
NCURSES_SPEC := stm-target-$(NCURSES).spec
NCURSES_SPEC_PATCH :=
NCURSES_PATCHES :=
NCURSES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES)-$(NCURSES_VERSION).sh4.rpm
NCURSES_BASE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_BASE)-$(NCURSES_VERSION).sh4.rpm
NCURSES_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_DEV)-$(NCURSES_VERSION).sh4.rpm

$(DEPDIR)/ncurses.do_compile \
$(NCURSES_RPM) $(NCURSES_BASE_RPM) $(NCURSES_DEV_RPM): \
		$(if $(NCURSES_SPEC_PATCH),Patches/$(NCURSES_SPEC_PATCH)) \
		$(if $(NCURSES_PATCHES),$(NCURSES_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STM_SRC)-target-$(NCURSES)-$(NCURSES_VERSION).src.rpm \
		| $(DEPDIR)/$(LIBSTDC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(NCURSES_SPEC_PATCH),( cd SPECS && patch -p1 $(NCURSES_SPEC) < $(buildprefix)/Patches/$(NCURSES_SPEC_PATCH) ) &&) \
	$(if $(NCURSES_PATCHES),cp $(NCURSES_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(NCURSES_SPEC)
	touch $(DEPDIR)/ncurses.do_compile

$(DEPDIR)/$(NCURSES_BASE): $(NCURSES_BASE_RPM)
	$(rpm_install) $(lastword $^)
	touch $@

$(DEPDIR)/$(NCURSES): $(DEPDIR)/$(NCURSES_BASE) $(NCURSES_RPM)
	$(rpm_install) $(lastword $^)
	$(call parent_pk,ncurses)
	$(start_build)
	$(fromrpm_build)
	touch $@
	
$(DEPDIR)/$(NCURSES_DEV): $(DEPDIR)/$(NCURSES_BASE) $(NCURSES_DEV_RPM)
	$(rpm_install) $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@


#
# BASE-PASSWD
#
BASE_PASSWD := base-passwd
BASE_PASSWD_VERSION := 3.5.9-11
BASE_PASSWD_SPEC := stm-target-$(BASE_PASSWD).spec
BASE_PASSWD_SPEC_PATCH :=
BASE_PASSWD_PATCHES :=
BASE_PASSWD_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm

$(BASE_PASSWD_RPM): \
		$(if $(BASE_PASSWD_SPEC_PATCH),Patches/$(BASE_PASSWD_SPEC_PATCH)) \
		$(if $(BASE_PASSWD_PATCHES),$(BASE_PASSWD_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASE_PASSWD_SPEC_PATCH),( cd SPECS && patch -p1 $(BASE_PASSWD_SPEC) < $(buildprefix)/Patches/$(BASE_PASSWD_SPEC_PATCH) ) &&) \
	$(if $(BASE_PASSWD_PATCHES),cp $(BASE_PASSWD_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(BASE_PASSWD_SPEC)

$(DEPDIR)/$(BASE_PASSWD): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(BASE_PASSWD_RPM)
	$(rpm_install) --nopost --replacepkgs $(lastword $^)
		$(hostprefix)/bin/update-passwd -L -p $(prefix)/cdkroot/usr/share/base-passwd/passwd.master \
			-g $(prefix)/cdkroot/usr/share/base-passwd/group.master -P $(prefix)/cdkroot/etc/passwd \
			-S $(prefix)/cdkroot/etc/shadow -G $(prefix)/cdkroot/etc/group && \
	chmod 600 $(prefix)/cdkroot/etc/shadow && \
	( cd $(prefix)/cdkroot/etc && sed -e "s|/bin/bash|/bin/sh|g" -i passwd ) && \
	rm -f $(prefix)/cdkroot/etc/shadow
	touch $@


#
# MAKEDEV
#
MAKEDEV := makedev
MAKEDEV_VERSION := 2.3.1-27
MAKEDEV_SPEC := stm-target-$(MAKEDEV).spec
MAKEDEV_SPEC_PATCH :=
MAKEDEV_PATCHES :=
MAKEDEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm

$(MAKEDEV_RPM): \
		$(if $(MAKEDEV_SPEC_PATCH),Patches/$(MAKEDEV_SPEC_PATCH)) \
		$(if $(MAKEDEV_PATCHES),$(MAKEDEV_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(MAKEDEV)-$(MAKEDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MAKEDEV_SPEC_PATCH),( cd SPECS && patch -p1 $(MAKEDEV_SPEC) < $(buildprefix)/Patches/$(MAKEDEV_SPEC_PATCH) ) &&) \
	$(if $(MAKEDEV_PATCHES),cp $(MAKEDEV_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(MAKEDEV_SPEC)

$(DEPDIR)/$(MAKEDEV): root/sbin/MAKEDEV $(MAKEDEV_RPM)
	$(rpm_install) --nopost $(lastword $^)
	$(INSTALL) -m 755 root/sbin/MAKEDEV $(prefix)/cdkroot/sbin
	touch $@


#
# BASE-FILES
#
BASE_FILES := base-files
BASE_FILES_VERSION := 2.0-8
BASE_FILES_SPEC := stm-target-$(BASE_FILES).spec
BASE_FILES_SPEC_PATCH :=
BASE_FILES_PATCHES :=
BASE_FILES_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm

$(BASE_FILES_RPM): \
		$(if $(BASE_FILES_SPEC_PATCH),Patches/$(BASE_FILES_SPEC_PATCH)) \
		$(if $(BASE_FILES_PATCHES),$(BASE_FILES_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BASE_FILES)-$(BASE_FILES_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASE_FILES_SPEC_PATCH),( cd SPECS && patch -p1 $(BASE_FILES_SPEC) < $(buildprefix)/Patches/$(BASE_FILES_SPEC_PATCH) ) &&) \
	$(if $(BASE_FILES_PATCHES),cp $(BASE_FILES_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(BASE_FILES_SPEC)

$(DEPDIR)/$(BASE_FILES): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(BASE_FILES_RPM)
	$(rpm_install) --replacepkgs $(lastword $^)

	( cd root/etc && for i in $(BASE_FILES_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/cdkroot/etc/$$i || true; done ) && \
	echo "proc          /proc               proc    defaults                        0 0" >> $(prefix)/cdkroot/etc/fstab && \
	echo "tmpfs         /tmp                tmpfs   defaults                        0 0" >> $(prefix)/cdkroot/etc/fstab && \
	touch $@
	

#
# LIBATTR
#
LIBATTR := libattr
PACKAGES_libattr = attr \
		   libattr1
DESCRIPTION_attr = Utilities for manipulating filesystem extended attributes \
 Utilities for manipulating filesystem extended attributes.
RDEPENDS_attr = libattr1 libc6
FILES_attr = /usr/bin

DESCRIPTION_libattr1 = Utilities for manipulating filesystem extended attributes \
 Utilities for manipulating filesystem extended attributes.
RDEPENDS_libattr1 = libc6
FILES_libattr1 = /usr/lib/*
define postinst_libattr1
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

LIBATTR_DEV := libattr-dev
LIBATTR_VERSION := 2.4.47-5
LIBATTR_SPEC := stm-target-$(LIBATTR).spec
LIBATTR_SPEC_PATCH :=
LIBATTR_PATCHES :=

LIBATTR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBATTR)-$(LIBATTR_VERSION).sh4.rpm
LIBATTR_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBATTR_DEV)-$(LIBATTR_VERSION).sh4.rpm

$(LIBATTR_RPM) $(LIBATTR_DEV_RPM): \
		$(if $(LIBATTR_SPEC_PATCH),Patches/$(LIBATTR_SPEC_PATCH)) \
		$(if $(LIBATTR_PATCHES),$(LIBATTR_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBATTR)-$(LIBATTR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBATTR_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBATTR_SPEC) < $(buildprefix)/Patches/$(LIBATTR_SPEC_PATCH) ) &&) \
	$(if $(LIBATTR_PATCHES),cp $(LIBATTR_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(LIBATTR_SPEC)

$(DEPDIR)/$(LIBATTR): $(LIBATTR_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	$(call parent_pk,libattr)
	$(start_build)
	$(fromrpm_build)
	touch $@


$(DEPDIR)/$(LIBATTR_DEV): $(LIBATTR_DEV_RPM)
	$(rpm_install) --noscripts $(lastword $^)
#	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libattr.la
#	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libattr.la
	$(REWRITE_LIBDIR)/libattr.la
	touch $@

#
# LIBAIO
#
LIBAIO := libaio
LIBAIO_DEV := libaio-dev
LIBAIO_VERSION := 0.3.109-2
LIBAIO_SPEC := stm-target-$(LIBAIO).spec
LIBAIO_SPEC_PATCH :=
LIBAIO_PATCHES :=
NAME_libaio = libaio1
DESCRIPTION_libaio =  Asynchronous input/output library that uses the kernels native interface
FILES_libaio = /lib

LIBAIO_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBAIO)-$(LIBAIO_VERSION).sh4.rpm
LIBAIO_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBAIO_DEV)-$(LIBAIO_VERSION).sh4.rpm

$(LIBAIO_RPM) $(LIBAIO_DEV_RPM): \
		$(if $(LIBAIO_SPEC_PATCH),Patches/$(LIBAIO_SPEC_PATCH)) \
		$(if $(LIBAIO_PATCHES),$(LIBAIO_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBAIO)-$(LIBAIO_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBAIO_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBAIO_SPEC) < $(buildprefix)/Patches/$(LIBAIO_SPEC_PATCH) ) &&) \
	$(if $(LIBAIO_PATCHES),cp $(LIBAIO_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(LIBAIO_SPEC)

$(DEPDIR)/$(LIBAIO): $(LIBAIO_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	$(start_build)
	$(fromrpm_build)
	touch $@


$(DEPDIR)/$(LIBAIO_DEV): $(LIBAIO_DEV_RPM)
	$(rpm_install) --noscripts $(lastword $^)
#	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/libaio.la
#	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/libaio.la
	$(REWRITE_LIBDIR)/libaio.la
	touch $@

#
# LIBACL
#
LIBACL := libacl
LIBACL_DEV := libacl-dev
LIBACL_VERSION := 2.2.47-6
LIBACL_SPEC := stm-target-$(LIBACL).spec
LIBACL_SPEC_PATCH :=
LIBACL_PATCHES :=

LIBACL_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBACL)-$(LIBACL_VERSION).sh4.rpm
LIBACL_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBACL_DEV)-$(LIBACL_VERSION).sh4.rpm

$(LIBACL_RPM) $(LIBACL_DEV_RPM): \
		libattr libattr-dev \
		$(if $(LIBACL_SPEC_PATCH),Patches/$(LIBACL_SPEC_PATCH)) \
		$(if $(LIBACL_PATCHES),$(LIBACL_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBACL)-$(LIBACL_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBACL_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBACL_SPEC) < $(buildprefix)/Patches/$(LIBACL_SPEC_PATCH) ) &&) \
	$(if $(LIBACL_PATCHES),cp $(LIBACL_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(LIBACL_SPEC)

$(DEPDIR)/$(LIBACL): $(LIBACL_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	touch $@
	$(start_build)
	$(fromrpm_build)
	
$(DEPDIR)/$(LIBACL_DEV): $(LIBACL_DEV_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	$(REWRITE_LIBDIR)/libacl.la
	$(REWRITE_LIBDEP)/libacl.la
	touch $@
	


#
# USBUTILS
#
USBUTILS := usbutils
USBUTILS_VERSION := 0.86-11
USBUTILS_SPEC := stm-target-$(USBUTILS).spec
USBUTILS_SPEC_PATCH := stm-target-$(USBUTILS).spec.diff
USBUTILS_PATCHES :=
USBUTILS_usbutils = libusb
USBUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(USBUTILS)-$(USBUTILS_VERSION).sh4.rpm

$(USBUTILS_RPM): \
		$(if $(USBUTILS_SPEC_PATCH),Patches/$(USBUTILS_SPEC_PATCH)) \
		$(if $(USBUTILS_PATCHES),$(USBUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(USBUTILS)-$(USBUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(USBUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(USBUTILS_SPEC) < $(buildprefix)/Patches/$(USBUTILS_SPEC_PATCH) ) &&) \
	$(if $(USBUTILS_PATCHES),cp $(USBUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(USBUTILS_SPEC)

$(DEPDIR)/$(USBUTILS): $(USBUTILS_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	touch $@
	

#
# UDEV
#

UDEV := udev
UDEV_DEV := udev-dev
UDEV_VERSION := 162-37
PKGR_udev := r0
UDEV_SPEC := stm-target-$(UDEV).spec
UDEV_SPEC_PATCH := stm-target-udev.spec.diff
UDEV_PATCHES := usbhd-automount.rules
UDEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UDEV)-$(UDEV_VERSION).sh4.rpm
UDEV_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UDEV_DEV)-$(UDEV_VERSION).sh4.rpm

RDEPENDS_udev := libattr1 libacl libusb_1.0 libusb_0.1
define postinst_udev
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ udev start 5 S . stop 99 0 6 .
update-rc.d -r $$OPKG_OFFLINE_ROOT/ udevadm start 6 S . stop 99 0 6 .
endef

define prerm_udev
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ udev remove
endef

$(UDEV_RPM) $(UDEV_DEV_RPM): \
		glib2 libacl libacl-dev libusb_compat usbutils udevrules \
		$(if $(UDEV_SPEC_PATCH),Patches/$(UDEV_SPEC_PATCH)) \
		$(if $(UDEV_PATCHES),$(UDEV_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(UDEV)-$(UDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(UDEV_SPEC_PATCH),( cd SPECS && patch -p1 $(UDEV_SPEC) < $(buildprefix)/Patches/$(UDEV_SPEC_PATCH) ) &&) \
	$(if $(UDEV_PATCHES),cp $(UDEV_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	$(rpm_build) SPECS/$(UDEV_SPEC)

$(DEPDIR)/$(UDEV_DEV): $(UDEV_DEV_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	touch $@
	$(REWRITE_LIBDEP)/libgudev-1.0.la

$(DEPDIR)/$(UDEV): $(UDEV_RPM)
	$(rpm_install) --noscripts $(lastword $^)
	$(start_build)
	$(remove_docs)
	$(fromrpm_get)
	$(INSTALL_udev)
	$(toflash_build)
	touch $@
	
#
# UDEV RULES
#
BEGIN[[
udevrules
  0.3
  {PN}-{PV}
  pdircreate:{PN}-{PV}
  nothing:file://../root/etc/60-dvb-ca.rules
;
]]END

NAME_udevrules = udev_rules
DESCRIPTION_udevrules = custom udev rules
RDEPENDS_udevrules = udev

$(DEPDIR)/udevrules: $(DEPENDS_udevrules) $(RDEPENDS_udevrules)
	$(PREPARE_udevrules)
	$(start_build)
	cd $(DIR_udevrules) && \
	$(INSTALL_DIR) $(PKDIR)/etc/udev/rules.d/ && \
	$(INSTALL_FILE) 60-dvb-ca.rules $(PKDIR)/etc/udev/rules.d/ && \
	$(toflash_build)
	touch $@
