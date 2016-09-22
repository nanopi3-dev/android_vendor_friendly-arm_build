ifeq ($(TARGET_CPU_VARIANT2),s5p6818)

ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)
  INSTALLED_BOOTLOADER_TARGET := $(PRODUCT_OUT)/bootloader
  ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_BOOTLOADER_TARGET)
else
  INSTALLED_BOOTLOADER_TARGET :=
endif # TARGET_NO_BOOTLOADER

.PHONY: bootloader
bootloader: $(INSTALLED_BOOTLOADER_TARGET)

endif # TARGET_CPU_VARIANT2
