
#import "WHeaders.h"

static CGRect screenRect = [[UIScreen mainScreen] bounds];
    
static CGFloat screenWidth = screenRect.size.width;

static CGFloat screenHeight = screenRect.size.height;

static NSMutableDictionary *rootObj;

static void syncPreferences() { //call this to force syncronize your prefs when you change them
    
    CFStringRef appID = CFSTR("com.irepo.corners");
    
    CFPreferencesSynchronize(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    
    
}
static void PreferencesChangedCallback() { // call this on tweak load to initialize the dictionary and then call it when you need to reference the plist
    
   syncPreferences();

    CFStringRef appID = CFSTR("com.irepo.corners");
    
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    
    if (!keyList) {
        
        NSLog(@"There's been an error getting the key list!");
        return;
        
    }
    
    rootObj = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
    
    if (!rootObj) {
        
        NSLog(@"There's been an error getting the preferences dictionary!");
        
    }
    
    CFRelease(keyList);
    
}

static void savePrefs (id key, id value) { //call this to save a prefs value to plist
    
    if ([value isKindOfClass:NSClassFromString(@"NSArray")] || [value isKindOfClass:NSClassFromString(@"NSMutableArray")]) {

      NSLog(@"Saving ARRAY: %@", value);

      CFPreferencesSetValue ((__bridge CFStringRef)key,(__bridge CFArrayRef)value, CFSTR("com.irepo.corners"), kCFPreferencesCurrentUser , kCFPreferencesAnyHost);

    } else {

      NSLog(@"Saving STRING");

      CFPreferencesSetValue ((__bridge CFStringRef)key,(__bridge CFStringRef)value, CFSTR("com.irepo.corners"), kCFPreferencesCurrentUser , kCFPreferencesAnyHost);

    }

    syncPreferences();
    
}

%ctor {

  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.irepo.corners.plist"];

  if (!fileExists) {

      NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"dark" : [NSNumber numberWithBool:YES] , @"ccenabled" : [NSNumber numberWithBool:YES] , @"ncenabled" : [NSNumber numberWithBool:YES] , @"enabled" : [NSNumber numberWithBool:YES] , @"ccradius" : [NSNumber numberWithFloat:25.0] , @"ncradius" : [NSNumber numberWithFloat:25.0]}];

      [tempDict writeToFile:@"/var/mobile/Library/Preferences/com.irepo.corners.plist" atomically:YES];

  }

  PreferencesChangedCallback();

}





%hook SBNotificationCenterViewController 

- (void)viewWillLayoutSubviews {

    %orig;


    PreferencesChangedCallback();

    BOOL enabled = [[rootObj objectForKey:@"enabled"] boolValue];

    CGFloat radius = [[rootObj objectForKey:@"ncradius"] floatValue];

    BOOL ncenabled = [[rootObj objectForKey:@"ncenabled"] boolValue];

  if (enabled && ncenabled) {

      UIView *view = MSHookIvar<UIView *>(self,"_backgroundView");

      view.layer.cornerRadius = radius;

      view.clipsToBounds = YES;

      view.userInteractionEnabled = YES;

  } else {


      UIView *view = MSHookIvar<UIView *>(self,"_backgroundView");

      view.layer.cornerRadius = 0.0;

      view.clipsToBounds = YES;

      view.userInteractionEnabled = YES;

  }

}


%end
%hook SBControlCenterContainerView


- (void)layoutSubviews
 {

    %orig;

    PreferencesChangedCallback();

    BOOL enabled = [[rootObj objectForKey:@"enabled"] boolValue];

    BOOL ccenabled = [[rootObj objectForKey:@"ccenabled"] boolValue];

    CGFloat radius = [[rootObj objectForKey:@"ccradius"] floatValue];

  if (enabled && ccenabled) {

      UIView *view = MSHookIvar<UIView *>(self,"_darkeningView");

      if ([[rootObj objectForKey:@"dark"] boolValue]) {

        view.hidden = YES;

      } else {

        view.hidden = NO;

      }

	    self.dynamicsContainerView.layer.cornerRadius = radius;

	    self.dynamicsContainerView.clipsToBounds = YES;


	   view.layer.cornerRadius = radius;

	   view.clipsToBounds = YES;

	   view.userInteractionEnabled = YES;

  } else {

     UIView *view = MSHookIvar<UIView *>(self,"_darkeningView");
     view.alpha = 1.0;
     
     self.dynamicsContainerView.layer.cornerRadius = 0.0;
     self.dynamicsContainerView.clipsToBounds = YES;

     view.layer.cornerRadius = 0.0;
     view.clipsToBounds = YES;
     view.userInteractionEnabled = YES;

  }



}

%end