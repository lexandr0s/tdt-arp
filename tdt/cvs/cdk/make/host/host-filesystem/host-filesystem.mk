#
# HOST-FILESYSTEM
#
package[[ host_filesystem

BDEPENDS_${P} =

PV_${P} = 0.1
PR_${P} = 2

call[[ base_bare ]]

$(TARGET_${P}): $(DEPENDS_${P})
	install -d $(workprefix)
	install -d $(specsprefix)
	install -d $(sourcesprefix)

	install -d $(ipkhost)
	install -d $(hostprefix)
#	install -d $(hostprefix)/{bin,doc,etc,include,info,lib,man,share,var}
#	ln -sf $(hostprefix)/lib $(hostprefix)/lib64
#	install -d $(hostprefix)/man/man{1,2,3,4,5,6,7,8,9}
	touch $@

]]package
