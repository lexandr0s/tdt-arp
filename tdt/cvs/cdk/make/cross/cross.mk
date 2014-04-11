# Disable this code
ifdef false
cross-env: bootstrap-host
	@echo
	@echo '==> EXPORT CROSS ENV'
	@echo
	rm -f $(targetprefix)
	ln -sf $(targetsh4prefix) $(targetprefix)

.PHONY: cross-env

$(DEPDIR)/bootstrap-cross: $(cross_gcc_second)
	touch $@
endif