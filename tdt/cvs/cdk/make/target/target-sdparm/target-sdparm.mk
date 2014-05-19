#
# AR-P buildsystem smart Makefile
#
package[[ target_sdparm

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.07
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sg.danny.cz/sg/p/${PN}-${PV}.tgz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man \
		&& \
		make
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = sdparm
RDEPENDS_${P} = libc6
FILES_${P} = /usr/bin/sdparm

call[[ ipkbox ]]

]]package
