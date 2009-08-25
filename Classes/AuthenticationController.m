//
//  AuthenticationController.m
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright 2009 Dennis Blöte. All rights reserved.
//

#import "AuthenticationController.h"


#define kUsernameDefaultsKey @"username"
#define kPasswordDefaultsKey @"password"

@implementation AuthenticationController

- (id)initWithTarget:(id)theTarget andSelector:(SEL)theSelector {
	[super initWithNibName:@"Authentication" bundle:nil];
	target = theTarget;
	selector = theSelector;
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	usernameField.text = [defaults valueForKey:kUsernameDefaultsKey];
	passwordField.text = [defaults valueForKey:kPasswordDefaultsKey];
}

- (void)dealloc {
	[usernameField release];
	[passwordField release];
	[submitButton release];
    [super dealloc];
}

- (void)failWithMessage:(NSString *)theMessage {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication failed" message:theMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	submitButton.enabled = YES;
}

- (IBAction)submit:(id)sender {
	NSString *username = usernameField.text;
	NSString *password = passwordField.text;
	if (![username isEqualToString:@""] && ![password isEqualToString:@""]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setValue:username forKey:kUsernameDefaultsKey];
		[defaults setValue:password forKey:kPasswordDefaultsKey];
		[defaults synchronize];
		submitButton.enabled = NO;
		[target performSelector:selector];
	} else {
		[self failWithMessage:@"Please enter your username and password"];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (textField == usernameField) [passwordField becomeFirstResponder];
	if (textField == passwordField) [self submit:nil];
	return YES;
}

@end
