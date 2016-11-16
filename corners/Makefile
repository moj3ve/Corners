ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = Corners
Corners_FILES = Corners.mm
Corners_INSTALL_PATH = /Library/PreferenceBundles
Corners_FRAMEWORKS = UIKit
Corners_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Corners.plist$(ECHO_END)
