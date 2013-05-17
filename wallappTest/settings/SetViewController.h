//
//  SetViewController.h
//  wallappTest
//
//  Created by Gazolla on 29/03/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "PlaySound.h"
#import "AboutViewController.h"
#import "DropDownCell.h"
#import "GzViewController.h"

@interface SetViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UISwitch *paidAppSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *freeAppSwitch;
@property (nonatomic, strong) NSString *dropDown0;
@property (nonatomic, strong) NSString *dropDown;
@property (assign) BOOL dropDownOpen0;
@property (assign) BOOL dropDownOpen;


@property (nonatomic, strong) NSArray *tableItemsSection1;
@property (nonatomic, strong) NSArray *tableItemsSection2;
@property (nonatomic, strong) NSArray *tableItemsSection3;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *btnDone;
//@property (nonatomic, strong) IBOutlet UITableView *tableViewSettings;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;

@property (nonatomic, strong)  NSString *oldText;

-(void)dismissView;
-(void)loadItems;


@end
