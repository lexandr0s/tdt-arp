#
# AR-P buildsystem smart Makefile
#
package[[ target_lua

BDEPENDS_${P} = $(target_glibc) $(target_ncurses)

PV_${P} = 5.2.3
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.lua.org/ftp/${PN}-${PV}.tar.gz
  git://github.com/luaposix/luaposix.git;r=release-v31
  patch:file://liblua-${PV}-luaposix-31.patch
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	
	set -e; \
	cd $(DIR_${P})/luaposix.git/ext; cp posix/posix.c include/lua52compat.h ../../src/; cd ../..; \
	sed -i 's/<config.h>/"config.h"/' src/posix.c; \
	sed -i '/^#define/d' src/lua52compat.h; \
	sed -i 's@^#define LUA_ROOT.*@#define LUA_ROOT "/"@' src/luaconf.h; \
	sed -i '/^#define LUA_USE_READLINE/d' src/luaconf.h; \
	sed -i 's/ -lreadline//' src/Makefile; \
	
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(MAKE) $(MAKE_ARGS) linux
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install INSTALL_TOP=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

NAME_${P} = liblua
DESCRIPTION_${P} = Lua is a powerful, fast, lightweight, embeddable scripting language
RDEPENDS_${P} = libncurses5
FILES_${P} = /usr/bin/lua /usr/bin/luac /usr/lib/*

call[[ ipkbox ]]

]]package
