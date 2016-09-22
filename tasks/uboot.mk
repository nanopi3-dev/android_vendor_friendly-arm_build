ifeq ($(TARGET_CPU_VARIANT2),s5p6818)

ifeq ($(BOARD_USES_UBOOT),true)

UBOOT_SRC := $(TARGET_UBOOT_SOURCE)
UBOOT_DEFCONFIG := $(TARGET_UBOOT_CONFIG)

UBOOT_OUT := $(TARGET_OUT_INTERMEDIATES)/UBOOT_OBJ
UBOOT_CONFIG := $(UBOOT_OUT)/.config

ifeq "$(wildcard $(UBOOT_SRC) )" ""
    ifneq ($(TARGET_PREBUILT_UBOOT),)
        NEEDS_UBOOT_COPY := true
        UBOOT_BIN := $(TARGET_PREBUILT_KERNEL)
    endif
else
    NEEDS_UBOOT_COPY := true
    UBOOT_BIN := $(UBOOT_OUT)/u-boot.bin
endif

TARGET_UBOOT_CROSS_COMPILE_PREFIX := $(strip $(TARGET_UBOOT_CROSS_COMPILE_PREFIX))
ifeq ($(TARGET_UBOOT_CROSS_COMPILE_PREFIX),)
UBOOT_TOOLCHAIN_PREFIX ?= arm-eabi-
else
UBOOT_TOOLCHAIN_PREFIX ?= $(TARGET_UBOOT_CROSS_COMPILE_PREFIX)
endif

ifeq ($(UBOOT_TOOLCHAIN),)
UBOOT_TOOLCHAIN_PATH := $(UBOOT_TOOLCHAIN_PREFIX)
else
ifneq ($(UBOOT_TOOLCHAIN_PREFIX),)
UBOOT_TOOLCHAIN_PATH := $(UBOOT_TOOLCHAIN)/$(UBOOT_TOOLCHAIN_PREFIX)
endif
endif

ifneq ($(USE_CCACHE),)
    ccache := $(ANDROID_BUILD_TOP)/prebuilts/misc/$(HOST_PREBUILT_TAG)/ccache/ccache
    # Check that the executable is here.
    ccache := $(strip $(wildcard $(ccache)))
endif

UBOOT_CROSS_COMPILE := CROSS_COMPILE="$(ccache) $(UBOOT_TOOLCHAIN_PATH)"
ccache =

$(UBOOT_OUT_STAMP):
	$(hide) mkdir -p $(UBOOT_OUT)
	$(hide) touch $@

$(UBOOT_CONFIG): $(UBOOT_OUT_STAMP)
	@echo -e ${CL_GRN}"Building U-Boot Config"${CL_RST}
	$(MAKE) -C $(UBOOT_SRC) O=$(UBOOT_OUT) $(UBOOT_CROSS_COMPILE) $(UBOOT_DEFCONFIG)

$(UBOOT_BIN): $(UBOOT_OUT_STAMP) $(UBOOT_CONFIG)
	@echo -e ${CL_GRN}"Building U-Boot"${CL_RST}
	$(MAKE) -C $(UBOOT_SRC) O=$(UBOOT_OUT) $(UBOOT_CROSS_COMPILE) $(notdir $@)

## Install it

ifeq ($(NEEDS_UBOOT_COPY),true)
file := $(INSTALLED_BOOTLOADER_TARGET)
ALL_PREBUILT += $(file)
$(file) : $(UBOOT_BIN) | $(ACP)
	$(transform-prebuilt-to-target)

ALL_PREBUILT += $(INSTALLED_BOOTLOADER_TARGET)
endif

endif # BOARD_USES_UBOOT

endif # TARGET_CPU_VARIANT2
