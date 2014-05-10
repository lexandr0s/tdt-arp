Summary: GNU Compiler Collection
Name: %{_stm_pkg_prefix}-cross-gcc
%if %target_cpu sh
Version: 4.7.3
%else
%if %target_cpu arm
Version: 4.7.3
%else
Version: 4.2.4
%endif
%endif

Release: 124
License: GPL/LGPL
Group: Development/Languages
Buildroot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-%{_stm_target_arch}-XXXXXX)
Prefix: %{_stm_install_prefix}
Source0: ftp://ftp.gnu.org/pub/gnu/gcc/gcc-%{version}/gcc-%{version}.tar.bz2
Source3: gcc-protoize.1

# SH4 common
Patch100: gcc-4.7.3-stm-130807.patch
Patch101: gcc-4.7.0-sh-use-gnu-hash-style.patch
Patch102: gcc-4.2.4-multilibpath.patch
Patch104: gcc-4.5.2-sysroot.patch

# SH4 uClibc
Patch200: gcc-4.7.0-uclibc-locale.patch
Patch201: gcc-4.2.4-uclibc-missing-execinfo_h.patch
Patch202: gcc-4.2.4-uclibc-snprintf.patch
Patch203: gcc-4.2.4-uclibc-libstdc++-namespace.patch
Patch205: gcc-4.3.4-uclibc-locale_facets.patch
Patch207: gcc-4.3.4-uclibc-libstdc++_headers.patch
Patch208: gcc-4.3.4-libmudflap-susv3-legacy.patch

# ARM uClibc

# ARM patches
Patch300: gcc-4.7.3-linaro-4.7-2013.06-1.patch
Patch301: gcc-4.7.3-linaro-4.7-2013.06-1-st.patch
Patch302: gcc-4.5.1-arm-use-gnu-hash-style.patch
Patch303: gcc-4.7.3-replace-474-with-473.patch
Patch304: gcc-4.7.3-bugzilla-36994.patch

# General patches
Patch1: gcc-4.7.3-stack-protect-strong.patch

%define _docdir          %{_stm_cross_doc_dir}
BuildRequires: %{_stm_pkg_prefix}-host-rpmconfig %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-binutils
BuildRequires: %{_stm_pkg_prefix}-%{_stm_target_arch}-kernel-headers
BuildRequires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-mpfr
BuildRequires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-gmp
BuildRequires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-mpc
BuildArch: %{_stm_host_arch}

%define _gcc_pkgname %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-gcc
%define _gpp_pkgname %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-g++
%define _cpp_pkgname %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-cpp
%define _protoize_pkgname %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-protoize
%define _libgcc_pkgname %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-libgcc

%define _gccdir %{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}

%description
This is the GNU C compiler, a fairly portable optimizing compiler which
supports multiple languages.  This package includes support for C, and
C++.

# gcc
%package -n %{_gcc_pkgname}
Summary: The GNU C Compiler.
Group: Development/Languages
Provides: %{_stm_pkg_prefix}-generic-%{_stm_target_arch}-gcc
Requires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-binutils >= 2.17
Requires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-cpp = %{version}
%if %target_arch sh4 st231
Requires: %{_stm_pkg_prefix}-%{_stm_target_arch}-glibc-dev
%endif

%if %target_arch_uclibc
Requires: %{_stm_pkg_prefix}-%{_stm_target_arch}-uclibc-nptl-dev
%else
Requires: %{_stm_pkg_prefix}-%{_stm_target_arch}-glibc-dev
%endif

Obsoletes: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-gcc-bootstrap
Obsoletes: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-gcc-bootstrap-libgcc
%description -n %{_gcc_pkgname}
This is the GNU C version 4 compiler, a fairly portable optimizing compiler which
supports multiple languages.  This package includes support for C.

# cpp
%package -n %{_cpp_pkgname}
Summary: The GNU C preprocessor.
Group: Development/Languages
Provides: %{_stm_pkg_prefix}-generic-%{_stm_target_arch}-cpp
%description -n %{_cpp_pkgname}
The GNU C preprocessor is required by some utilities that use it for
macro substitutions. This package has been separated from gcc for
the benefit of those who require the preprocessor but not the
compiler.

# cpp-doc
%package -n %{_cpp_pkgname}-doc
Summary: Documentation for the GNU C preprocessor (cpp).
Group: Documentation/Development
%description -n %{_cpp_pkgname}-doc
Documentation for the GNU C preprocessor in info format.

# g++
%package -n %{_gpp_pkgname}
Summary: The GNU C++ compiler.
Group: Development/Languages
Provides: %{_stm_pkg_prefix}-generic-%{_stm_target_arch}-g++
Requires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-gcc = %{version}
%description -n %{_gpp_pkgname}
This is the GNU C++ version 4 compiler, a fairly portable optimizing compiler for C++.

# protoize
%package -n %{_protoize_pkgname}
Summary: Create/remove ANSI prototypes from C code
Group: Development/Tools
Provides: %{_stm_pkg_prefix}-generic-%{_stm_target_arch}-protoize
Requires: %{_stm_pkg_prefix}-cross-%{_stm_target_arch}-gcc = %{version}
%description -n %{_protoize_pkgname}
'protoize' can be used to add prototypes to a program, thus converting
the program to ANSI C in one respect.  The companion program 'unprotoize'
does the reverse: it removes argument types from any prototypes
that are found.

# gcc-doc
%package -n %{_gcc_pkgname}-doc
Summary: Documentation for the GNU compilers (gcc, gobjc, g++).
Group: Documentation/Development
%description -n %{_gcc_pkgname}-doc
Documentation for the GNU compilers in info format.

# libgcc
# This should really be a target package, but we need it here as later the
# target binutils and gcc build depends on it.
%package -n %{_libgcc_pkgname}
Summary: GCC version %{version} shared support library.
Group: Development/Languages
%description -n %{_libgcc_pkgname}
Some GCC version %{version} and later compiled libraries and/or binaries
need this shared support library.

##############################################################################
%prep
%setup -n gcc-%{version} -q

# SH4 common patches
%if %target_cpu sh
%patch100 -p1
%patch101 -p1
%patch102 -p1
%patch104 -p1
%endif

# SH4 uClibc patches
%if %target_arch sh4_uclibc
%patch200 -p1
%patch201 -p1
%patch202 -p1
%patch203 -p1
%patch205 -p1
%patch207 -p1
%patch208 -p1
%endif

# ARM patches
%if %target_cpu arm
%patch300 -p1
%patch301 -p1
%patch302 -p1
%patch303 -p1
%patch304 -p1
%endif

# Common patches
%patch1 -p1

echo 'STMicroelectronics/Linux Base %{version}-%{release}' > gcc/DEV-PHASE

# Update configure in the gcc directory
(cd gcc && autoconf)

##############################################################################

%build
%cross_setup

%cross_configure \
        --program-prefix=%{_stm_target_toolprefix} \
        --with-local-prefix=%{_stm_cross_dir} \
        --with-sysroot=%{_stm_cross_target_dir} \
	--enable-target-optspace \
        --enable-languages=c \
        --enable-threads=posix \
        --disable-libmudflap \
       --disable-libssp \
       --disable-libquadmath \
       --without-headers \
%if %target_cpu arm
	--disable-multilib \
%endif
        --enable-nls \
        --enable-c99 \
        --enable-long-long \
        --with-system-zlib \
	--disable-shared \
%if "%{_stm_target_arch}" != "armv7" && "%{_stm_target_arch}" != "armv7_uclibc"
	--disable-libgomp \
%endif
        --with-pkgversion="GCC" \
        --with-bugurl="https://bugzilla.stlinux.com" \
	--disable-libitm \
%if %target_cpu sh
	--enable-multilib \
	--disable-multi-sysroot \
	--with-multilib-list=m4-nofpu \
        --enable-lto \
%endif
%if %target_arch_uclibc
	--with-included-gettext \
%else
        --enable-symvers=gnu \
%endif
	--with-mpc=%{_stm_cross_dir} \
        --with-gmp=%{_stm_cross_dir} \
        --with-mpfr=%{_stm_cross_dir} \
        --without-ppl \
        --with-gxx-include-dir="\\\${prefix}/target%{_stm_target_include_dir}/c++/%{version}" \
        --enable-__cxa_atexit \
%if "%{_stm_target_fpu}" == "no"
%if %target_arch sh4_uclibc
        --without-fp \
%else
        --with-float=soft \
	--enable-cxx-flags=-msoft-float \
%endif
%else
%if %target_arch armv7 armv7_uclibc
        --with-float=hard \
        --with-fp \
	--enable-cxx-flags=-mhard-float \
%else
%if %target_arch armv6 armv6_uclibc
        --with-float=soft \
	--enable-cxx-flags=-mfloat-abi=softfp \
%endif
%endif
%endif
%if %target_cpu arm
%if %target_arch_no_uclibc
        --with-tls=gnu2 \
%endif
%endif
%if "%{_stm_target_cpu_id}" != "%%%%{_stm_target_cpu_id}"
        --with-cpu=%{_stm_target_cpu_id} \
%endif
%if "%{_stm_target_gcc_config}" != "%%%%{_stm_target_gcc_config}"
        %{_stm_target_gcc_config} \
%endif
        && true

%make all

##############################################################################
%install
%cross_setup
%cross_makeinstall

%if %target_cpu sh arm
%make pdf html

install -d %{buildroot}/%{_stm_cross_doc_dir}/html
install -d %{buildroot}/%{_stm_cross_doc_dir}/pdf
# cp gcc/doc/*.pdf %{buildroot}/%{_stm_cross_doc_dir}
# cp -r gcc/HTML/gcc-%{version} %{buildroot}/%{_stm_cross_doc_dir}/html
%endif

cd ..

%compress_man %{buildroot}%{_stm_cross_info_dir}
%compress_man %{buildroot}%{_stm_cross_man_dir}

# Install copies of the driver programs into $(gcc_tooldir)
# (and libdir, for cpp).
install -d %{buildroot}/%{_stm_cross_targetconf_dir}/bin
install -d %{buildroot}/%{_stm_cross_targetconf_dir}/lib
%if %target_cpu sh
install -d %{buildroot}/%{_stm_cross_targetconf_dir}/lib/m4-nofpu
%endif

# Symlinks for relocation
ln -s ../../bin/%{_stm_target_toolprefix}gcc \
	%{buildroot}/%{_stm_cross_targetconf_dir}/bin/cc
ln -s ../../bin/%{_stm_target_toolprefix}gcc \
	%{buildroot}/%{_stm_cross_targetconf_dir}/bin/gcc
ln -s ../../bin/%{_stm_target_toolprefix}gcov \
	%{buildroot}/%{_stm_cross_targetconf_dir}/bin/gcov
ln -s ../../bin/%{_stm_target_toolprefix}g++ \
	%{buildroot}/%{_stm_cross_targetconf_dir}/bin/c++
ln -s ../../bin/%{_stm_target_toolprefix}g++ \
	%{buildroot}/%{_stm_cross_targetconf_dir}/bin/g++
ln -s ../../bin/%{_stm_target_toolprefix}cpp \
	%{buildroot}/%{_stm_cross_targetconf_dir}/bin/cpp
ln -s ../../bin/%{_stm_target_toolprefix}cpp \
	%{buildroot}/%{_stm_cross_targetconf_dir}/lib/cpp

mkdir -p %{buildroot}%{_stm_cross_target_dir}/lib
ln -s libgcc_s-%{version}.so.1 \
	%{buildroot}%{_stm_cross_target_dir}/lib/libgcc_s.so.1

mv %{buildroot}%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/include-fixed/* \
	%{buildroot}%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/include/

%find_lang gcc

##############################################################################
%clean
rm -rf %{buildroot}

##############################################################################
%files -n %{_gcc_pkgname} -f gcc.lang
%defattr(-,root,root)
%if %target_cpu sh arm
%{_stm_cross_bin_dir}/%{_stm_target_toolprefix}gcc-ar
%{_stm_cross_bin_dir}/%{_stm_target_toolprefix}gcc-nm
%{_stm_cross_bin_dir}/%{_stm_target_toolprefix}gcc-ranlib
%endif
%{_stm_cross_bin_dir}/%{_stm_target_toolprefix}gcc
%{_stm_cross_bin_dir}/%{_stm_target_toolprefix}gcc-%{version}
%{_stm_cross_bin_dir}/%{_stm_target_toolprefix}gcov
%{_stm_cross_targetconf_dir}/bin/cc
%{_stm_cross_targetconf_dir}/bin/gcc
%{_stm_cross_targetconf_dir}/bin/gcov
%dir %{_stm_cross_lib_dir}/gcc
%dir %{_stm_cross_lib_dir}/gcc/%{_stm_target_config}
%dir %{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}

%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/include/

%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/libgcc.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/libgcov.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/crt*

%if %target_cpu sh
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/libgcc-4-200.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/libgcc-4-300.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/libgcc-Os-4-200.a

%dir %{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu/libgcc.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu/libgcc-4-200.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu/libgcc-4-300.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu/libgcc-Os-4-200.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu/libgcov.a
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/m4-nofpu/crt*
%endif

%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/liblto_plugin.la
%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/liblto_plugin.so*
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/plugin/include/
%{_stm_cross_lib_dir}/gcc/%{_stm_target_config}/%{version}/plugin/gtype.state
%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/plugin/gengtype

%if %target_arch armv7 armv7_uclibc
%{_stm_cross_targetconf_dir}/lib/libgomp.a
%{_stm_cross_targetconf_dir}/lib/libgomp.la
%{_stm_cross_targetconf_dir}/lib/libgomp.so
%{_stm_cross_targetconf_dir}/lib/libgomp.so.1
%{_stm_cross_targetconf_dir}/lib/libgomp.so.1.0.0
%{_stm_cross_targetconf_dir}/lib/libgomp.spec
%{_stm_cross_dir}/info/libgomp.info.gz
%endif

%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/lto-wrapper
%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/lto1

%dir %{_stm_cross_libexec_dir}/gcc
%dir %{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}
%dir %{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}
%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/cc1
%{_stm_cross_libexec_dir}/gcc/%{_stm_target_config}/%{version}/collect2
%{_stm_cross_man_dir}/man1/%{_stm_target_toolprefix}gcc.1.gz
%{_stm_cross_man_dir}/man1/%{_stm_target_toolprefix}gcov.1.gz

%doc COPYING COPYING.LIB ABOUT-NLS README

%files -n %{_protoize_pkgname}
%defattr(-,root,root)

%files -n %{_gcc_pkgname}-doc
%defattr(-,root,root)
%{_stm_cross_info_dir}/gcc.info.gz
%{_stm_cross_man_dir}/man7/*

%if %target_cpu sh
%{_stm_cross_doc_dir}/*
%endif

%post -n %{_cpp_pkgname}-doc
install-info --quiet --dir-file=%{_stm_cross_info_dir}/dir \
	%{_stm_cross_info_dir}/cpp.info

%preun -n %{_cpp_pkgname}-doc
install-info --quiet --dir-file=%{_stm_cross_info_dir}/dir --remove \
	%{_stm_cross_info_dir}/cpp.info

%post -n %{_gcc_pkgname}-doc
install-info --quiet --dir-file=%{_stm_cross_info_dir}/dir \
	%{_stm_cross_info_dir}/gcc.info

%preun -n %{_gcc_pkgname}-doc
install-info --quiet --dir-file=%{_stm_cross_info_dir}/dir --remove \
	%{_stm_cross_info_dir}/gcc.info

%changelog
* Thu Oct 02 2013 Laurent Alfonsi <laurent.alfonsi@st.com> 124
- [Add patch: gcc-4.7.3-bugzilla-36994.patch]

* Thu Aug 08 2013 Christian Bruel <christian.bruel@st.com> 123
- [Add patch: gcc-4.7.3-stm-130807.patch]
- [Delete patch: gcc-4.7.3-stm-130514.patch]

* Fri Aug 02 2013 Christian Bruel <christian.bruel@st.com> 122
- [Add patch: gcc-4.7.3-stack-protect-strong.patch: Bugzilla 10391]
  RFE: Add -fstack-protector-strong option.

* Thu Jul 10 2013 Laurent Alfonsi <laurent.alfonsi@st.com> 121
- [Update: 4.7.3] Upgrade ARM to gcc 4.7.3.
- [Add patch: gcc-4.7.3-linaro-4.7-2013.06-1.patch] Add Linaro 2013.06-1 improvements.
- [Add patch: gcc-4.7.3-linaro-4.7-2013.06-1-st.patch] Add ST patches.
- [Add patch: gcc-4.7.3-replace-474-with-473.patch] Keep GCC version at 4.7.3.

* Wed May 14 2013 Christian Bruel <christian.bruel@st.com> 120
- [Update: 4.7.3] Upgrade SH4 to gcc 4.7.3-stm-130514.
- [Delete patch:] gcc-4.7.2-stm-130218.patch
- [Delete patch:] gcc-4.7.0-uclibc-libstdc++_no_nls.patch

* Wed Mar 27 2013 Christophe Lyon <christophe.lyon@st.com> 119
- [Spec] Restore --disable-gomp on armv5/armv6.
  gomp is enabled on armv7 only.

* Tue Mar 26 2013 Bruel Christian <christian.bruel@st.com> 118
- [Spec] Remove libelf dependencies and use %%if_target_cpu.

* Mon Feb 25 2013 Francesco Virlinzi <francesco.virlinzi@st.com> 117
- [Spec; Bugzilla: 23138] Make compatible with rpm-build 4.10.

* Wed Feb 20 2013 Christophe Lyon <christophe.lyon@st.com> 116
- [Update: 4.7.2] Upgrade ARM to gcc 4.7.2.
- [Add patch: gcc-4.7.2-linaro-4.7-2013.01.patch] Add Linaro 2013.01 improvements.
- [Add patch: gcc-4.7.2-linaro-4.7-2013.01-st.patch] Add ST patches.
- [Add patch: gcc-4.7.2-replace-473-with-472.patch] Keep GCC version at 4.7.2.
- [Add patch: gcc-4.7.2-arm-vld1q_dup_s64.patch] Fix vld1q_dup_s64.

* Mon Feb 18 2013 Christian Bruel <christian.bruel@st.com> 115
- [Update: 4.7.2] Upgrade SH4 to gcc 4.7.2-stm-130218.
- [Delete patch: gcc-4.7.2-stm-121106.patch]

* Wed Jan 16 2013 Christian Bruel <christian.bruel@st.com> 114
- [Add patch: gcc-4.7.2-sp-switch.patch; Bugzilla 25892].
- [Spec] Cleanup if_target_arch sh uses.
- [Spec] Fix cross-host configure header paths.

* Tue Dec 10 2012 Laurent Alfonsi <laurent.alfonsi@st.com> 113
- [Add patch: gcc-4.7.2-fix-bugzilla_24977.patch; Bugzilla: 24977]

* Tue Nov 06 2012 Christian Bruel <christian.bruel@st.com> 112
- [Update: 4.7.2] Upgrade SH4 to gcc 4.7.2-stm-120613.
- [Add patch: gcc-4.7.2-stm-121106.patch]
- [Delete patch: gcc-4.6.2-stm-120618.patch]

* Mon Oct 29 2012 Christian Bruel <christian.bruel@st.com> 111
- [Replace patch: gcc-4.6.3-pr23233.patch; Bugzilla: 23233/23794] New implementation.

* Mon Oct 22 2012 Christian Bruel <christian.bruel@st.com> 110
- [Add patch: gcc-4.6.3-pr23233.patch; Bugzilla: 23233] Fix R0 spill with -fstack-protector-all

* Fri Oct 19 2012 Christian Bruel <christian.bruel@st.com> 109
- [Add patch: gcc-4.6.3-gimpleassert.patch]. Nenecessary to build the kernel with --enable-checking=yes.

* Tue Jun 25 2012 Christophe Lyon <christophe.lyon@st.com> 109
- [Add patch: gcc-4.6.3-arm-vld1q_dup_s64.patch] Fix vld1q_dup_s64.

* Fri Jun 18 2012 Christian Bruel <christian.bruel@st.com> 108
- [Update: 4.6.3-stm-120618] Upgrade ST40 compiler.
- [Add patch: gcc-4.6.3-stm-120618.patch]
- [Delete patch: gcc-4.6.2-stm-120313.patch]

* Mon Jun 11 2012 Christian Bruel <christian.bruel@st.com> 107
- [Add patch: gcc-4.6.3-pr19749; Bugzilla: 19749] Fix GOT constant pool.

* Fri Jun 1 2012 Christophe Lyon <christophe.lyon@st.com> 106
- [Add patch: gcc-4.6.3-arm-zero-extend-fix-mini-pool.patch] Fix
  zero_extend patterns with mini_pool data.

* Fri May 25 2012 Yvan Roux <yvan.roux@st.com> 105
- [Add patch: gcc-4.6.3-fix-bugzilla_16032.patch; Bugzilla: 16032] Backport
  GCC bugzilla 48308 and dependencies.

* Thu Apr 26 2012 Christian Bruel <christian.bruel@st.com> 104
- [Add patch: gcc-4.6.3-braf; Bugzilla: 18466] Fix max braf offset and add .fill suport in address computation.

* Tue Apr 17 2012 Christophe Lyon <christophe.lyon@st.com> 103
- [Update: 4.6.3] Upgrade ARM to GCC 4.6.3.
- [Add patch: gcc-4.6.3-linaro-4.6-2012.03.patch] Merge with Linaro
  2012.03 improvements.
- [Add patch: gcc-4.6.3-pr52765.patch] Make sure CFLAGS_FOR_TARGET and
  CXXFLAGS_FOR_TARGET contain -O2.
- [Add patch: gcc-4.6.3-pr52868.patch] Backport fix for GCC bugzilla
  52686: SLP crashes with WIDEN_LSHIFT_EXPR .

* Wed Mar 14 2012 Christian Bruel <christian.bruel@st.com> 102
- [Update: 4.6.3] Upgrade SH to GCC 4.6.3.
- [Add patch: gcc-4.6.3-stm-120313.patch]
- [Delete patch: gcc-4.6.2-stm-120229.patch]

* Fri Mar 9 2012 Christophe Lyon <christophe.lyon@st.com> 101
- [Spec] Fix build for SH.

* Thu Mar 8 2012 Christophe Lyon <christophe.lyon@st.com> 101
- [Add patch: gcc-4.6.2-linaro-4.6-2012.02.patch] Add Linaro 2012.02
  improvements.
- [Add patch: gcc-4.6.2-linaro-4.6-2012.02-st.patch] Merge ST patches.
- [Add patch: gcc-4.6.2-replace-463-with-462.patch] Keep GCC version at 4.6.2.

* Tue Feb 29 2012 Christian Bruel <christian.bruel@st.com> 100
- [Update: 4.6.2] Upgrade SH to GCC 4.6.2.
- [Add patch: gcc-4.6.2-stm-120229.patch]
- [Delete patch: gcc-4.5.3-stm-111123.patch]

* Fri Feb 17 2012 Christian Bruel <christian.bruel@st.com> 99
- [Add Patch: gcc-4.5.3-sh-atomic.patch] Support for builtin atomic routines.
   Add 'u' constraint for inlined gUSA asm.

* Tue Jan 31 2012 Christophe Lyon <christophe.lyon@st.com> 98
- [Add patch: gcc-4.6.2-arm-tlsdesc.patch; Bugzilla: 16310] Backport
  patch for TLS descriptor support. Only for glibc C runtime.

* Thu Jan 26 2012 Christophe Lyon <christophe.lyon@st.com> 97
- [Add patch: gcc-4.6.2-arm-forward-mthumb.patch] Forward -mthumb to
  the assembler.

* Tue Dec 20 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 96
- [Spec] Fix build on RH5 host (with rpm v4.4.2.3) including
  liblto_plugin.so*

* Wed Dec 13 2011 Christophe Lyon <christophe.lyon@st.com> 95
- [Update: 4.6.2] Upgrade ARM to GCC 4.6.2.
- [Add patch: gcc-4.6.2-linaro-4.6-2011.08.patch] Add Linaro 2011.08 improvements.
- [Add patch: gcc-4.6.2-linaro-st.patch] Backport C++ patch for PR c++/50787.
- [Delete patch: gcc-4.5.1-codesourcery-2010.09.patch]
- [Delete patch: gcc-4.5.1-strict-volatile.patch]
- [Delete patch: gcc-4.5.0-arm-movt.patch]
- [Delete patch: gcc-4.5.1-arm-neon-postinc-predec.patch]
- [Delete patch: gcc-4.5.1-arm-pic-prologue-locator.patch]

* Fri Nov 25 2011 Christian Bruel <christian.bruel@st.com> 94
- [Add patch: gcc-4.5.3-stm-111123.patch] update SH4 to GCC 4.5.3-stm-111123.
- [Delete patch: gcc-4.5.3-stm-110525.patch]
- [Delete patch: gcc-4.5.3-stm-refaddr.patch]
- [Delete patch: gcc-4.5.3-bra_length.patch]
- [Delete patch: gcc-4.5.3-PR14098.patch]
- [Delete patch: gcc-4.5.3-atomic.patch]
- [Delete patch: gcc-4.5.3-always_inline-warn.patch]
- [Delete patch: gcc-4.5.3-always_inline.patch]
- [Delete patch: gcc-4.5.3-fldi1.patch]
- [Delete patch: gcc-4.5.3-fldi0.patch]

* Wed Oct 26 2011 Christian Bruel <christian.bruel@st.com> 93
- [Spec] Align --enable-target-optspace with stm-target-gcc and uclibc.

* Wed Oct 26 2011 Christian Bruel <christian.bruel@st.com> 93
- [Add patch: gcc-4.5.3-refaddr.patch; Bugzilla: 14812] Avoid infinite oscilations
   when evaluating a pessimistic branch address.

* Fri Oct 14 2011 Christophe Lyon <christophe.lyon@st.com> 92
- [Add patch: gcc-4.5.1-arm-pic-prologue-locator.patch; Bugzilla:
  14140] Fix source code location of instructions injected into the
  prologue.

* Tue Oct 06 2011 Christian Bruel <christian.bruel@st.com> 91
- [Add patch: gcc-4.5.3-bra_length.patch] Fix align and short branch length.

* Tue Sep 27 2011 Christian Bruel <christian.bruel@st.com> 90
- [Add patch: gcc-4.5.3-PR14098.patch; Bugzilla: 14098] Fix unsigned long long comparison.

* Fri Sep 23 2011 Salvatore Cro <salvatore.cro@st.com> 89
- [Spec] Package stdint.h for sh4_uclibc as well.
  Remove trailing white spaces.

* Tue Sep 06 2011 Christophe Lyon <christophe.lyon@st.com> 88
- [Add patch: gcc-4.5.2-sincos.patch] Add -fno-cse-sincos option for
  environments without glibc runtime on ARM.

* Fri Sep 02 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 87
- [Add patch: gcc-4.5.1-arm-use-gnu-hash-style.patch]
  Configure gcc to use gnu-hash style by default since now on.

* Fri Aug 26 2011 Christian Bruel <christian.bruel@st.com> 86
- [Add patch: gcc-4.5.3-atomic.patch; Bugzilla: 13795] Make sure to reread the original value when restarting the operation.

* Mon Aug 08 2011 Christian Bruel <christian.bruel@st.com> 85
- [Add patch: gcc-4.5.3-always-inline-warn.patch; Bugzilla: 13530] Generate a warning instead of an error for not honored always_inline attribute.

* Mon Aug 08 2011 Christian Bruel <christian.bruel@st.com> 85
- [Add patch: gcc-4.5.3-fldi1.patch] Fix wrong constant propagation for fld[0,1] instructions. Add -m[no-]fldi flag.

* Mon Aug 08 2011 Christian Bruel <christian.bruel@st.com> 84
- [Add patch: gcc-4.5.3-fldi0.patch] Fix wrong FPU mode for fldi0 instruction.

* Mon Aug 01 2011 Christophe Lyon <christophe.lyon@st.com> 84
- [Spec] Force name of the explicitly versioned gcc.

* Mon Jul 11 2011 Christian Bruel <christian.bruel@st.com> 83
- [Add patch: gcc-4.5.3-fldi0.patch] Fix wrong FPU mode for fldi0 instruction.

* Mon Jul 11 2011 Christian Bruel <christian.bruel@st.com> 82
- [Add patch: gcc-4.5.3-always-inline.patch] Fix -Winline and always_inline attribute.

* Tue Jun 28 2011 Christophe Lyon <christophe.lyon@st.com> 82
- [Add patch: gcc-4.5.1-arm-neon-postinc-predec.patch; Bugzilla 12585]
  Support POST_INC/PRE_DEC for neon struct modes.

* Fri Jun 17 2011 Christophe Lyon <christophe.lyon@st.com> 81
- [Update: 4.5.1] Upgrade ARM to GCC 4.5.1.
- [Add patch: gcc-4.5.1-codesourcery-2010.09.patch] Add Code Sourcery
  2010q3 improvements.
- [Add patch: gcc-4.5.1-strict-volatile.patch] Backport patch to fix
  volatile fields accesses.

* Tue Jun 8 2011 Christian Bruel <christian.bruel@st.com> 80
- [Update: 4.5.3] Upgrade SH to GCC 4.5.3.
- [Add patch: gcc-4.5.3-stm-110525.patch]
- [Delete patch: gcc-4.5.2-stm-110124.patch]
- [Delete patch: gcc-4.5.2-reload.patch]
- [Delete patch: gcc-4.5.2-float_const_r0.patch]
- [Spec]  Remove libelf dependency for SH.

* Thu May 26 2011 Christophe Lyon <christophe.lyon@st.com> 79
- [Add patch: gcc-4.5.0-arm-movt.patch] Fix constant format used with movt instruction.

* Wed Mar 16 2011 Christian Bruel <christian.bruel@st.com> 78
- [Add patch: gcc-4.5.2-float_const_r0.patch; Bugzilla: 11193] Fix bad reload constraints on r0 register.

* Wed Feb 15 2011 Christian Bruel <christian.bruel@st.com> 77
- [Add patch: gcc-4.5.2-reload.patch; Bugzilla: 11193] Fix bad reload constraints on system use register.

* Fri Feb 04 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 76
- [Spec] Fix post release changes> stdint.h not required only for sh4_uclibc

* Wed Feb 02 2011 Christian Bruel <christian.bruel@st.com> 76
- [Spec] Fix install after update. Cleanup "arm" && "sh" useless cpu tests.

* Fri Jan 28 2011 Christian Bruel <christian.bruel@st.com> 76
- [Update: 4.5.2] Upgrade sh4 to gcc-4.5.2-stm
- [Add patch: gcc-4.5.2-stm-110124.patch]
- [Remove patch: gcc-4.4.4-stm-100612.patch]
- [Remove patch: gcc-4.4.4-autoconf-version.patch]
- [Add patch: gcc-4.5.2-sysroot.patch]
- [Add patch: gcc-4.5.2-uclibc-locale.patch]
- [Spec] commonalize with arm

* Fri Jan 28 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 75
- [Spec] Add build support for armv[67]_uclibc

* Mon Jan 24 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 74
- [Spec] Fix build for armv7_uclibc by including mf-runtime.h in the file list.
  Use %%if_target_cpu instead of listing all sh4 and arm based stm_target_arch.

* Fri Jan 14 2011 Christian Bruel <christian.bruel@st.com> 74
- [Add patch: gcc-4.4.4-sincos.patch] Add -fno-cse-sincos option for
environments without glibc runtime.

* Tue Jan 11 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 73
- [Spec] Fix build for armv6_uclibc by including mf-runtime.h in the file list

* Mon Jan 10 2011 Carmelo Amoroso <carmelo.amoroso@st.com> 73
- [Spec] Fix build for armv5_uclibc by including mf-runtime.h in the file list
  Also remove duplicated listing of mf-runtime.h for armv7 arch.
  Shorten some changelog lines too long.

* Fri Nov 26 2010 Christian Bruel <christian.bruel@st.com> 72
- [Add patch: gcc-4.4.4-shorten.patch; Bugzilla: 10406] Fix constant pool
  distances while -g, that could introduce infinite loops with shorten-branch.

* Tue Nov 23 2010 Christophe Lyon <christophe.lyon@st.com> 71
- [Spec] Keep libgcc_s.so installed as a text file on all
  architectures.

* Mon Nov 08 2010 Christian Bruel <christian.bruel@st.com> 70
- [Add patch: gcc-4.4.4-picr0.patch; Bugzilla: 10391] Fix R0 spill failure in
  PIC and -fstack-protector for reg-alloc combine.

* Fri Nov  5 2010 Stuart Menefy <stuart.menefy@st.com> 69
- [Spec] Rework the inclusion of the RPM version and release in the
  gcc version information to match the technique used in gcc 4.4.

* Wed Oct 20 2010 Christian Bruel <christian.bruel@st.com> 68
- [Add patch: gcc-4.4.4-lrintf.patch] Implement __builtin_lrintf.

* Tue Aug 24 2010 Christian Bruel <christian.bruel@st.com> 67
- [Spec] configure with --with-pkgversion and --with-bugurl for SH.
- [Remove patch: gcc-4.4.4-stm-version.patch]
- [Add patch: gcc-4.4.4-regrename.patch] Support for copy propagation on SH.

* Wed Jul 21 2010 Christian Bruel <christian.bruel@st.com> 67
- [Add patch: gcc-4.4.4-bug9620.patch; Bugzilla: 9620] Update alignement after barrier
  to avoid out of range constant pools.

* Fri Jul 16 2010 Christian Bruel <christian.bruel@st.com> 66
- [Add patch: gcc-4.4.4-autoconf-version.patch] Allow autoconf 2.64.

* Thu Jul 15 2010 Christian Bruel <christian.bruel@st.com> 66
- [Spec] Add mpc dependency.

* Mon Jul 12 2010 Christian Bruel <christian.bruel@st.com> 66
- [Spec] Factorize gmp and mpfr configure options.
- [Spec] Move CC definition to common cross_setup macro.
- [Spec] Add BuildRequires gmp and mpfr packages.

* Wed Jul 09 2010 Christian Bruel <christian.bruel@st.com> 66
- [Add patch: gcc-4.4.4-notas.patch]. Add -mtas -mno-tas options.

* Mon Jul 05 2010 Christian Bruel <christian.bruel@st.com> 65
- [Add patch: gcc-4.4.4-asm-doc.patch] Document -mnotas. Document SH asm registers.
- [Spec] make and install pdf and html documentation for SH4.

* Mon Jun 28 2010 Christian Bruel <christian.bruel@st.com> 65
- [Add patch: gcc-4.4.4-stm-100612.patch] Changelogs and copyright license cleanups,
  fix sync_nand_and_fetch, testsuite improvements.
- [Remove patch: gcc-4.4.4-stm-100610.patch]
- [Remove patch: gcc-4.4.4-warn-finite.patch]

* Tue Jun 11 2010 Christian Bruel <christian.bruel@st.com> 65
- [Add patch: gcc-4.4.4-warn-finite.patch] Warn for infinite/nan floating points
  operations are used with -ffinite-math-only

* Fri Jun 03 2010 Ram Dayal<ram.dayal@st.com> 64
- [Spec] Upgrade ARM version to STM gcc 4.5.0.
- [Spec] Hard Floating support enabled for ARMv7(cortex-9)
- [Spec] Made necessary dependency changes corresponding to ARM architecture build
- [Spec] ARM cpu types changed from arm and cortex to
  ARMv5(arm9),ARMv6(arm11) and ARMv7(cortex-A9)
- [Remove patch: gcc-4.2.4-code_sourcery-2008q1-126.patch]

* Tue May 20 2010 Christian Bruel <christian.bruel@st.com> 64
- [Update: 4.4.4] Upgrade to GCC 4.4.4 and STM developments 100610.
- [Add patch: gcc-4.4.4-stm-100610.patch]
- [Remove patch: gcc-4.3.4-091123.patch]
- [Remove patch: gcc-4.3.4-asmlength.patch]
- [Remove patch: gcc-4.3.4-gp-pic.patch]
- [Remove patch: gcc-4.3.4-expr64.patch]
- [Remove patch: gcc-4.3.4-picreconf.patch]
- [Remove patch: gcc-4.3.4-stdarg-unwind.patch]
- [Remove patch: gcc-4.3.4-bug8634.patch]
- [Spec] Remove patch0 for sh.

* Wed Mar 31 2010 Stuart Menefy <stuart.menefy@st.com> 63
- [Spec] Bump the release number for 2.4 product release.
- [Spec] Update BuildRoot to use %%(mktemp ...) to guarantee a unique name.

* Fri Mar 29 2010 Christian Bruel <christian.bruel@st.com> 62
- [Add patch: gcc-4.3.4-bug8634.patch; Bugzilla: 8634] Backport fix to avoid out-of-bound shifts.

* Fri Mar 26 2010 Fabio Arnone <fabio.arnone@st.com> 61
- [Spec] Added BuildRequires:
  cross-mpfr, cross-gmp, kernel-headers

* Thu Mar 18 2010 Stuart Menefy <stuart.menefy@st.com> 60
- [Spec] Change parameters to %%unfixinclude, to match change to
  macro definition, which now scans include-fixed as well as include.

* Fri Mar 04 2010 Christian Bruel <christian.bruel@st.com> 59
- [Add patch: gcc-4.3.4-stdarg-unwind.patch; Bugzilla: 8414] Adjust DWARF unwind
  information for stdarg push parameters.

* Tue Mar 02 2010 Carmelo Amoroso <carmelo.amoroso@st.com> 58
- [Spec] Enable libssp on uClibc and rebuild to get properly configured
  to use ssp support provided by uClibc ldso/libc instead of relying upon libssp.

* Fri Feb 11 2010 Christian Bruel <christian.bruel@st.com> 57
- [Remove patch: gcc-4.3.4-asmlength2.patch]
- [Add patch: gcc-4.3.4-gp-pic.patch] Fix unaligned memory access SIGBUS in PIC.

* Fri Feb 09 2010 Christian Bruel <christian.bruel@st.com> 56
- [Add patch: gcc-4.3.4-asmlength2.patch] Fix out of range constant pool access.

* Fri Feb 04 2010 Christian Bruel <christian.bruel@st.com> 56
- [Add patch: gcc-4.3.4-asmlength.patch ; Bugzilla: 8178, 8186] Fix asm length
  in distances adjustments.

* Fri Dec 18 2009 Christian Bruel <christian.bruel@st.com> 56
- [Spec: Force 32 bit host compatibility mode ; Bugzilla: 7771]

* Fri Dec 18 2009 Christian Bruel <christian.bruel@st.com> 55
- [Bugzilla: 7723] TEXTREL in libstdc++
- [Add patch: gcc-4.3.4-picreconf.patch]

* Fri Dec 18 2009 Christian Bruel <christian.bruel@st.com> 55
- [Add patch: gcc-4.3.4-expr64.patch] Fix 64 bit host bug

* Tue Nov 25 2009 Christian Bruel <christian.bruel@st.com> 54
- [Update: Upgrade SH version to STM gcc 4.3.4-091123]
- [Add patch: gcc-4.3.4-091123.patch]
- [Remove patch: gcc-4.3.4-090818.patch]

* Thu Nov 05 2009 Giuseppe Condorelli <giuseppe.condorelli@st.com> 53
- [Modify patch: gcc-4.3.4-uclibc-libstdc++_headers.patch] Fixed ctype_byname

* Mon Nov 02 2009 Giuseppe Condorelli <giuseppe.condorelli@st.com> 53
- [Modify patch: gcc-4.2.4-uclibc-libstdc++_no_nls.patch] Fixed typos.

* Tue Oct 27 2009 Giuseppe Condorelli <giuseppe.condorelli@st.com> 53
- [Delete patch: gcc-4.2.4-uclibc-conf.patch] No more required
  [Delete patch: gcc-4.2.4-uclibc-complex-ugly-hack.patch] No more required
  [Delete patch: gcc-4.2.4-uclibc-libbackend_dep_gcov-iov.h.patch]
  No more required
  [Delete patch: gcc-4.2.4-uclibc-locale_facets.patch] moved and fixed to
  a 4.3.4 relevant one.
  [Delete patch: gcc-4.2.4-uclibc-locale.patch] moved and fixed to a 4.3.4
  relevant one.
  [Add patch: gcc-4.3.4-uclibc-locale.patch] Fixed previous patch to fit 4.3.4
  gcc version.
  [Add patch: gcc-4.3.4-uclibc-locale_facets.patch] Fixed previous patch to
  fit 4.3.4 gcc version.
  [Add patch: gcc-4.3.4-uclibc-libstdc++_headers.patch] Added missed header
  inclusion on libstdc++ subtree.
  [Add patch: gcc-4.3.4-libmudflap-susv3-legacy.patch] Add fixes on libmudflap,
  required if SUSV3_LEGACY is not defined into architecture config.
  [Modify patch: gcc-4.2.4-uclibc-snprintf.patch] Fixed comment typos.
  [Spec] Tidy-up patches inclusion to fit new and deleted ones.

* Fri Sep 25 2009 Carl Shaw <carl.shaw@st.com> 53
- [Add patch: gcc-4.3.4-fix-include-patch.patch] fix cross-build
  include path

* Wed Sep 2 2009 Christian Bruel <christian.bruel@st.com> 53
- [Update: gcc-4.3.4-090818.patch]
  Upgrade to the latest ST compiler snapshot 090818
- [Spec: Install optimized versions of libgcc]
- [Add patch: gcc-4.3.4-stm-version.patch]

* Tue Sep  1 2009 Chris Smith <chris.smith@st.com> 52
- [Spec] Enable libmudflap on uClibc
- [Bugzilla: 6847]

* Tue Jul 14 2009 Carmelo Amoroso <carmelo.amoroso@st.com> 51
- [Spec] Fix use of if_target_arch directive to properly apply
  common patches.

* Tue Jul 14 2009 André Draszik <andre.draszik@st.com> 51
- [Spec] remove bashisms

* Thu Jul 09 2009 Carmelo Amoroso <carmelo.amoroso@st.com> 51
- [Modify patch: gcc-4.2.4-icache-flush.patch] Add strong hidden
  alias symbol for ic_invalidate_syscall to fix a build problem
  when compiling glibc with the final-gcc.
- [Bugzilla: 6183, 6198]

* Thu Jun 22 2009 Christian Bruel <christian.bruel@st.com> 50
- [Add patch: gcc-4.2.4-cbranchdi.patch; Bugzilla: 6459]
- [Add patch: gcc-4.2.4-pref.patch; Bugzilla: 4907]

* Thu Jun 4 2009 Christian Bruel <christian.bruel@st.com> 49
- [Add patch: gcc-4.2.4-090602.patch]
- [Delete patch: gcc-4.2.4-090218.patch]
- [Delete patch: gcc-4.2.4-relocated-include-paths.patch]
- [Delete patch: gcc-4.2.4-hwa-switch-table.patch]
- Upgrade to the latest ST compiler snapshot 090602

* Thu May 28 2009 Melwyn Lobo <melwyn.lobo@st.com> 48
- [Spec: Enabled OMP support for cortex]

* Mon May 22 2009 Melwyn Lobo <melwyn.lobo@st.com> 47
- [Add patch: gcc-4.2.4-code_sourcery-2008q1-126.patch] Support for CA9
- [Spec: Change document packaging as required for cortex]

* Mon Mar 16 2009 Chris Smith <chris.smith@st.com> 46
- [Add patch: gcc-4.2.4-relocated-include-paths.patch] Fix relocated C++ include paths

* Thu Mar 05 2009 Carmelo Amoroso <carmelo.amoroso@st.com> 45
- [Spec] Fix arm packaging by excluding libgcc-4-300.a and libgcc-Os-4-200.a.

* Tue Mar  3 2009 Chris Smith <chris.smith@st.com> 45
- [Add patch: gcc-4.2.4-hwa-switch-table.patch] Fix long pcrel jumps with -mdb-page-bug.

* Thu Feb 19 2009 Carl Shaw <carl.shaw@st.com> 45
- [Modify patch: gcc-4.2.4-icache-flush.patch] clean up patch
- [Add patch: gcc-4.2.4-multilib-opts.patch] enable cpu-specific optimisations
- [Spec] Add new static libgccs for cpu-specific optimisations

* Thu Feb 19 2009 Chris Smith <chris.smith@st.com> 45
- [Add patch: gcc-4.2.4-090218.patch]
- [Delete patch: gcc-4.2.4-cross_search_paths-1.patch]
- [Delete patch: gcc-4.2.4-080930.patch]
- [Delete patch: gcc-4.2.4-sh-linux-atomic-fixes.patch]
- [Delete patch: gcc-4.2.4-switch-offsets.patch]
- Upgrade to the latest ST compiler version, which includes the -mdb-page-bug option.

* Mon Feb  9 2009 Stuart Menefy <stuart.menefy@st.com> 45
- [Add patch: gcc-4.2.4-multilibpath.patch] Fix problems caused by make
  install redefining libdir. This patch was added to target-gcc several years
  ago, but has been missing from cross-gcc.

* Mon Feb 02 2009 Carl Shaw <carl.shaw@st.com> 45
- [Add patch: gcc-4.2.4-icache-flush.patch]
  Switch to i-cache flushing via syscall
- [Delete patch: gcc-4.2.4-linux-multilib-fix.patch]
- [Spec] Set multilib architectures via config line rather than patch
- [Modify patch: gcc-4.2.4-080930.patch] Change to p1, remove whitespace
- [Modify patch: gcc-4.2.4-switch-offsets.patch] Change to p1, remove
  whitespace

* Fri Nov 21 2008 Chris Smith <chris.smith@st.com> 44
- [Spec] Actually apply gcc-4.2.4-switch-offsets.patch!

* Mon Oct 27 2008 Chris Smith <chris.smith@st.com> 43
- [Bugzilla: 4907; Add patch: gcc-4.2.4-switch-offsets.patch]

* Thu Oct  9 2008 Chris Smith <chris.smith@st.com> 42
- [Update: 4.2.4] Upgrade to latest ST compiler version
- [Add patch: gcc-4.2.4-cross_search_paths-1.patch]
- [Add patch: gcc-4.2.4-stm-release.patch]
- [Add patch: gcc-4.2.4-080930.patch]
- [Add patch: gcc-4.2.4-linux-multilib-fix.patch]
- [Add patch: gcc-4.2.4-sh-use-gnu-hash-style.patch]
- [Add patch: gcc-4.2.4-sh-linux-atomic-fixes.patch]
- [Add patch: gcc-4.2.4-uclibc-conf.patch]
- [Add patch: gcc-4.2.4-uclibc-locale.patch]
- [Add patch: gcc-4.2.4-uclibc-missing-execinfo_h.patch]
- [Add patch: gcc-4.2.4-uclibc-snprintf.patch]
- [Add patch: gcc-4.2.4-uclibc-complex-ugly-hack.patch]
- [Add patch: gcc-4.2.4-uclibc-libstdc++-namespace.patch]
- [Add patch: gcc-4.2.4-uclibc-libbackend_dep_gcov-iov.h.patch]
- [Add patch: gcc-4.2.4-uclibc-flatten-switch-stmt-00.patch]
- [Add patch: gcc-4.2.4-uclibc-locale_facets.patch]
- [Add patch: gcc-4.2.4-uclibc-libstdc++_no_nls.patch]
- [Delete patch: gcc-4.2.3-st40r2-4.2.1.patch]
- [Delete patch: gcc-4.2.3-cross_search_paths-1.patch]
- [Delete patch: gcc-4.2.3-stm-release.patch]
- [Delete patch: gcc-4.2.3-linux-multilib-fix.patch]
- [Delete patch: gcc-4.2.3-sh-use-gnu-hash-style.patch]
- [Delete patch: gcc-4.2.3-sh-linux-atomic-fixes.patch]
- [Delete patch: gcc-4.2.3-uclibc-conf.patch]
- [Delete patch: gcc-4.2.3-uclibc-locale.patch]
- [Delete patch: gcc-4.2.3-uclibc-missing-execinfo_h.patch]
- [Delete patch: gcc-4.2.3-uclibc-snprintf.patch]
- [Delete patch: gcc-4.2.3-uclibc-complex-ugly-hack.patch]
- [Delete patch: gcc-4.2.3-uclibc-libstdc++-namespace.patch]
- [Delete patch: gcc-4.2.3-uclibc-libbackend_dep_gcov-iov.h.patch]
- [Delete patch: gcc-4.2.3-uclibc-flatten-switch-stmt-00.patch]
- [Delete patch: gcc-4.2.3-uclibc-locale_facets.patch]
- [Delete patch: gcc-4.2.3-uclibc-libstdc++_no_nls.patch]

* Fri Jul 18 2008 Carl Shaw <carl.shaw@st.com> 41
- [Update: 4.2.3] Upgrade to latest ST compiler version
- [Add patch: gcc-4.2.3-cross_search_paths-1.patch]
- [Add patch: gcc-4.2.3-stm-release.patch]
- [Add patch: gcc-4.2.3-st40r2-4.2.1.patch]
- [Add patch: gcc-4.2.3-linux-multilib-fix.patch]
- [Add patch: gcc-4.2.3-sh-use-gnu-hash-style.patch]
- [Add patch: gcc-4.2.3-sh-linux-atomic-fixes.patch]
- [Add patch: gcc-4.2.3-uclibc-conf.patch]
- [Add patch: gcc-4.2.3-uclibc-locale.patch]
- [Add patch: gcc-4.2.3-uclibc-missing-execinfo_h.patch]
- [Add patch: gcc-4.2.3-uclibc-snprintf.patch]
- [Add patch: gcc-4.2.3-uclibc-complex-ugly-hack.patch]
- [Add patch: gcc-4.2.3-uclibc-libstdc++-namespace.patch]
- [Add patch: gcc-4.2.3-uclibc-libbackend_dep_gcov-iov.h.patch]
- [Add patch: gcc-4.2.3-uclibc-flatten-switch-stmt-00.patch]
- [Add patch: gcc-4.2.3-uclibc-locale_facets.patch]
- [Add patch: gcc-4.2.3-uclibc-libstdc++_no_nls.patch]
- [Delete patch: gcc-4.2.1-cross_search_paths-1.patch]
- [Delete patch: gcc-4.2.1-stm-release.patch]
- [Delete patch: gcc-4.2.1-makeinfo.patch]
- [Delete patch: gcc-4.2.1-stm_sh_R4.1_070806.patch]
- [Delete patch: gcc-4.2.1-linux-multilib-fix.patch]
- [Delete patch: gcc-4.2.1-sh-use-gnu-hash-style.patch]
- [Delete patch: gcc-4.2.1-dwarfreg-fix.patch]
- [Delete patch: gcc-4.2.1-packed_align.patch]
- [Delete patch: gcc-4.2.1-sh-linux-atomic-fixes.patch]
- [Delete patch: gcc-4.2.1-switch-tbit.patch]
- [Delete patch: gcc-4.2.1-static_dtors.patch]
- [Delete patch: gcc-4.2.1-sh_cond_branch_size.patch]
- [Delete patch: gcc-4.2.1-uclibc-conf.patch]
- [Delete patch: gcc-4.2.1-uclibc-locale.patch]
- [Delete patch: gcc-4.2.1-uclibc-missing-execinfo_h.patch]
- [Delete patch: gcc-4.2.1-uclibc-snprintf.patch]
- [Delete patch: gcc-4.2.1-uclibc-complex-ugly-hack.patch]
- [Delete patch: gcc-4.2.1-uclibc-libstdc++-namespace.patch]
- [Delete patch: gcc-4.2.1-uclibc-libbackend_dep_gcov-iov.h.patch]
- [Delete patch: gcc-4.2.1-uclibc-flatten-switch-stmt-00.patch]
- [Delete patch: gcc-4.2.1-uclibc-locale_facets.patch]
- [Delete patch: gcc-4.2.1-uclibc-libstdc++_no_nls.patch]

* Thu Jun 12 2008 Carmelo Amoroso <carmelo.amoroso@st.com> 40
- [Spec] Bump up release number to force rebuild after having
  disabled XLOCALE support on uclibc.

* Thu Jun 05 2008 Carmelo Amoroso <carmelo.amoroso@st.com> 39
- [Modify patch: gcc-4.2.1-uclibc-locale.patch] Fix gcc
  patch for uclibc when XLOCALE support is enabled.

* Tue May 07 2008 Carl Shaw <carl.shaw@st.com> 38
- [Add patch: gcc-4.2.1-cond_branch_size.patch; Bugzilla: 3891]
  Increase size of conditional branches for SH

* Mon Apr 21 2008 Stuart Menefy <stuart.menefy@st.com> 37
- [Spec] Switch code which removes libmudflap and libssp libraries to use
  find to ensure we delete all copies.

* Tue Apr 08 2008 Stuart Menefy <stuart.menefy@st.com> 37
- [Add patch: gcc-4.2.1-switch-tbit.patch]
  Fix compiler problem which caused incorrect code generation for certain
  switch statements.

* Tue Apr 08 2008 Stuart Menefy <stuart.menefy@st.com> 37
- [Add patch: gcc-4.2.1-static_dtors.patch; Bugzilla: 3672]
  Fix problem whereby a program with static dtors for objects in a
  different module cause the compiler to consume large amouns of memory.

* Fri Mar 07 2008 Stuart Menefy <stuart.menefy@st.com> 37
- [Add patch: gcc-4.2.1-sh-linux-atomic-fixes.patch] Several fixes for SH
  implementation of gcc atomic operations.

* Tue Mar 04 2008 David McKay <david.mckay@st.com> 36
- [Spec] Added program-prefix to allow arm compiler to have sensible name

* Tue Feb 05 2008 David McKay <david.mckay@st.com> 35
- [Add patch: gcc-4.2.1-makeinfo.patch] Fix for makeinfo version problems
- [Spec] Delete libiberty in lib64 on 64 x86_64 builds as well

* Tue Feb  5 2008 Stuart Menefy <stuart.menefy@st.com> 35
- [Add patch: gcc-4.2.1-packed_align.patch; Bugzilla: 3313]
  Fix code generation problem when accessing aligned elements of packed
  structures.

* Fri Sep 28 2007 Carmelo Amoroso <carmelo.amoroso@st.com> 34
- [Spec] Safely apply gnu-hash style patch for uclibc too
  dynamic linker does support it now.

* Wed Sep 19 2007 Carmelo Amoroso <carmelo.amoroso@st.com> 33
- [Spec] Not apply gnu-hash style patch for now, the uclibc
  dynamic linker doesn't support it yet, so any packages built
  with this support cannot work. It will be added as soon as
  the work on the linker will be completed.

* Tue Sep 11 2007 Carl Shaw <carl.shaw@st.com> 33
- [Add patch: gcc-4.2.1-dwarfreg-fix.patch] add patch from compiler
  team to synchronise DWARF cfi register numbers between the
  compiler/gdb/binutils and linux

* Thu Aug 30 2007 Carmelo Amoroso <carmelo.amoroso@st.com> 33
- [Spec] Force gcc to use embedded intl implementation, so doens't
  rely on build order with respect to gettext. libintl.h from gettext
  brakes gcc build.
  Use new shortcut macro "%if_target_arch_[no]uclibc"
- [Add patch: gcc-4.2.1-uclibc-libstdc++_no_nls.patch] Disable NLS support
  for libstdc++ (uclibc)

* Fri Aug 24 2007 Carl Shaw <carl.shaw@st.com> 33
- [Add patch: gcc-4.2.1-sh-use-gnu-hash-style.patch]
  This patch forces the use of --hash-style=gnu in the linker

* Thu Aug 23 2007 Carmelo Amoroso <carmelo.amoroso@st.com> 33
- [Spec] Port latest gcc for uclibc arch.
  Do not add mf-runtime header being libmudflap support disabled
- [Add patch: gcc-4.2.1-uclibc-complex-ugly-hack.patch] Renamed
- [Add patch: gcc-4.2.1-uclibc-conf.patch] Reworked
- [Add patch: gcc-4.2.1-uclibc-flatten-switch-stmt-00.patch] New
- [Add patch: gcc-4.2.1-uclibc-libbackend_dep_gcov-iov.h.patch] New
- [Add patch: gcc-4.2.1-uclibc-libstdc++-namespace.patch] New
- [Add patch: gcc-4.2.1-uclibc-locale.patch] Reworked
- [Add patch: gcc-4.2.1-uclibc-missing-execinfo_h.patch] Renamed
- [Add patch: gcc-4.2.1-uclibc-snprintf.patch] Renamed
- [Delete patch: gcc-4.1.1-uclibc-arm-eabi.patch] Not longer needed
- [Delete patch: gcc-4.1.1-uclibc-complex-ugly-hack.patch] Renamed
- [Delete patch: gcc-4.1.1-uclibc-conf.patch] Reworked
- [Delete patch: gcc-4.1.1-uclibc-locale.patch] Reworked
- [Delete patch: gcc-4.1.1-uclibc-locale_facets.patch] Reworked
- [Delete patch: gcc-4.1.1-uclibc-missing-execinfo_h.patch] Renamed
- [Delete patch: gcc-4.1.1-uclibc-snprintf.patch] Renamed

* Tue Aug 14 2007 Carl Shaw <carl.shaw@st.com> 32
- [Update: 4.2.1] move to latest compiler team version

* Tue Aug 14 2007 David McKay <david.mckay@st.com> 31
- [Spec] Unwind patch does not apply for ARM.

* Mon Aug  6 2007 Giuseppe Cavallaro <peppe.cavallaro@st.com> 30
- [Spec] Fix gcc Required for uClibc.

* Thu Aug  2 2007 Carmelo Amoroso <carmelo.amoroso@st.com> 30
- [Spec] Fix for uclibc arch. Do not add mf-runtime header

* Wed Aug  1 2007 Carl Shaw <carl.shaw@st.com> 30
- [Spec] Use if_target_arch conditional
- [Spec] enable cxa_atexit and g++ include path for uclibc as well

* Thu Jul 12 2007 Stuart Menefy <stuart.menefy@st.com> 29
- [Add patch: gcc-4.1.1-stm-release.patch] Add a macro __GNUC_STM_RELEASE__
  to allow source code to distinguish the ST compiler at compile time.

*  Thu Jul 12 2007 Carmelo Amoroso <carmelo.amoroso@st.com> 29
- [Spec] Merged with the obsolete stm-cross-uclibc-gcc spec file
  to handle all the arch in the same spec file

* Fri Jul  9 2007 Carl Shaw <carl.shaw@st.com> 28
- [Patch add: gcc-4.1.1-sh-unwindfix2.patch]
  Fix SH4 architecture specific unwind code to correctly save XD registers

* Fri Jun 22 2007 Carl Shaw <carl.shaw@st.com> 28
- [Patch add: gcc-4.1.1-sh-PR26208-unwindfix.patch] Increase unwinding robustness over
  signals.  This patch is only sh4 specfic because it changes the ChangeLog altered by
  the bare machine patch.
- [Patch add: gcc-4.1.1-arm-PR26208-unwindfix.patch] Increase unwinding robustness

* Fri Apr 20 2007 Chris Smith <chris.smith@st.com> 27
- [Patch add: gcc-4.1.1-st40r2-4.0.2.patch] Upgrade to latest ST40 toolset release
- [Patch delete: gcc-4.1.1-st40r2-4.0.1.patch]
- [Patch delete: gcc-4.1.1-st40r2-4.0.1-no-cbranchdi.patch]
- [Patch delete: gcc-4.1.1-regmove-fix-20061130.patch]
- [Patch delete: gcc-4.1.1-optimize-related-values.patch]
- [Patch delete: gcc-4.1.1-optimize-related-value-pre_dec.patch]
- [Patch modify: gcc-4.1.1-PR27781-fix.patch] Now applied to ARM only

* Tue Feb 21 2007 Carl Shaw <carl.shaw@st.com> 27
- [Add patch: gcc-4.1.1-optimize-related-value-pre_dec.patch; Bugzilla: 1203] fix
  another problem with optimize-related-value optimisation

* Tue Feb 13 2007 Carl Shaw <carl.shaw@st.com> 27
- [Spec] Add in m4-nofpu libgcc_s - it is required for target-gcc

* Fri Feb 09 2007 Stuart Menefy <stuart.menefy@st.com> 27
- [Spec] Added Obsoletes lines to ensure gcc-bootstrap packages are removed.

* Thu Feb 08 2007  David McKay <david.mckay@st.com> 27
- [Spec] Used consistent %cross macros, deleted %target_check

* Tue Feb  6 2007 Carl Shaw <carl.shaw@st.com> 26
- [Add patch: gcc-4.1.1-optimize-related-values.patch ; Bugzilla: 1057] fix
  optimise-related-values problem on sh

* Thu Jan 30 2007 David McKay <david.mckay@st.com> 25
- [Spec] For ARM, make libgcc_so a sym link. This effectively remove the change that
  Stuart made on Aug 30 for ARM only. On the SH, libgcc_so is a ld script file, so it
  is OK to simply move it.

* Thu Dec 07 2006  David McKay <david.mckay@st.com> 24
- Removed use of conditional @ macro

* Mon Dec  4 2006 Carl Shaw <carl.shaw@st.com> 23
- Added optimisation patch for Bugzilla 977 from Joern Rennecke

* Wed Nov 29 2006 Stuart Menefy <stuart.menefy@st.com> 22
- Add gcc-4.1.1-disable-optimize-related-values.patch to disable the default
  use of an optimisation at -Os and -O2 which can lead to an ICE.

* Tue Nov 14 2006 Carl Shaw <carl.shaw@st.com> 22
- Switch to using a parallel make

* Wed Aug 30 2006 Stuart Menefy <stuart.menefy@st.com> 21
- Now that this package has reverted to being gcc (from gcc4), remove the
  Conflicts: lines, otherwise the package conflicts with itself!

* Wed Aug 30 2006 Stuart Menefy <stuart.menefy@st.com>
- Reinstate libgcc_s fix (use libgcc_s.so indirect file rather than making it
  a sym link) from Tue Feb 7 2006 which got lost in the Thu Mar 2 2006 update.
- Remove m4-nofpu versions of libgcc_s as we don't ship them in the
  target package.

* Wed Aug 23 2006 David McKay <david.mckay@st.com>
- Introduced unfixincludes to undo header file mangling

* Tue Aug 22 2006 Carl Shaw <carl.shaw@st.com> 20
- Added gcc-4.1.1-PR27781-fix.patch to fix over-aggressive weak attribute optimisations

* Tue Aug 15 2006 Carl Shaw <carl.shaw@st.com> 20
- Added gcc-4.1.1-st40r2-4.0.1-no-cbranchdi.patch and gcc-4.1.1-st40r2-4.0.1.patch
-  patches from bare machine toolset release
- Added gcc-4.1.1-linux-multilib-fix.patch to fix m4-nofpu problem
-  added m4-nofpu files and libgcc_s modifications

* Thu Mar 2 2006 Carl Shaw <carl.shaw@st.com>
- Updated arm and sh4 compiler to gcc 4.1.1

* Tue Feb  7 2006 Stuart Menefy <stuart.menefy@st.com>
- Updated from gcc-3.4.3-vienna-1.5.patch to gcc-3.4.3-vienna-1.6.patch
- Added gcc-3.4.3-rotate-conflict.patch and gcc-3.4.3-sh-float-varags.patch
- Removed gcc-3.4.3-sh-shared-static-libc.patch and use linker script
-  generated by the gcc compilation process instead.

* Thu Feb  2 2006 Carl Shaw <carl.shaw@st.com>
- Upgraded ARM to gcc-3.4.5

* Thu Jan 26 2006 Carl Shaw <carl.shaw@st.com>
- Added arm support and patches:
-    gcc-3.4.3-arm-pr16201.patch
-    gcc-3.4.3-arm-pr18508-fix.patch
-    gcc-3.4.3-arm-pr15068-fix.patch

* Mon Jan 23 2006 Carl Shaw <carl.shaw@st.com>
- Added gcc-3.4.3-sh-rel-comb-fix-20060120.patch fixes bugzilla 376

* Tue Sep 27 2005 Stuart Menefy <stuart.menefy@st.com>
- Added gcc-3.4.3-sh-shared-static-libc.patch as an alternative attempt
  to fix the libgcc problems.

* Fri Sep  2 2005 Carl Shaw <carl.shaw@st.com>
- Removed symbol versioning patch as it causes libgcc problems with
- new compiler.

* Wed Jul 20 2005 Stuart Menefy <stuart.menefy@st.com>
- Added gcc-3.4.3-vienna-1.5-gthr.patch

* Tue Jul 12 2005 Stuart Menefy <stuart.menefy@st.com>
- Added gcc-3.4.3-vienna-1.5.diff.

* Tue Jun 21 2005 Stuart Menefy <stuart.menefy@st.com>
- Added gcc-3.4.3-sh-symbolver.patch.

* Mon Jun  6 2005 Carl Shaw <carl.shaw@st.com>
- Automatically removed dependency opt-out line

* Wed May 25 2005 Carl Shaw <carl.shaw@st.com>
- Minor changes to build and install to use predefined macros.
- Version information added.

* Tue Apr 26 2005 Carl Shaw <carl.shaw@st.com>
- Taken back out of STtoolbuilder - gcc version updated to 3.4.3

* Thu Dec  9 2004 Stuart Menefy <stuart.menefy@st.com>
- Updated for STtoolbuilder
* Wed Sep  8 2004 Stuart Menefy <stuart.menefy@st.com>
- Automated introduction of %{_stm_pkg_prefix} and %{_pkgname}
* Tue Sep  7 2004 Stuart Menefy <stuart.menefy@st.com>
- Updated to 3.4.1.

* Mon Nov 24 2003 Stuart Menefy <stuart.menefy@st.com>
- Updated to gcc 3.3.2, including patches from Dan Kegel's crosstools 0.24
  (http://kegel.com/crosstool), and a couple of new SH specific bug fixes.

* Mon Nov 03 2003 Stuart Menefy <stuart.menefy@st.com>
- Move libgcc_s package from target-gcc to cross-gcc so that it can be
  installed prior to starting the target-gcc build.
  Remove c++filt, included in cross-binutils package.

* Thu Oct 23 2003 Stuart Menefy <stuart.menefy@st.com>
- Bump the version number because gcc-3.0.3-target_lib.patch has changed.

* Thu Sep 04 2003 Stuart Menefy <stuart.menefy@st.com>
- Minor modification to hhl-gcc-relocation-2.patch to fix problem when
  using link in %{_stm_cross_targetconf_dir}/bin.
  Remove unused files to keep rpm 4.1 happy
  Removed redirection to build.log - prevents errors being reported.
  Include c++filt in the various bin directories.

* Tue Sep 02 2003 Stuart Menefy <stuart.menefy@st.com>
- Added %{_stm_cross_targetconf_dir}/bin/cc symlink, as this is needed by
  XFree86 4.3.0 cross compile environment.

* Thu Oct 31 2002 Stuart Menefy <stuart.menefy@st.com>
- Updated gcc-stm-versions.patch and added full RPM version number to string
  also fixed a problem with gcc-3.0.3-include.patch, which prevented
  the -iwithprefix option picking up the default include directory.

* Fri Jan 04 2002 Stuart Menefy <stuart.menefy@st.com>
- First version, copied from MontaVista HHL 2.0.2 version
