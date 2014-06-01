#
# AR-P buildsystem smart Makefile
#
package[[ target_libopenthreads

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://c00lstreamtech.de/cst-public-libraries-openthreads.git
  patch:file://${PN}.patch
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	cd $(DIR_${P}) && \
	git clone git://c00lstreamtech.de/cst-public-libraries-openthreads-src.git src; \
	git clone git://c00lstreamtech.de/cst-public-libraries-openthreads-include.git include;
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		rm CMakeFiles/* -rf CMakeCache.txt cmake_install.cmake && \
		cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME="Linux" \
			-DCMAKE_INSTALL_PREFIX="" \
			-DCMAKE_C_COMPILER="$(target)-gcc" \
			-DCMAKE_CXX_COMPILER="$(target)-g++" \
			-D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 && \
			find . -name cmake_install.cmake -print0 | xargs -0 \
			sed -i 's@SET(CMAKE_INSTALL_PREFIX "/usr/local")@SET(CMAKE_INSTALL_PREFIX "")@' \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)/usr

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = This library is intended to provide a minimal & complete Object-Oriented (OO) thread interface \
for C++ programmers, used primarily in OpenSceneGraph. It is loosely modeled on the Java thread API, and the POSIX Threads standards.
FILES_${P} = /usr/lib/*

call[[ ipkbox ]]

]]package
