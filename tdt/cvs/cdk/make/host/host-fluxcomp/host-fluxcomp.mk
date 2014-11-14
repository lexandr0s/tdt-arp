#
# HOST MAKE
#
package[[ host_fluxcomp

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://git.directfb.org/git/directfb/core/flux.git
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./autogen.sh &&\
		./configure \
			--prefix=$(hostprefix) && \
		$(MAKE) all PREFIX=$((hostprefix) &&  \
		$(MAKE) install PREFIX=$((hostprefix)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

]]package
