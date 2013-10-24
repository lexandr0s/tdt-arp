define initdconfig
	export HHL_CROSS_TARGET_DIR=$(prefix)/release && \
	cd $(prefix)/release/etc/init.d && \
		for s in $(1) ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || echo "Unable to enable initd service: $$s" ; \
		done && \
		rm *rpmsave 2>/dev/null || true
endef
