ARCHS = armv7 arm64
TARGET = iphone:clang:9.2
THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
THEOS_PACKAGE_DIR_NAME = debs
ADDITIONAL_OBJCFLAGS = -fobjc-arc
GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

TWEAK_NAME = Corners
Corners_FILES = Tweak.xm
Corners_FRAMEWORKS = UIKit CoreGraphics QuartzCore
Corners_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += corners
include $(THEOS_MAKE_PATH)/aggregate.mk
