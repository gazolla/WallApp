//
//  SettingViewController.m
//  Setting
//
//  Created by Gazolla on 20/04/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "SettingViewController.h"
#import "Settings.h"
#import "SVSegmentedControl.h"
#import "UACellBackgroundView.h"
#import "CountryViewController.h"
#import "GzColors.h"
#import "AboutViewController.h"
#import "GzViewController.h"
#import "PlaySound.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

-(void)loadItems
{
    
    self.topRankItems = [NSArray arrayWithObjects:@"Top 100 Paid", @"Top 100 Free", @"Top Grossing" ,nil];
    self.plataformItems = [NSArray arrayWithObjects:@"iPhone", @"iPad", nil];
	self.effectsItems = [NSArray arrayWithObjects:@"Randon Apps", @"Sound Effects", @"Messages", nil];
	self.gazappsItems = [NSArray arrayWithObjects:@"About", @"Our apps", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0783.PNG"]];
    [self.tableView setBackgroundView:iv];

    self.navigationController.navigationBarHidden = NO;
    [self setContentSizeForViewInPopover:CGSizeMake(320, 500)];
    [self loadItems];
    [[Settings sharedInstance] loadSettings];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 100.0)];
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	
	if (section == 0) {
		headerLabel.text = @"DataSource";
	} else if (section == 1) {
		headerLabel.text = @"Effects";
	} else if (section == 2){
		headerLabel.text = @"Gazapps";
	}
	
	[customView addSubview:headerLabel];
	
	return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return [_effectsItems count];
    } else {
        return [_gazappsItems count];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.isOrientationChanged = YES;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Countries *countries = [Countries sharedInstance];
    Settings *settings = [Settings sharedInstance];
    [settings loadSettings];
    _country = settings.country;
    static NSString *CellIdentifierPlataform = @"Plataform";
    static NSString *CellIdentifierTopRank = @"topRank";
    static NSString *CellIdentifierCountry = @"Country";
    static NSString *CellIdentifierswicth = @"CellIdentifierswicth";
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell;
    NSString *item = nil;
    
    CGFloat width;
    
    if ([self isIpad]) {
        width = 300;
    }else {
       width = (self.interfaceOrientation==UIInterfaceOrientationPortrait) ?
        [[UIScreen mainScreen] bounds].size.width - 20 :
        [[UIScreen mainScreen] bounds].size.height - 20;
    }
    
    if (self.isOrientationChanged) {
        cell=nil;
        self.isOrientationChanged = NO;
    }
    
    
    if (cell == nil) {
        if (indexPath.section == 0) {
            UACellBackgroundView *bkgView = [[UACellBackgroundView alloc] initWithFrame:cell.frame];
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPlataform];
                cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                SVSegmentedControl *plataformSegment = [self createSegmentWithArray:_plataformItems width:width size:16 segmentIndex:([settings.iPhone isEqualToString:@"YES"])?0:1];
                plataformSegment.changeHandler = ^(NSUInteger newIndex) {
                    [[PlaySound sharedInstance] playClick];
                    if (newIndex == 0) {settings.iPhone = @"YES"; settings.iPad = @"NO";} else
                                        {settings.iPhone = @"NO"; settings.iPad = @"YES";}
                    [settings saveSettings];
                };
                [cell addSubview:plataformSegment];
                bkgView.position = UACellBackgroundViewPositionTop;
            } else if (indexPath.row == 1) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierTopRank];
                cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                int index;
                if ([settings.paidApps isEqualToString:@"YES"]) {index = 0;}
                else if ([settings.freeApps isEqualToString:@"YES"]) {index = 1;}
                else {index = 2;}                
                SVSegmentedControl *topRankSegment = [self createSegmentWithArray:_topRankItems width:width size:14 segmentIndex:index];
                topRankSegment.changeHandler = ^(NSUInteger newIndex) {
                    [[PlaySound sharedInstance] playClick];
                    if (newIndex == 0) {settings.paidApps = @"YES"; settings.freeApps = @"NO";settings.grossingApps = @"NO";}
                    else if (newIndex == 1) {settings.paidApps = @"NO"; settings.freeApps = @"YES";settings.grossingApps = @"NO";}
                    else if (newIndex == 2) {settings.paidApps = @"NO"; settings.freeApps = @"NO";settings.grossingApps = @"YES";}
                    [settings saveSettings];
                };
                [cell addSubview:topRankSegment];
                bkgView.position = UACellBackgroundViewPositionMiddle;
            } else if (indexPath.row == 2) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifierCountry];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor darkGrayColor];
                cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
                cell.textLabel.text = @"Country";
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.detailTextLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:14];
                cell.detailTextLabel.text = _country;
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
                cell.imageView.image = [UIImage imageNamed:[countries getFlagFileNameWithName:_country]];
                bkgView.position = UACellBackgroundViewPositionBottom;
            }
            cell.backgroundView = bkgView;
        }else if (indexPath.section == 1) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierswicth];
            UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
            [switchObj addTarget:self action:@selector(switchChange:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
            [switchObj setOnTintColor: [GzColors colorFromHex:SteelBlue]];
            item = [self.effectsItems objectAtIndex:indexPath.row];
            UACellBackgroundView *bkgView = [[UACellBackgroundView alloc] initWithFrame:cell.frame];
            
            if ([item isEqualToString:@"Randon Apps"]) {
                switchObj.on = [settings.randonApps isEqualToString:@"YES"]? YES: NO;
                switchObj.tag = 1;
                 bkgView.position = UACellBackgroundViewPositionTop;
            }
            if ([item isEqualToString:@"Sound Effects"]) {
                switchObj.on = [settings.soundEffects isEqualToString:@"YES"]? YES: NO;
                switchObj.tag = 2;
                 bkgView.position = UACellBackgroundViewPositionMiddle;
            }
            if ([item isEqualToString:@"Messages"]) {
                switchObj.on = [settings.messages isEqualToString:@"YES"]? YES: NO;
                switchObj.tag = 3;
                 bkgView.position = UACellBackgroundViewPositionBottom;
            }
            
            cell.accessoryView = switchObj;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            cell.textLabel.text = item;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundView = bkgView;

        } else if (indexPath.section == 2) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UACellBackgroundView *bkgView = [[UACellBackgroundView alloc] initWithFrame:cell.frame];
            bkgView.position = (indexPath.row == 0) ? UACellBackgroundViewPositionTop : UACellBackgroundViewPositionBottom;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            cell.textLabel.text = [self.gazappsItems objectAtIndex:indexPath.row];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundView = bkgView;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPlataform];
            } else if (indexPath.row == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTopRank];
            } else if (indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCountry];
            }
        }else if (indexPath.section == 1) {
            cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifierswicth];
        } else if (indexPath.section == 2) {
            cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
    }

    return cell;
}

-(void)switchChange:(id)sender
{
	[[PlaySound sharedInstance] playClick];
	Settings *settings = [Settings sharedInstance];
    [settings loadSettings];
	if ([(UISwitch *)sender tag]==1) {
		settings.randonApps = [(UISwitch *)sender isOn] ? @"YES" : @"NO";
	}
	if ([(UISwitch *)sender tag]==2) {
		settings.soundEffects = [(UISwitch *)sender isOn] ? @"YES" : @"NO";
	}
	if ([(UISwitch *)sender tag]==3) {
		settings.messages = [(UISwitch *)sender isOn] ? @"YES" : @"NO";
	}
	
	[settings saveSettings];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlaySound sharedInstance] playClick];
    if ((indexPath.section == 0)&&(indexPath.row == 2))  {
        _countryViewController = [[CountryViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _countryViewController.title = @"Countries";
        _countryViewController.currentItemString = _country;
        [_countryViewController addObserver:self forKeyPath:@"currentItemString" options:0 context:nil];
        [self.navigationController pushViewController:_countryViewController animated:YES];
    }
    if ((indexPath.section == 2)&&(indexPath.row == 0))  {
          AboutViewController *detailViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
          detailViewController.title = @"About";
          [self.navigationController pushViewController:detailViewController animated:YES];
    }
    if ((indexPath.section == 2)&&(indexPath.row == 1)) {
        GzViewController *detailViewController = [[GzViewController alloc] initWithNibName:@"GzViewController" bundle:nil];
        detailViewController.title = @"Our Apps";
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
      
        if ([keyPath isEqual:@"currentItemString"]) {
            _country = [_countryViewController currentItemString];
            Settings *settings = [Settings sharedInstance];
            [settings loadSettings];
            settings.country = _country;
            [settings saveSettings];
            [self.tableView reloadData];
            NSLog(@"text: %@", [_countryViewController currentItemString]);
            Countries *c = [Countries sharedInstance];
            [c loadCountries];
            NSLog(@"Country Name: %@  Country Code: %@", [_countryViewController currentItemString], [c getCountryCode:[_countryViewController currentItemString]]);
        }
}

#pragma mark - creational methods

-(SVSegmentedControl *) createSegmentWithArray:(NSArray *) items width:(CGFloat)width size:(int)size segmentIndex:(int)index{
    SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:items];
    navSC.backgroundTintColor = [UIColor clearColor];
    navSC.textColor = [UIColor blackColor];
    navSC.textShadowColor = [UIColor clearColor];
    navSC.innerShadowColor = [UIColor clearColor];
    CGRect frame = CGRectMake(10, 0, width, 46);
    navSC.frame = frame;
    navSC.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:size];
    [navSC setSelectedSegmentIndex:index animated:NO];
    return navSC;
}


//---called when the user clicks outside the popover view---
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    NSLog(@"popover about to be dismissed");
    return YES;
}

//---called when the popover view is dismissed---
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [[Settings sharedInstance] saveSettings];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToolBar" object:nil];
}

//Metodo que faz fecha o xib e volta pro gamescene
-(void)dismissView {
	[[Settings sharedInstance] saveSettings];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToolBar" object:nil];
}

-(void) dealloc {
      [_countryViewController removeObserver:self forKeyPath:@"currentItemString"];
}

@end
