AC_INIT([tufsbox-cdk],[0])
AC_PREREQ(2.59)

AC_CANONICAL_HOST
host_arch=`which arch > /dev/null 2>&1 && arch || uname -m`
AC_SUBST(host_arch)
AC_CANONICAL_BUILD
AC_SUBST(build)
if test "$target_alias" = "" ; then
	target_alias="sh4-linux"
fi
AC_CANONICAL_TARGET
if test "$target" = "sh4-unknown-linux-gnu" ; then
	target="sh4-linux"
fi
AC_SUBST(target)
TUXBOX_BOXTYPE
BOXTYPE=$(BOXTYPE)
AC_PROG_INSTALL
AC_SUBST(INSTALL)

AC_PROG_CC

AC_ARG_ENABLE(player179,
	AS_HELP_STRING(--enable-player179,	set up the CDK to use player179),
	[case "${enableval}" in
		yes) PLAYER179=player179 ;;
	esac],[enable_player179=no])
AM_CONDITIONAL(ENABLE_PLAYER179,test "$enable_player179" = "yes")
AC_SUBST(PLAYER179)

AC_ARG_ENABLE(player191,
	AS_HELP_STRING(--enable-player191,	set up the CDK to use player191),
	[case "${enableval}" in
		yes) PLAYER191=player191 ;;
	esac],[enable_player191=no])
TDT_CONDITIONAL(ENABLE_PLAYER191,test "$enable_player191" = "yes")
AC_SUBST(PLAYER191)

AC_ARG_ENABLE(multicom406,
	AS_HELP_STRING(--enable-multicom406, set up the CDK to use multicom406),
	[case "${enableval}" in
		yes) MULTICOM406=multicom406 ;;
	esac],[enable_multicom406=no])
TDT_CONDITIONAL(ENABLE_MULTICOM406,test "$enable_multicom406" = "yes")
AC_SUBST(MULTICOM406)

AC_ARG_ENABLE(multicom324,
	AS_HELP_STRING(--enable-multicom324, set up the CDK to use multicom324),
	[case "${enableval}" in
		yes) MULTICOM324=multicom324 ;;
	esac],[enable_multicom324=no])
TDT_CONDITIONAL(ENABLE_MULTICOM324,test "$enable_multicom324" = "yes")
AC_SUBST(MULTICOM324)

AC_ARG_ENABLE(stm24,
	AS_HELP_STRING(--enable-stm24,	set up the CDK to use the STLinux 2.4),
	,[enable_stm24=no])
TDT_CONDITIONAL(STM24,test "$enable_stm24" = "yes")

AC_ARG_ENABLE(py27,
	AS_HELP_STRING(--enable-py27,      enable Python 2.7 ),
	[case "${enableval}" in
		yes) PY27=py27 ;;
	esac],[enable_py27=no])
TDT_CONDITIONAL(ENABLE_PY27,test "$enable_py27" = "yes")
AC_SUBST(PY27)

AC_ARG_ENABLE(py26,
	AS_HELP_STRING(--enable-py26,      enable Python 2.6 ),
	[case "${enableval}" in
		yes) PY26=py26 ;;
	esac],[enable_py26=no])
TDT_CONDITIONAL(ENABLE_PY26,test "$enable_py26" = "yes")
AC_SUBST(PY26)

AC_ARG_ENABLE(p0211,
	AS_HELP_STRING(--enable-p0211,  set up the CDK to use the STLinux 2.4 with patchlevel 0211),
	[case "${enableval}" in
		yes) P0211=p0211 ;;
	esac], [enable_p0211=no])
TDT_CONDITIONAL(ENABLE_P0211,test "$enable_p0211" = "yes")
AC_SUBST(P0211)

AC_ARG_ENABLE(p0213,
	AS_HELP_STRING(--enable-p0213,  set up the CDK to use the STLinux 2.4 with patchlevel 0213),
	[case "${enableval}" in
		yes) P0213=p0213 ;;
	esac], [enable_p0213=no])
TDT_CONDITIONAL(ENABLE_P0213,test "$enable_p0213" = "yes")
AC_SUBST(P0213)

AC_ARG_ENABLE(p0214,
	AS_HELP_STRING(--enable-p0214,  set up the CDK to use the STLinux 2.4 with patchlevel 0214),
	[case "${enableval}" in
		yes) P0214=p0214 ;;
	esac], [enable_p0214=no])
TDT_CONDITIONAL(ENABLE_P0214,test "$enable_p0214" = "yes")
AC_SUBST(P0214)

AC_ARG_ENABLE(p0215,
	AS_HELP_STRING(--enable-p0215,  set up the CDK to use the STLinux 2.4 with patchlevel 0215),
	[case "${enableval}" in
		yes) P0215=p0215 ;;
	esac], [enable_p0215=no])
TDT_CONDITIONAL(ENABLE_P0215,test "$enable_p0215" = "yes")
AC_SUBST(P0215)

AC_ARG_ENABLE(debug,
	AS_HELP_STRING(--enable-debug,	set up the CDK to use debug kernel configs),
	,[enable_debug=no])
TDT_CONDITIONAL(DEBUG,test "$enable_debug" = "yes")

AC_ARG_WITH(cpu,
	[  --with-cpu=MODEL        cpu model [[sh4]]],
	[CPU_MODEL="$withval"],[CPU_MODEL="sh4"])
AC_SUBST(CPU_MODEL)

AC_ARG_WITH(assume-kernelsources-old,
	[  --with-assume-kernelsources-old	Do not recompile due to new kernel sources],
	[assume_kernelsources_old="yes"],[assume_kernelsources_old="no"])
TDT_CONDITIONAL(ASSUME_KERNELSOURCES_OLD,test "$assume_kernelsources_old" = "yes")

AC_ARG_ENABLE(mediafwgstreamer,
	AS_HELP_STRING(--enable-mediafwgstreamer,	set up the CDK to use mediafw gstreamer),
	,[enable_mediafwgstreamer=no])
TDT_CONDITIONAL(ENABLE_MEDIAFWGSTREAMER,test "$enable_mediafwgstreamer" = "yes")
AC_SUBST(MEDIAFWGSTREAMER)

AC_ARG_ENABLE(eplayer3,
	AS_HELP_STRING(--enable-eplayer3,    enable eplayer3 support),
	,[enable_eplayer3=no])
TDT_CONDITIONAL(ENABLE_EPLAYER3,test "$enable_eplayer3" = "yes")
AC_SUBST(EPLAYER3)

AC_ARG_ENABLE(graphicfwdirectfb,
	AS_HELP_STRING(--enable-graphicfwdirectfb,	set up the CDK to use graphicfw directfb),
	,[enable_graphicfwdirectfb=no])
TDT_CONDITIONAL(ENABLE_GRAPHICFWDIRECTFB,test "$enable_graphicfwdirectfb" = "yes")
AC_SUBST(GRAPHICFWDIRECTFB)

AC_ARG_ENABLE(externallcd,
	AS_HELP_STRING(--enable-externallcd,	set up the CDK to use graphlcd),
	,[enable_externallcd=no])
TDT_CONDITIONAL(ENABLE_EXTERNALLCD,test "$enable_externallcd" = "yes")
AC_SUBST(EXTERNALLCD)

if test "$enable_externallcd" != "yes"  ; then
    AC_DEFINE(NO_LCD,1,[disable all lcd])
fi

AC_ARG_ENABLE(gcc48,
    AS_HELP_STRING(--enable-gcc48, compile image stm24 using gcc 4.8),
    ,[enable_gcc48=no])
TDT_CONDITIONAL(GCC48,test "$enable_gcc48" = "yes")
AC_SUBST(GCC48)

if test -z "$CFLAGS" ; then
	CFLAGS="-g -O2"
fi
# CFLAGS="-g -O2 -fno-strict-aliasing"
if test -z "$TARGET_CFLAGS" -o -z "$TARGET_CXXFLAGS"; then
	TARGET_CFLAGS="-O2"
	if test "$enable_flashrules" != "yes"; then
		TARGET_CFLAGS="$TARGET_CFLAGS"
		TARGET_LDFLAGS=""
	else
		TARGET_CFLAGS="$TARGET_CFLAGS"
		TARGET_LDFLAGS=""
	fi
	TARGET_CXXFLAGS="$TARGET_CFLAGS"
fi

AC_ARG_ENABLE(lirc,
	AS_HELP_STRING(--enable-lirc,	include lirc in yadds and images),
	[case "${enableval}" in
		yes) LIRC=lirc ;;
	esac], [enable_lirc=no])
TDT_CONDITIONAL(ENABLE_LIRC,test "$enable_lirc" = "yes")
AC_SUBST(LIRC)

AC_ARG_ENABLE(xfs,
	AS_HELP_STRING(--enable-xfs,    include xfs drivers in yauds and images),
	[case "${enableval}" in
		yes) XFSPROGS=xfsprogs ;;
	esac],[enable_xfs=no])
TDT_CONDITIONAL(ENABLE_XFS,test "$enable_xfs" = "yes")
AC_SUBST(XFSPROGS)

AC_ARG_ENABLE(ntfs,
	AS_HELP_STRING(--enable-ntfs,    include ntfs drivers in yauds and images),
	[case "${enableval}" in
		yes) NTFS=ntfs ;;
	esac],[enable_ntfs=no])
TDT_CONDITIONAL(ENABLE_NTFS,test "$enable_ntfs" = "yes")
AC_SUBST(NTFS)

AC_ARG_ENABLE(nfsserver,
	AS_HELP_STRING(--enable-nfsserver,      enable NFS server),
	[case "${enableval}" in
		yes) NFSSERVER=nfs-utils ;;
	esac],[enable_nfsserver=no])
TDT_CONDITIONAL(ENABLE_NFSSERVER,test "$enable_nfsserver" = "yes")
AC_SUBST(NFSSERVER)


AC_ARG_ENABLE(var,
	AS_HELP_STRING(--enable-var,    move stock and libs into var),
	[case "${enableval}" in
		yes) VAR=var ;;
	esac],[enable_var=no])
TDT_CONDITIONAL(ENABLE_VAR,test "$enable_var" = "yes")
AC_SUBST(VAR)

AC_ARG_WITH(rootpartitionsize,
	[  --with-rootpartitionsize=SIZE	size of the root partition],
	[ROOT_PARTITION_SIZE="$withval"],[ROOT_PARTITION_SIZE="0x240000"])
AC_SUBST(ROOT_PARTITION_SIZE)

AC_ARG_WITH(datapartitionsize,
	[  --with-datapartitionsize=SIZE	size of the data partition],
	[DATA_PARTITION_SIZE="$withval"],[DATA_PARTITION_SIZE="0x400000"])
AC_SUBST(DATA_PARTITION_SIZE)

AC_ARG_ENABLE(ccache,
	AS_HELP_STRING(--enable-ccache,	enable ccache),
	[case "${enableval}" in
		yes) CCACHE_BIN=ccache;;
	esac], [enable_ccache=no])
TDT_CONDITIONAL(ENABLE_CCACHE,test "$enable_ccache" = "yes")
AC_SUBST(CCACHE_BIN)

AC_ARG_ENABLE(hl101,
	AS_HELP_STRING(--enable-hl101,    enable spider box hl101 stuff),
	[case "${enableval}" in
		yes) HL101=hl101 ;;
	esac],[enable_hl101=no])
TDT_CONDITIONAL(ENABLE_HL101,test "$enable_hl101" = "yes")
AC_SUBST(HL101)

AC_ARG_ENABLE(spark,
	AS_HELP_STRING(--enable-spark,    enable spark),
	[case "${enableval}" in
		yes) SPARK=spark ;;
	esac],[enable_spark=no])
TDT_CONDITIONAL(ENABLE_SPARK,test "$enable_spark" = "yes")
AC_SUBST(SPARK)

AC_ARG_ENABLE(spark7162,
	AS_HELP_STRING(--enable-spark7162,    enable spark7162),
	[case "${enableval}" in
		yes) SPARK7162=spark7162 ;;
	esac],[enable_spark7162=no])
TDT_CONDITIONAL(ENABLE_SPARK7162,test "$enable_spark7162" = "yes")
AC_SUBST(SPARK7162)

AC_ARG_ENABLE(e2pd0,
	AS_HELP_STRING(--enable-e2pd0,  enable enigma2-pli-nigthly diff0 ),
	[case "${enableval}" in
		yes) E2PD0=e2pd0 ;;
	esac], [enable_e2pd0=no])
TDT_CONDITIONAL(ENABLE_E2PD0,test "$enable_e2pd0" = "yes")
AC_SUBST(E2PD0)

AC_ARG_ENABLE(e2pd1,
	AS_HELP_STRING(--enable-e2pd1,  enable enigma2-pli-nigthly diff1 ),
	[case "${enableval}" in
		yes) E2PD1=e2pd1 ;;
	esac], [enable_e2pd1=no])
TDT_CONDITIONAL(ENABLE_E2PD1,test "$enable_e2pd1" = "yes")
AC_SUBST(E2PD1)

AC_ARG_ENABLE(e2pd2,
	AS_HELP_STRING(--enable-e2pd2,  enable enigma2-pli-nigthly diff2 ),
	[case "${enableval}" in
		yes) E2PD2=e2pd2 ;;
	esac], [enable_e2pd2=no])
TDT_CONDITIONAL(ENABLE_E2PD2,test "$enable_e2pd2" = "yes")
AC_SUBST(E2PD2)

AC_ARG_ENABLE(e2pd3,
	AS_HELP_STRING(--enable-e2pd3,  enable enigma2-pli-nigthly diff3 ),
	[case "${enableval}" in
		yes) E2PD3=e2pd3 ;;
	esac], [enable_e2pd3=no])
TDT_CONDITIONAL(ENABLE_E2PD3,test "$enable_e2pd3" = "yes")
AC_SUBST(E2PD3)

AC_ARG_ENABLE(e2pd4,
	AS_HELP_STRING(--enable-e2pd4,  enable enigma2-pli-nigthly diff4 ),
	[case "${enableval}" in
		yes) E2PD4=e2pd4 ;;
	esac], [enable_e2pd4=no])
TDT_CONDITIONAL(ENABLE_E2PD4,test "$enable_e2pd4" = "yes")
AC_SUBST(E2PD4)

AC_ARG_ENABLE(e2pd5,
	AS_HELP_STRING(--enable-e2pd5,  enable enigma2-pli-nigthly diff5 ),
	[case "${enableval}" in
		yes) E2PD5=e2pd5 ;;
	esac], [enable_e2pd5=no])
TDT_CONDITIONAL(ENABLE_E2PD5,test "$enable_e2pd5" = "yes")
AC_SUBST(E2PD5)

AC_ARG_ENABLE(e2pd6,
	AS_HELP_STRING(--enable-e2pd6,  enable enigma2-pli-nigthly diff6 ),
	[case "${enableval}" in
		yes) E2PD6=e2pd6 ;;
	esac], [enable_e2pd6=no])
TDT_CONDITIONAL(ENABLE_E2PD6,test "$enable_e2pd6" = "yes")
AC_SUBST(E2PD6)

AC_ARG_ENABLE(e2pd7,
	AS_HELP_STRING(--enable-e2pd7,  enable enigma2-pli-nigthly diff7 ),
	[case "${enableval}" in
		yes) E2PD7=e2pd7 ;;
	esac], [enable_e2pd7=no])
TDT_CONDITIONAL(ENABLE_E2PD7,test "$enable_e2pd7" = "yes")
AC_SUBST(E2PD7)

AC_ARG_ENABLE(e2pd8,
	AS_HELP_STRING(--enable-e2pd8,  enable enigma2-pli-nigthly diff8 ),
	[case "${enableval}" in
		yes) E2PD8=e2pd8 ;;
	esac], [enable_e2pd8=no])
TDT_CONDITIONAL(ENABLE_E2PD8,test "$enable_e2pd8" = "yes")
AC_SUBST(E2PD8)

AC_ARG_ENABLE(xbd0,
	AS_HELP_STRING(--enable-xbd0,  enable xbmc-nigthly diff0 ),
	[case "${enableval}" in
		yes) XBD0=xbd0 ;;
	esac], [enable_xbd0=no])
TDT_CONDITIONAL(ENABLE_XBD0,test "$enable_xbd0" = "yes")
AC_SUBST(XBD0)

AC_ARG_ENABLE(xbd1,
	AS_HELP_STRING(--enable-xbd1,  enable xbmc-nigthly diff1 ),
	[case "${enableval}" in
		yes) XBD1=xbd1 ;;
	esac], [enable_xbd1=no])
TDT_CONDITIONAL(ENABLE_XBD1,test "$enable_xbd1" = "yes")
AC_SUBST(XBD1)

AC_ARG_ENABLE(xbd2,
	AS_HELP_STRING(--enable-xbd2,  enable xbmc-nigthly diff2 ),
	[case "${enableval}" in
		yes) XBD2=xbd2 ;;
	esac], [enable_xbd2=no])
TDT_CONDITIONAL(ENABLE_XBD2,test "$enable_xbd2" = "yes")
AC_SUBST(XBD2)

AC_ARG_ENABLE(nhd0,
	AS_HELP_STRING(--enable-nhd0,  enable neutrino-hd-nigthly diff0 ),
	[case "${enableval}" in
		yes) NHD0=nhd0 ;;
	esac], [enable_nhd0=no])
TDT_CONDITIONAL(ENABLE_NHD0,test "$enable_nhd0" = "yes")
AC_SUBST(NHD0)

AC_ARG_ENABLE(nhd1,
	AS_HELP_STRING(--enable-nhd1,  enable neutrino-hd-nigthly diff1 ),
	[case "${enableval}" in
		yes) NHD1=nhd1 ;;
	esac], [enable_nhd1=no])
TDT_CONDITIONAL(ENABLE_NHD1,test "$enable_nhd1" = "yes")
AC_SUBST(NHD1)

AC_ARG_ENABLE(nhd2,
	AS_HELP_STRING(--enable-nhd2,  enable neutrino-hd-nigthly diff2 ),
	[case "${enableval}" in
		yes) NHD2=nhd2 ;;
	esac], [enable_nhd2=no])
TDT_CONDITIONAL(ENABLE_NHD2,test "$enable_nhd2" = "yes")
AC_SUBST(NHD2)

AC_ARG_ENABLE(vdr1722,
	AS_HELP_STRING(--enable-vdr1722,    enable vdr-1.7.22 stuff),
	[case "${enableval}" in
		yes) VDR1722=vdr1722 ;;
	esac],[enable_vdr1722=no])
TDT_CONDITIONAL(ENABLE_VDR1722,test "$enable_vdr1722" = "yes")
AC_SUBST(VDR1722)

AC_ARG_ENABLE(vdr1727,
	AS_HELP_STRING(--enable-vdr1727,    enable vdr-1.7.27 stuff),
	[case "${enableval}" in
		yes) VDR1722=vdr1727 ;;
	esac],[enable_vdr1727=no])
TDT_CONDITIONAL(ENABLE_VDR1727,test "$enable_vdr1727" = "yes")
AC_SUBST(VDR1727)

AC_SUBST(CFLAGS)
AC_SUBST(TARGET_CFLAGS)
AC_SUBST(TARGET_CXXFLAGS)
AC_SUBST(TARGET_LDFLAGS)
AC_SUBST(BOXTYPE)

AC_PREFIX_DEFAULT(/ufs910)

if test "$prefix" = "NONE"; then
	prefix=/ufs910
fi

AC_ARG_WITH(targetprefix,
	[  --with-targetprefix=DIR prefix for target files [[PREFIX/cdkroot]]],
	[targetprefix="$with_targetprefix"],[targetprefix="${prefix}/cdkroot"])

AC_ARG_WITH(hostprefix,
	[  --with-hostprefix=DIR   prefix for host files [[PREFIX/host]]],
	[hostprefix="$with_hostprefix"],[hostprefix="${prefix}/host"])

AC_ARG_WITH(workprefix,
	[  --with-workprefix=DIR   prefix for work files [[PREFIX/work]]],
	[workprefix="$with_workprefix"],[workprefix="${prefix}/work"])

AC_ARG_WITH(bootprefix,
	[  --with-bootprefix=DIR   prefix for boot files [[PREFIX/cdkroot-tftpboot]]],
	[bootprefix="$with_bootprefix"],[bootprefix="${prefix}/cdkroot-tftpboot"])

buildprefix=`pwd`
AC_SUBST(targetprefix)
AC_SUBST(hostprefix)
AC_SUBST(workprefix)
AC_SUBST(buildprefix)
AC_SUBST(bootprefix)


$INSTALL -d ${workprefix}

packagingtmpdir=$buildprefix/packagingtmpdir
ipkgbuilddir=$buildprefix/ipkgbuild
PKDIR=$packagingtmpdir
AC_SUBST(packagingtmpdir)
AC_SUBST(ipkgbuilddir)
AC_SUBST(PKDIR)

AC_ARG_WITH(archivedir,
	[  --with-archivedir=DIR   where to store downloaded files [[Archive/]]],
	[archivedir="$with_archivedir"],[archivedir="$buildprefix/Archive"])

AC_ARG_WITH(cvsdir,
	[  --with-cvsdir=DIR       where to find the cvs],
	[cvsdir="$with_cvsdir"],[cvsdir="NONE"])

AC_ARG_WITH(appsdir,
	[  --with-appsdir=DIR      apps dir from cvs [[[CVS/]apps/]]],
	[appsdir="$with_appsdir"],[appsdir="NONE"])

AC_ARG_WITH(driverdir,
	[  --with-driverdir=DIR    driver dir from cvs [[[CVS/]driver]]],
	[driverdir="$with_driverdir"],[driverdir="NONE"])

if test "$cvsdir" = "NONE"; then
	if test "$appsdir" = "NONE"; then
		appsdir="$buildprefix/apps"
	fi
	if test "$driverdir" = "NONE"; then
		driverdir="$buildprefix/driver"
	fi
else
	if test "$appsdir" = "NONE"; then
		appsdir="$cvsdir/apps"
	fi
	if test "$driverdir" = "NONE"; then
		driverdir="$cvsdir/driver"
	fi
fi


dircheck="ok"
AC_MSG_CHECKING([for apps directory])
if test ! -f "$appsdir/acinclude.m4" ; then
	AC_MSG_WARN([appsdir $appsdir not found])
	appsdir="missing_appsdir"
	dircheck="fail"
else
	AC_MSG_RESULT([yes])
fi

AC_MSG_CHECKING([for driver directory])
if test ! -f "$driverdir/Makefile" ; then
	AC_MSG_WARN([driverdir $driverdir not found])
	driverdir="missing_driverdir"
	dircheck="fail"
else
	AC_MSG_RESULT([yes])
fi

AC_SUBST(appsdir)
AC_SUBST(driverdir)

AC_SUBST(archivedir)
AC_SUBST(srcdir)

AC_PATH_PROG(M4,m4,no)
if test "$M4" = "no"; then
	AC_MSG_WARN(No m4 found)
fi

AC_PATH_PROG(BZIP2,bzip2,no)
if test "$BZIP2" = "no"; then
	AC_MSG_WARN(No bzip2 found)
fi

AC_PATH_PROG(MAKEINFO,makeinfo,no)
if test "$MAKEINFO" = "no"; then
	AC_MSG_WARN(No makeinfo found)
fi

AC_PROG_CXX
if test "$CXX" = "g++" -a "$GXX" != "yes"; then
	AC_MSG_ERROR(No g++ found)
fi

AC_PROG_LEX
if test "$LEX" != "flex"; then
	AC_MSG_ERROR(No flex found)
fi

AC_PROG_YACC
if test "$YACC" != "bison -y"; then
	AC_MSG_ERROR(No bison found)
fi

if test "$enable_ccache" = "yes"; then
	AC_PATH_PROG(CCACHE,ccache,no)
	if test "$CCACHE" = "no"; then
		AC_MSG_WARN(No ccache found)
		CCACHE=$hostprefix/bin/ccache
	fi
fi


CLEANUP="rm -rf"
AC_SUBST(CLEANUP)

DEPSCLEANUP="rm -f"
AC_SUBST(DEPSCLEANUP)

RPMDEPSCLEANUP="rm -f"
AC_SUBST(RPMDEPSCLEANUP)

DISTCLEANUP="rm -rf"
AC_SUBST(DISTCLEANUP)

#
# core
#

AC_SUBST(EXTERNALLCD_DEP)

if test "$enable_externallcd" == "yes"; then
	EXTERNALLCD="yes"
	EXTERNALLCD_DEP="graphlcd"
else
	EXTERNALLCD="no"
	EXTERNALLCD_DEP=""
fi

AC_SUBST(MEDIAFW)
AC_SUBST(MEDIAFW_DEP)

if test "$enable_mediafwgstreamer" == "yes"; then
	MEDIAFW="gstreamer"
	MEDIAFW_DEP="gst_plugins_dvbmediasink"
else
	MEDIAFW="eplayer3"
	MEDIAFW_DEP="libeplayer3"
fi

AC_SUBST(GRAPHICFW)
AC_SUBST(GRAPHICFW_DEP)

if test "$enable_graphicfwdirectfb" == "yes"; then
	GRAPHICFW="directfb"
	GRAPHICFW_DEP="directfb"
else
	GRAPHICFW="framebuffer"
	GRAPHICFW_DEP=""
fi

#
# RPM stuff
#
configprefix=$prefix/config
crossprefix=$prefix/devkit/sh4
devkitprefix=$prefix/devkit
rpmdbprefix=${targetprefix}-rpmdb
kernelprefix=$buildprefix
AC_SUBST(crossprefix)
AC_SUBST(configprefix)
AC_SUBST(devkitprefix)
AC_SUBST(rpmdbprefix)
AC_SUBST(kernelprefix)

#
# localmacros
#
$INSTALL -d SOURCES SPECS SRPMS RPMS/{noarch,${host_arch},sh4}
test -f config && rm config || true
ln -sf $configprefix/rpm config || true
echo "%_topdir $buildprefix" >localmacros
echo "%_specdir %_topdir/SPECS" >>localmacros
echo "%_sourcedir %_topdir/SOURCES" >>localmacros
echo "%_builddir $workprefix" >>localmacros
echo "%_buildrootdir %_topdir/BUILDROOT" >>localmacros
echo "%buildroot %_topdir/BUILDROOT/%{name}-%{version}-%{release}.${host_arch}" >>localmacros
echo "%_rpmdir %_topdir/RPMS" >>localmacros
echo "%_srcrpmdir %_topdir/SRPMS" >>localmacros
echo "%_stm_install_prefix $prefix/.." >>localmacros
echo "%_stm_base_prefix $prefix" >>localmacros
echo "%_stm_host_dir $hostprefix" >>localmacros
echo "%_stm_cross_dir $crossprefix" >>localmacros
echo "%_stm_config_dir $configprefix" >>localmacros
echo "%_stm_devkit_dir $devkitprefix" >>localmacros
echo "%_stm_cross_target_dir $targetprefix" >>localmacros
echo "%_stm_kernel_dir $kernelprefix" >>localmacros
echo "%_stm_sources_dir $kernelprefix" >>localmacros
echo "%_stm_host_arch ${host_arch}" >>localmacros
echo "%_stm_host_cpu ${host_cpu}" >>localmacros
echo "%_stm_host_config ${host_alias:-${host}}" >>localmacros
echo "%_dbpath $rpmdbprefix" >>localmacros
echo "%__bzip2 $BZIP2" >>localmacros
echo "%nohostbuilddeps 1" >> localmacros
echo "%_default_patch_fuzz 2" >> localmacros

# Determine how to pass options to rpm, depending on version and distribution
macrofiles="/usr/lib/rpm/macros:$configprefix/rpm/targets/sh4-linux:$configprefix/rpm/common:$buildprefix/localmacros"

RPMMAJOR=`rpm --version | awk '{print $NF}' | cut -d '.' -f 1`
RPMMINOR=`rpm --version | awk '{print $NF}' | cut -d '.' -f 2`

if test ${RPMMAJOR} -lt 4 -o ${RPMMAJOR} -eq 4 -a ${RPMMINOR} -lt 7 ; then
  # RPM < 4.7
  echo "macrofiles: ${macrofiles}" > localrc
  DRPMBUILD="--rcfile /usr/lib/rpm/rpmrc:localrc"
  DRPM=${DRPMBUILD}
else
  # RPM > 4.7
  DRPMBUILD="--macros ${macrofiles}"
  case `lsb_release -s -i` in
    Ubuntu* | Debian* ) DRPM="--force-debian ${DRPMBUILD}" ;;
    *) DRPM=${DRPMBUILD} ;;
  esac
fi

AC_SUBST(DRPM)
AC_SUBST(DRPMBUILD)

#
# internal
#


#
# summary
#

AC_MSG_RESULT([
summary:
-------------------------------------------------------------------------------
target cpu/boxtype          : $CPU_MODEL / $BOXTYPE
STLinux 2.4                 : $enable_stm24
GCC 4.8.2                   : $enable_gcc48
Patchlevel P0207            : $enable_p0207
Patchlevel P0209            : $enable_p0209
Patchlevel P0210            : $enable_p0210
Patchlevel P0211            : $enable_p0211
Patchlevel P0212            : $enable_p0212
vdr VDR 1.7.22              : $enable_vdr1722
vdr VDR 1.7.27              : $enable_vdr1727
ccache                      : $enable_ccache
target prefix               : $targetprefix
boot prefix                 : $bootprefix
host prefix                 : $hostprefix
cross prefix                : $crossprefix
build prefix                : $buildprefix
root partition size         : $ROOT_PARTITION_SIZE
data partition size         : $DATA_PARTITION_SIZE
serversupport               : $serversupport
checkImage                  : $CHECKIMAGE_BEHAVIOR
target apps directory       : $appsdir
driver directory            : $driverdir
customization directory     : $customizationsdir
archive directory           : $archivedir
spider-box hl101 stuff      : $enable_hl101
spark box stuff             : $enable_spark
spark7162 box stuff         : $enable_spark7162
XFS support for IDE         : $enable_xfs
NFS server                  : $enable_nfsserver
Samba Clients               : $enable_cifs
NTFS support for IDE        : $enable_ntfs
sg3 utils                   : $enable_sg3
DEBUG                       : $enable_debug
Player179                   : $enable_player179
Player191                   : $enable_player191
Multicom406                 : $enable_multicom406
Multicom324                 : $enable_multicom324
MediaFw Gstreamer           : $enable_mediafwgstreamer
MediaFw                     : $MEDIAFW
MediaFw Dep                 : $MEDIAFW_DEP
GraphicFw DirectFB          : $enable_graphicfwdirectfb
GraphicFw                   : $GRAPHICFW
GraphicFw Dep               : $GRAPHICFW_DEP
EXTERNALLCD                 : $enable_externallcd
EXTERNALLCD_DEP             : $EXTERNALLCD_DEP
])

if test "$dircheck" = "fail"; then
AC_MSG_RESULT([
******************************************************************
*                       !!!WARNING!!!                            *
* one or more of your CVS source directories could not be found, *
* (for details see above), did you maybe supply an incorrect     *
*  --with-cvsdir argument to configure?                          *
*                       !!!WARNING!!!                            *
******************************************************************
])
fi

ac_subst_vars='m4_set_dump([_AC_SUBST_VARS], m4_newline)'
echo $ac_subst_vars |perl -pe 's/ /\n/g' |perl -pe 's/(.*)/\1 = @\1@/' > Config.in

AC_CONFIG_FILES([
Makefile\
:Config.in\
:Makefile.in\
:make/buildenv.mk\
:packaging.mk\
:make/archive-specs.mk\
:make/hostapps.mk\
:make/u-boot.mk\
:make/linux-kernel.mk\
:make/bare-os.mk\
:make/bootstrap.mk\
:make/root-etc.mk\
:make/busybox.mk\
:make/contrib-libs.mk\
:make/contrib-apps-specs.mk\
:make/contrib-apps.mk\
:make/net-apps.mk\
:make/misc_tools.mk\
:make/enigma2-plugins.mk\
:make/externe-plugins.mk\
:make/externe-skins.mk\
:make/xbmc-nightly.mk\
:make/enigma2-pli-nightly.mk\
:make/neutrino.mk\
:make/neutrino_hd2.mk\
:make/yaud.mk\
:make/misc-specs.mk\
:make/cleantargets.mk\
:make/tags.mk\
:make/emulators.mk\
:make/smart_release.mk\
:make/smart_release_xbmc.mk\
:make/release_neutrino.mk\
:make/release_neutrino_nightly.mk\
:make/smart_release_vdr.mk\
:make/vdr.mk\
:make/update.mk
], [mv Makefile Makefile.pre; ./smart-rules.pl Makefile.pre])

AC_OUTPUT
