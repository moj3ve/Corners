#import <Preferences/Preferences.h>

@interface CornersListController: PSListController {
}
@end

@implementation CornersListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Corners" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
