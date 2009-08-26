//
//  AsynchronityAppDelegate.h
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright Dennis Blöte 2009. All rights reserved.
//


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

