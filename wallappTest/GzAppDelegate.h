//
//  GzAppDelegate.h
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Messages.h"

@class MainViewController;

@interface GzAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *viewController;
@property (strong, nonatomic) CALayer *logo;
@property (strong, nonatomic) Messages *messages;

@end
