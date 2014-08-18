#
# AR-P buildsystem smart Makefile
#
package[[ target_rfkill

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://git.sipsolutions.net/rfkill.git
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(MAKE) $(MAKE_ARGS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = rfkill is a small tool to query the state of the rfkill switches, buttons and subsystem interfaces
RDEPENDS_${P} = libc6
FILES_${P} = /usr/sbin/*

call[[ ipkbox ]]

]]package
