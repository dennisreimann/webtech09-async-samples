@class AuthenticationController;

@interface AsynchronityAppDelegate : NSObject <UIApplicationDelegate> {
  @private
    UIWindow *window;
    UINavigationController *navigationController;
	AuthenticationController *authController;
}

- (void)authenticate;
- (void)authenticationSucceeded:(BOOL)success;

@end