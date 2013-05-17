//
//  Messages.h
//  wallappTest
//
//  Created by Gazolla on 12/04/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlidingMessageViewController.h"

@interface Messages : NSObject

@property (unsafe_unretained) NSTimer *messageTimer;
@property (nonatomic, strong) SlidingMessageViewController *slideMessage;
@property (assign) bool isConnectionOk;
@property (nonatomic, strong) UIWindow *window;

- (void) stopMessageTimer:(NSNotification *) notification;
- (void) startMessageTimer:(NSNotification *) notification;
- (void) updateMessageTimer:(NSTimer *)theTimer;
+ (Messages *)sharedInstance;

@end
