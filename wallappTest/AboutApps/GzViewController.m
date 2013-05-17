//
//  GzViewController.m
//  GazApps
//
//  Created by sebastiao Gazolla Costa Junior on 20/12/11.
//  Copyright (c) 2011 iPhone and Java developer. All rights reserved.
//

#import "GzViewController.h"
#import "GzLoadAppsData.h"
#import "GzAsyncImageCell.h"
#import "Reachability.h"
#import "SlidingMessageViewController.h"
#import "UACellBackgroundView.h"

@implementation GzViewController
@synthesize tableData, table;

GzLoadAppsData *conn;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)connection
{
    if (self.tableData != nil) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        int i = 0;
        for (NSArray *count in self.tableData) {
            [tempArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
        }
        
        self.tableData = nil;
        
        [self.table beginUpdates];
        [self.table deleteRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationTop];
        [self.table endUpdates];
        
        [self.table reloadData];
        
    }

    if ([self connected]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tabledataLoad:)
                                                     name:@"JsonNotification"
                                                   object:nil];
        
        conn = [[GzLoadAppsData alloc] init];
        [conn verifyArray];
    }else{
        [self internetWarning];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setContentSizeForViewInPopover:CGSizeMake(320, 500)];

    self.table.backgroundColor = [UIColor clearColor];
    self.table.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0783.PNG"]];
    [self connection];
}

-(void) tabledataLoad:(NSNotification *) notification{

    if ([[notification object] isKindOfClass:[GzLoadAppsData class]]) {
        GzLoadAppsData *lad = [notification object];
        self.tableData = lad.appDetails;
    }
    
    NSLog(@"Número de objs na tabledata: %i", [self.tableData count]);
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSArray *count in self.tableData) {
        [tempArray addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
    }

    
    [self.table beginUpdates];
    [self.table insertRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationTop];
    [self.table endUpdates];
    
  

}

-(void) loadData:(id) sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self connection];	

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
		return 70; // your dynamic height...
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    GzAsyncImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GzAsyncImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
        UACellBackgroundView *bkgView = [[UACellBackgroundView alloc] initWithFrame:cell.frame];
        if (indexPath.row == 0 ) {
            bkgView.position = UACellBackgroundViewPositionTop;
        } else if (indexPath.row == [self.tableData count] -1) {
            bkgView.position = UACellBackgroundViewPositionBottom;
        } else {
            bkgView.position = UACellBackgroundViewPositionMiddle;
        }
        cell.backgroundView = bkgView;

    }
    GazappsDetail *ad = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = ad.name;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [[ad.owner stringByAppendingFormat:@" - $"] stringByAppendingString:ad.price];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    [cell loadImageFromURL:ad.urlIcon];
        
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GazappsDetail *ad = [self.tableData objectAtIndex:indexPath.row];
    NSLog(@"%@", ad.url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.url]];

    
}

- (BOOL)connected
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];
	return !(netStatus == NotReachable);
}

- (void)internetWarning
{
    SlidingMessageViewController *msgVC = [[SlidingMessageViewController alloc] initWithTitle:@"Warning" message:@"The Internet connection appears to be offline."];
    [self.view addSubview:msgVC.view];
    [msgVC showMsgWithDelay:4.0];
}


@end
