//
//  SettingViewController.h
//  Setting
//
//  Created by Gazolla on 20/04/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryViewController.h"

@interface SettingViewController : UITableViewController <UIPopoverControllerDelegate>

@property (assign) BOOL isOrientationChanged;
@property (nonatomic, strong) NSArray *plataformItems;
@property (nonatomic, strong) NSArray *topRankItems;
@property (nonatomic, strong) NSArray *effectsItems;
@property (nonatomic, strong) NSArray *gazappsItems;
@property (nonatomic, strong) CountryViewController *countryViewController;
@property (nonatomic,strong) NSString *country;

@end
