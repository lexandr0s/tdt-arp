#
# AR-P buildsystem smart Makefile
#
function[[ boost_in
PV_${P} = 1.56.0
PR_${P} = 1

DESCRIPTION_${P} = boost

MY_PV_${P} := $(subst .,_,${PV})
DIR_${P} = ${WORK}/${PN}_${MY_PV}
]]function

package[[ target_boost

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib)

call[[ boost_in ]]
call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/boost/files/${PN}/${PV}/${PN}_${MY_PV}.tar.bz2
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./bootstrap.sh \
			--prefix=$(PKDIR)/usr \
			--with-libraries="system"
	
	sed 's/using gcc/using gcc : $(target_arch) : $(target)-g++/' -i ${DIR}/project-config.jam
	cd $(DIR_${P}) && ./b2 -q stage
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && ./b2 -q install
	touch $@

call[[ ipk ]]

#RDEPENDS_${P} = libc6
PACKAGES_${P} = libboost_system
FILES_libboost_system = /usr/lib/libboost_system.so*

call[[ ipkbox ]]

]]package
