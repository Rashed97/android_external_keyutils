LOCAL_PATH := $(my-dir)

include $(CLEAR_VARS)

SPECFILE	:= $(LOCAL_PATH)/keyutils.spec
VERSIONFILE := $(LOCAL_PATH)/version.lds

###############################################################################
#
# Determine the current package version from the specfile
#
###############################################################################
vermajor	:= $(shell grep "%define vermajor" $(SPECFILE))
verminor	:= $(shell grep "%define verminor" $(SPECFILE))
MAJOR		:= $(word 3,$(vermajor))
MINOR		:= $(word 3,$(verminor))
VERSION		:= $(MAJOR).$(MINOR)

###############################################################################
#
# Determine the current library version from the version script
#
###############################################################################
libversion	:= $(filter KEYUTILS_%,$(shell grep ^KEYUTILS_ $(VERSIONFILE)))
libversion	:= $(lastword $(libversion))
libversion	:= $(lastword $(libversion))
APIVERSION	:= $(subst KEYUTILS_,,$(libversion))
vernumbers	:= $(subst ., ,$(APIVERSION))
APIMAJOR	:= $(firstword $(vernumbers))

###############################################################################
#
# Build the libraries
#
###############################################################################
LOCAL_CFLAGS := \
    -DPKGBUILD="\"$(shell date -u +%F)\"" \
    -DPKGVERSION="\"keyutils-$(VERSION)\"" \
    -DAPIVERSION="\"libkeyutils-$(APIVERSION)\""

LOCAL_C_INCLUDES := $(KERNEL_HEADERS)
LOCAL_SRC_FILES := keyutils.c
LOCAL_MODULE := libkeyutils
LOCAL_SHARED_LIBRARIES := libcutils libc
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
