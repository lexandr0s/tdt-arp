#
# AR-P buildsystem smart Makefile
#
package[[ target_openssl

BDEPENDS_${P} = $(target_gcc_lib)

PR_${P} = 2

${P}_VERSION = 1.0.1g-30
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = stm-$(${P}).spec.patch
${P}_PATCHES = stm-$(${P})-1.0.1g-fix_pod_syntax.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ TARGET_target_rpm ]]
call[[ ipk ]]

PACKAGES_${P} =  libcrypto1 libssl1
DESCRIPTION_${P} = Secure Socket Layer (SSL) binary and related cryptographic tools.

FILES_libcrypto1 = /usr/lib/libcrypto.s*

RDEPENDS_libssl1 = libcrypto1
FILES_libssl1 = /usr/lib/libssl.s*

call[[ ipkbox ]]

]]package
