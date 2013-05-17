//
//  GzViewController.h
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "AppDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDetailViewController.h"
#import "ToolBarViewController.h" 

@interface MainViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) ToolBarViewController *tbvc;
@property (strong) IBOutlet UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *buttonImageViewCollection;
@property (nonatomic, strong) NSMutableArray *appDetailCollection;
@property (assign) BOOL transposed;
@property (nonatomic, strong) AppDetail *appDetailSelected;
@property (nonatomic, strong) AppDetailViewController *appdvc;
@property (unsafe_unretained) NSTimer *randonAnimationTimer;
@property (assign) BOOL showDetail;
@property (assign) BOOL toolBarIsOpen;
@property (assign) BOOL isConnectionOk;

@end
