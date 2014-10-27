#
# AR-P buildsystem smart Makefile
#
package[[ target_emulators

BDEPEDNS_${P} = $(target_filesystem)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com:schpuntik/cams.git;protocol=ssh
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	touch $@

# we don't have anything to split
PACKAGES_${P} =
call[[ ipkbox ]]

# DIR is already a tree for ipkbox
$(TARGET_${P}).do_split_post: $(TARGET_${P}).do_split
	cp -ar ${DIR}/* ${SPLITDIR}
	touch $@

$(TARGET_${P}).do_ipkbox: $(TARGET_${P}).do_split_post

]]package
