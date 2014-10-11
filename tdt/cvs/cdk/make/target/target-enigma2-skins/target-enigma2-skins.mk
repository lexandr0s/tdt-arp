#
# AR-P buildsystem smart Makefile
#
package[[ target_enigma2_skins

BDEPENDS_${P} = $(target_enigma2)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/OpenAR-P/enigma2-skins-sh4.git
]]rule

call[[ git ]]

CONFIG_FLAGS_${P} = $(CONFIG_FLAGS_target_enigma2)

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(MAKE) all
	touch $@


# We use dynamic variables pattern,
# I suggest to use such Makefile 'hack' everytime you deal with dynamic variables

# inlude is evaluated every time make runs, beacause it is phony target and specified as oder-only prerequisite
$(TARGET_${P}).include_vars: $(TARGET_${P}).write_vars
	@echo "==> include $<"
	$(eval include $<)
.PHONY: $(TARGET_${P}).include_vars

# read control file and convert it to Makefile format
# output file will be included by make at run time
$(TARGET_${P}).write_vars: $(TARGET_${P}).do_compile
	@echo "==> $(notdir $@)"
	set -e; \
	echo > $@; \
	\
	cd ${DIR}/skins; \
	list=`ls */Makefile |sed 's#/Makefile##'`; \
	for dir in $${list}; do \
		d=enigma2_plugin_skin_`echo $$dir |tr [:upper:] [:lower:] |tr .- _`; \
		echo "PACKAGES_DYNAMIC_${P} += $$d" >> $@; \
		echo -n "VERSION_$$d := " >> $@; \
		cd $$dir && $(git_log_version) >> $@; \
		cd ..; \
		echo "DIR_$$d := $$dir" >> $@; \
		echo >> $@; \
	done || (rm $@ && false)

$(TARGET_${P}).clean_vars:
	rm -f $(TARGET_${P}).write_vars

# include vars from control file before inherit
$(TARGET_${P}).set_inherit_vars: $(TARGET_${P}).include_vars
$(TARGET_${P}).do_split: $(TARGET_${P}).write_vars

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install-metaDATA DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = Skins for enigma2
PACKAGES_${P} = enigma2_skins_meta $(PACKAGES_DYNAMIC_${P})
RDEPENDS_${P} = enigma2
# some pattern that doesn't match any files
FILES_${P} = /tmp

FILES_enigma2_skins_meta := /usr/share/meta
DESCRIPTION_enigma2_skins_meta := Enigma2 skins metadata

RDEPENDS_enigma2_plugin_skin_megamod = enigma2 enigma2_plugin_systemplugins_libgisclubskin

call[[ ipkbox ]]

# do our split method after splitting by pattern
$(TARGET_${P}).do_split_post: $(TARGET_${P}).do_split
	set -e; \
	$(foreach pkg, $(PACKAGES_DYNAMIC_${P}), \
		cd ${DIR}/skins/$(DIR_$(pkg)) && make install DESTDIR=${SPLITDIR}/$(pkg); \
		mv ${SPLITDIR}/$(pkg)/usr/share/meta/* ${SPLITDIR}/enigma2_skins_meta/usr/share/meta || true; \
		rm -rf ${SPLITDIR}/$(pkg)/usr/share/meta; \
	)
	
	touch $@

$(TARGET_${P}).do_ipkbox: $(TARGET_${P}).do_split_post

]]package
