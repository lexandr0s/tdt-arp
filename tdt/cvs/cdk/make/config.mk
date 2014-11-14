# config
#############################################################################

# When config changes we rename *.config to *.config_old
# if new *.config differs we rebuild package

Makefile: .config.new
.config.new: .config
	@echo
	@echo "==> notify packages affected by config change"
	rename -v 's/\.config$$/\.config_old/' $(DEPDIR)/*.config
	touch $@
	@echo

# define configuration variables that affect your package.
# you can use only one '%' to match any characters
# this is how gnu make pattern works, there is no other regexp syntax here !
# for example:
# CONFIGS_${P} = CONFIG_OPTION_FOO1 CONFIG_OPTION_FOO2 CONFIG_BAR_%

function[[ config

# in case we have options for git or svn
$(TARGET_${P}).do_srcrev: $(TARGET_${P}).config

$(TARGET_${P}).do_prepare: $(TARGET_${P}).config
$(TARGET_${P}).config:
	@echo
	echo '$(foreach cfg,$(filter ${CONFIGS}, $(.VARIABLES)),$(cfg)=$($(cfg)) )' > $@
	test -f $@_old && diff -u $@_old $@ \
	  && (echo '==> $@ - old' && mv $@_old $@) \
	  || (echo '==> $@ - new' && rm -f $@_old)
	@echo

all-config: $(TARGET_${P}).config

]]function

help::
	@echo run \'make all-config\' after menuconfig/xconfig if you want to see what packages have new config
