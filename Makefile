
TARGET := iphone:clang:latest:14.0

ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EducationalTweak

EducationalTweak_FILES = Tweak.xm
EducationalTweak_CFLAGS = -fobjc-arc
EducationalTweak_FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
