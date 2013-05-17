//
//  GzViewController.h
//  GazApps
//
//  Created by sebastiao Gazolla Costa Junior on 20/12/11.
//  Copyright (c) 2011 iPhone and Java developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GzViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) IBOutlet UITableView *table;

@end
