//
//  AsynchronityAppDelegate.h
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright Dennis Blöte 2009. All rights reserved.
//

@interface AsynchronityAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

