# Disable this code
ifdef false
targetsh4-env: bootstrap-cross
	@echo
	@echo '==> EXPORT TARGET-SH4 ENV'
	@echo
	rm -f $(targetprefix)
	ln -sf $(targetsh4prefix) $(targetprefix)

targetbox-env: bootstrap-cross
	@echo
	@echo '==> EXPORT TARGET-BOX ENV'
	@echo
	rm -f $(targetprefix)
	ln -sf $(targetboxprefix) $(targetprefix)

.PHONY: targetsh4-env targetbox-env
endif