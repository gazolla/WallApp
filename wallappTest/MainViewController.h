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

@interface MainViewController : UIViewController <UIScrollViewDelegate>

@property (strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *buttonImageViewCollection;

@end
