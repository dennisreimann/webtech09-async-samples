//
//  main.m
//  Asynchronity
//
//  Created by Dennis Blöte on 25.08.09.
//  Copyright Dennis Blöte 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
