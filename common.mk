# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.setupwizard.rotation_locked=true


# RecueParty? No thanks.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.enable_rescue=false

# Show SELinux status on About Settings
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

# Mark as eligible for Google Assistant
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.opa.eligible_device=true

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# enable ADB authentication if not on eng build
ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/cache
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/citrus/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/citrus/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/citrus/prebuilt/common/bin/whitelist:system/addon.d/whitelist \

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/citrus/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/citrus/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Include low res bootanimation if display is less then 720p
TARGET_BOOTANIMATION_480 := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt 720 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Include high res bootanimation if display is greater then 1080p
TARGET_BOOTANIMATION_1440 := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -gt 1080 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Bootanimation
#qHD
ifeq ($(TARGET_BOOTANIMATION_480), true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/480.zip:system/media/bootanimation.zip
else
#HD
ifeq ($(TARGET_SCREEN_WIDTH), 720)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/720.zip:system/media/bootanimation.zip
else
#QHD
ifeq ($(TARGET_BOOTANIMATION_1440), true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/1440.zip:system/media/bootanimation.zip
else
#FHD
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/1080.zip:system/media/bootanimation.zip
endif
endif
endif

# Changelog
ifeq ($(CITRUS_RELEASE),true)
PRODUCT_COPY_FILES +=  \
    vendor/citrus/prebuilt/common/etc/Changelog.txt:system/etc/Changelog.txt
else
GENERATE_CHANGELOG := true
endif

# Dialer fix
PRODUCT_COPY_FILES +=  \
    vendor/citrus/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/citrus/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/citrus/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Copy all Citrus-specific init rc files
$(foreach f,$(wildcard vendor/citrus/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/citrus/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/citrus/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    libemoji \
    libsepol \
    e2fsck \
    bash \
    powertop \
    fibmap.f2fs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    Terminal \
    libbthost_if \
    WallpaperPicker

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    CellBroadcastReceiver \
    Stk \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

#RCS
PRODUCT_PACKAGES += \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Themes
PRODUCT_PACKAGES += \
    Margarita

# Substratum
#PRODUCT_PACKAGES += SubstratumService
#PRODUCT_SYSTEM_SERVER_APPS += SubstratumService

# World APN list
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/citrus/overlay/common
DEVICE_PACKAGE_OVERLAYS += vendor/citrus/overlay/common

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/citrus/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/citrus/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
endif

# include sounds from pixel
$(call inherit-product-if-exists, vendor/citrus/google/sounds/PixelSounds.mk)

# build official builds with private keys
ifeq ($(CITRUS_RELEASE),true)
include vendor/citrus-priv/keys.mk
endif

# include definitions for SDCLANG
include vendor/citrus/build/sdclang/sdclang.mk

# Citrus-CAF versions.
CAF_REVISION := LA.UM.7.3.r1-08200-sdm845.0
CITRUS_VERSION_FLAVOUR = KeyLime
CITRUS_VERSION_CODENAME := 5.0
PLATFORM_VERSION_FLAVOUR := Pie

ifndef CITRUS_BUILD_TYPE
ifeq ($(CITRUS_RELEASE),true)
    CITRUS_BUILD_TYPE := RELEASE
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d")
else
    CITRUS_BUILD_TYPE := COMMUNITY
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif
endif

ifdef CITRUS_BUILD_EXTRA
    CITRUS_POSTFIX := -$(CITRUS_BUILD_EXTRA)
endif

# Set all versions
CITRUS_VERSION := CitrusCAF-v$(CITRUS_VERSION_CODENAME)-$(CITRUS_VERSION_FLAVOUR)-$(PLATFORM_VERSION_FLAVOUR)-$(CITRUS_BUILD_TYPE)$(CITRUS_POSTFIX)
CITRUS_MOD_VERSION := CitrusCAF-v$(CITRUS_VERSION_CODENAME)-$(CITRUS_VERSION_FLAVOUR)-$(PLATFORM_VERSION_FLAVOUR)-$(CITRUS_BUILD)-$(CITRUS_BUILD_TYPE)$(CITRUS_POSTFIX)
CUSTOM_FINGERPRINT := Citrus-CAF/$(PLATFORM_VERSION)/$(CITRUS_VERSION_CODENAME)-$(CITRUS_VERSION_FLAVOUR)/$(TARGET_PRODUCT)/$(shell date +%Y%m%d-%H:%M)

# Citrus Bloats
PRODUCT_PACKAGES += \
    Camera2 \
    Launcher3 \
    LatinIME \
    LiveWallpapersPicker \
    AboutCitrus \
    SnapdragonGallery \
    MusicFX \
    CitrusHeaders \
    Calendar \
    FirefoxLite

# DU Utils Library
#PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

#PRODUCT_BOOT_JARS += \
    org.dirtyunicorns.utils

PRODUCT_PACKAGES += \
   OmniJaws \
   OmniStyle

# TCP Connection Management
PRODUCT_PACKAGES += tcmiface
PRODUCT_BOOT_JARS += tcmiface

# Turbo
PRODUCT_PACKAGES += Turbo
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/permissions/privapp-permissions-turbo.xml:system/etc/permissions/privapp-permissions-turbo.xml \
    vendor/citrus/prebuilt/common/etc/sysconfig/turbo-sysconfig.xml:system/etc/sysconfig/turbo-sysconfig.xml
