@interface AsynchronityAppDelegate : NSObject <UIApplicationDelegate> {
	NSOperationQueue *queue;
  @private
    IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;
}

@property (nonatomic, readonly) NSOperationQueue *queue;

+ (id)shared;

@end