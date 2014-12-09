#
# AR-P buildsystem smart Makefile
#
package[[ target_enigma2_plugins

BDEPENDS_${P} = $(target_enigma2) $(target_python_gdata)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/OpenAR-P/enigma2-plugins-sh4.git
  patch:file://mytube-remove-dreambox-validation.patch
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
	cd ${DIR}; \
	list=`ls */Makefile |sed 's#/Makefile##'`; \
	for d in $${list}; do \
		echo "PACKAGES_DYNAMIC_${P} += $$d" >> $@; \
		\
		awk -v d=$$d -F ':' '\
		/^Package:/ {$$1=""; print "NAME_" d " :=" tolower($$0)} \
		/^Version:/ {$$1=""; gsub(/ +/,""); print "VERSION_" d " := " $$0 "-${PR}"} \
		/^Architecture:/ {$$1=""; print "PACKAGE_ARCH_" d " :=" $$0} \
		/^Depends:/ {$$1=""; gsub(/, */," "); print "RDEPENDS_" d " :=" $$0} \
		/^Replaces:/ {$$1=""; gsub(/, */," "); print "RREPLACES_" d " :=" $$0} \
		/^Conflicts:/ {$$1=""; gsub(/, */," "); print "RCONFLICTS_" d " :=" $$0} \
		/^Description:/ {$$1=""; print "DESCRIPTION_" d " :=" $$0} \
		/^Section:/ {$$1=""; "SECTION_" d " :=" $$0} \
		/^Priority:/ {$$1=""; print "PRIORITY_" d " :=" $$0} \
		/^Maintainer:/ {$$1=""; print "MAINTAINER_" d " :=" $$0} \
		/^License:/ {$$1=""; print "LICENSE_" d " :=" $$0} \
		/^Homepage:/ {$$1=""; print "HOMEPAGE_" d " :=" $$0} \
		/^Source:/ {$$1=""; print "SRC_URI_" d " :=" $$0} '\
		$$d/CONTROL/control >> $@; \
		\
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

PACKAGES_${P} = enigma2_plugins_meta $(PACKAGES_DYNAMIC_${P})
# some pattern that doesn't match any files
FILES_${P} = /tmp

FILES_enigma2_plugins_meta := /usr/share/meta
DESCRIPTION_enigma2_plugins_meta := Enigma2 plugins metadata

call[[ ipkbox ]]

# do our split method after splitting by pattern
$(TARGET_${P}).do_split_post: $(TARGET_${P}).do_split
	set -e; \
	for p in $(PACKAGES_DYNAMIC_${P}); do \
		cd ${DIR}/$$p && $(MAKE) install DESTDIR=${SPLITDIR}/$$p; \
		mv ${SPLITDIR}/$$p/usr/share/meta/* ${SPLITDIR}/enigma2_plugins_meta/usr/share/meta || true; \
		rmdir --ignore-fail-on-non-empty --parents ${SPLITDIR}/$$p/usr/share/meta; \
		for f in preinst postinst prerm postrm; do \
			test -f ${DIR}/$$p/CONTROL/$$f \
				&& install -m755 ${DIR}/$$p/CONTROL/$$f ${SPLITDIR}/$$p/CONTROL/$$f \
			|| true; \
		done; \
			test -f ${DIR}/$$p/CONTROL/conffiles \
				&& install -m644 ${DIR}/$$p/CONTROL/conffiles ${SPLITDIR}/$$p/CONTROL/conffiles \
			|| true; \
	done
	
	touch $@

$(TARGET_${P}).do_ipkbox: $(TARGET_${P}).do_split_post

]]package
