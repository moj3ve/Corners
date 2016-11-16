

@interface  SBControlCenterContainerView : UIView
- (UIView *)dynamicsContainerView;
- (UIView *)contentContainerView;

@end

@interface SBControlCenterViewController : UIViewController
- (id)view;
@end


@interface SBControlCenterController : NSObject
+(id)sharedInstance;
@end

@interface SBNotificationCenterViewController : UIViewController
- (UIView *)backdropView;
- (void)setBlursBackground:(BOOL)fp8;
@end