# Charger
ifneq ($(WITH_CUSTOM_CHARGER),false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.custom
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/data/cache
else
  ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/cache
endif
