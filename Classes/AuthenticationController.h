//
//  AuthenticationController.h
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright 2009 Dennis Blöte. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AuthenticationController : UIViewController <UITextFieldDelegate> {
  @private
	id target;
	SEL selector;
	IBOutlet UITextField *loginField;
	IBOutlet UITextField *tokenField;
	IBOutlet UIButton *submitButton;
}

- (id)initWithTarget:(id)theTarget andSelector:(SEL)theSelector;
- (IBAction)submit:(id)sender;
- (void)failWithMessage:(NSString *)theMessage;

@end
