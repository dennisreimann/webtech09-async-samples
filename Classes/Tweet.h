#import <UIKit/UIKit.h>


@interface Tweet : NSObject {
	NSString *fromUser;
	NSString *text;
	UIImage *avatar;
  @private
	NSURL *avatarURL;
}

@property (nonatomic, retain) NSString *fromUser;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIImage *avatar;

- (id)initWithJSONDictionary:(NSDictionary *)theDict;

@end
