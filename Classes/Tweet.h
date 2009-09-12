#import <UIKit/UIKit.h>


@interface Tweet : NSObject {
	NSString *text;
	UIImage *avatar;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIImage *avatar;

- (id)initWithText:(NSString *)theText andAvatar:(UIImage *)theAvatar;

@end
