//
//  SetViewController.m
//  wallappTest
//
//  Created by Gazolla on 29/03/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "SetViewController.h"


@interface SetViewController ()

@end

@implementation SetViewController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}


-(void)loadItems
{
	self.tableItemsSection1 = [NSArray arrayWithObjects:@"Show Paid Apps", @"Show Free Apps", nil];
	self.tableItemsSection2 = [NSArray arrayWithObjects:@"Randon Apps", @"Sound Effects", @"Messages", nil];
	self.tableItemsSection3 = [NSArray arrayWithObjects:@"About", @"Our Apps", nil];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	// Esse método está aqui simplesmente para que a View responda aos touches e não a scene do cocos.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0783.PNG"]];
    [self.tableView setBackgroundView:iv];
    
    [self setContentSizeForViewInPopover:CGSizeMake(320, 500)];

	[self loadItems];
	[[Settings sharedInstance] loadSettings];
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//    [UIView setAnimationDuration:duration];
//    [UIView beginAnimations:nil context:NULL];
//    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//    self.view.frame = frame;
//    [UIView commitAnimations];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[PlaySound sharedInstance] playClick];
    [[Settings sharedInstance] saveSettings];
//	[self dismissView];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

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
		headerLabel.text = @"Platform";
	} else	if (section == 1) {
		headerLabel.text = @"DataSource";
	} else if (section == 2) {
		headerLabel.text = @"Effects";
	} else if (section == 3){
		headerLabel.text = @"Gazapps";
	}
	
	[customView addSubview:headerLabel];
	
	return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if (_dropDownOpen0) {
            return 3;
        } else {
            return 1;
        }
	} else if (section == 1) {
		if (_dropDownOpen) {
            return 4;
        } else {
            return 1;
        }
	} else if (section == 2) {
		return [_tableItemsSection2 count];
	} else {
		return [_tableItemsSection3 count];
	}
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Settings *settings = [Settings sharedInstance];
    static NSString *CellIdentifierswicth = @"CellSwitch";
    static NSString *CellIdentifier = @"Cell";
    static NSString *DropDownCellIdentifier = @"DropDownCell";
    UITableViewCell *cell = nil;
	NSString *item = nil;
	
	if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DropDownCell *cell = (DropDownCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
            
            if (cell == nil){
                NSLog(@"New Cell Made");
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell" owner:nil options:nil];
                 for(id currentObject in topLevelObjects){
                    if([currentObject isKindOfClass:[DropDownCell class]]) {
                        cell = (DropDownCell *)currentObject;
                        break;
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
            
            if ([settings.iPad isEqualToString:@"YES"]) {
                [[cell textLabel] setText:@"iPad"];
            } else if ([settings.iPhone isEqualToString:@"YES"]) {
                [[cell textLabel] setText:@"iPhone"];
            } 
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
            cell.textLabel.textColor = [UIColor blackColor];
            if (indexPath.row == 1) {
                [[cell textLabel] setText:@"iPad"];
                cell.accessoryType = [settings.iPad isEqualToString:@"YES"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            } else if (indexPath.row == 2) {
                [[cell textLabel] setText:@"iPhone"];
                cell.accessoryType = [settings.iPhone isEqualToString:@"YES"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
            // Configure the cell.
            return cell;
        }
		
		
	} else 	if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            DropDownCell *cell = (DropDownCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
            
            if (cell == nil){
                NSLog(@"New Cell Made");
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[DropDownCell class]])
                    {
                        cell = (DropDownCell *)currentObject;
                        break;
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
            
            if ([settings.paidApps isEqualToString:@"YES"]) {
                [[cell textLabel] setText:@"Show Top 100 Paid Apps"];
            } else if ([settings.freeApps isEqualToString:@"YES"]) {
                [[cell textLabel] setText:@"Show Top 100 Free Apps"];
            } else if ([settings.grossingApps isEqualToString:@"YES"]) {
                [[cell textLabel] setText:@"Show Top 100 Grossing Apps"];
            }
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
            cell.textLabel.textColor = [UIColor blackColor];
            if (indexPath.row == 1) {
                [[cell textLabel] setText:@"Show Top 100 Paid Apps"];
                cell.accessoryType = [settings.paidApps isEqualToString:@"YES"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            } else if (indexPath.row == 2) {
                [[cell textLabel] setText:@"Show Top 100 Free Apps"];
                cell.accessoryType = [settings.freeApps isEqualToString:@"YES"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            } else if (indexPath.row == 3) {
                [[cell textLabel] setText:@"Show Top 100 Grossing Apps"];
                cell.accessoryType = [settings.grossingApps isEqualToString:@"YES"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
            // Configure the cell.
            return cell;
        }
		
		
	}else if (indexPath.section == 2) {
		cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifierswicth];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierswicth];
		}
		UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
		[switchObj addTarget:self action:@selector(switchChange:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
		item = [self.tableItemsSection2 objectAtIndex:indexPath.row];
        
		if ([item isEqualToString:@"Randon Apps"]) {
			switchObj.on = [settings.randonApps isEqualToString:@"YES"]? YES: NO;
			switchObj.tag = 1;
		}
		if ([item isEqualToString:@"Sound Effects"]) {
			switchObj.on = [settings.soundEffects isEqualToString:@"YES"]? YES: NO;
			switchObj.tag = 2;
		}
		if ([item isEqualToString:@"Messages"]) {
			switchObj.on = [settings.messages isEqualToString:@"YES"]? YES: NO;
			switchObj.tag = 3;
		}
        
		cell.accessoryView = switchObj;
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
		cell.textLabel.text = item;
	} else if (indexPath.section == 3) {
		cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
		cell.textLabel.text = [self.tableItemsSection3 objectAtIndex:indexPath.row];
	}
    
	
	
    
    return cell;
}

-(void)switchChange:(id)sender
{
	[[PlaySound sharedInstance] playClick];
	Settings *settings = [Settings sharedInstance];

	if ([(UISwitch *)sender tag]==1) {
		settings.randonApps = [(UISwitch *)sender isOn] ? @"YES" : @"NO";
	}
	if ([(UISwitch *)sender tag]==2) {
		settings.soundEffects = [(UISwitch *)sender isOn] ? @"YES" : @"NO";
	}
	if ([(UISwitch *)sender tag]==3) {
		settings.messages = [(UISwitch *)sender isOn] ? @"YES" : @"NO";
	}
	
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlaySound sharedInstance] playClick];
    Settings *settings= [Settings sharedInstance];
    NSLog(@"indexPath.section: %d", indexPath.section);
    if (indexPath.section == 0) {
        switch ([indexPath row]) {
            case 0:
            {
                DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:indexPath];
                if (![[[cell textLabel]text] isEqualToString:@""]) {
                    _oldText = [[cell textLabel]text];
                }
                [[cell textLabel] setText:@""];
                NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
    
                NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
                
                if ([cell isOpen]){
                    [cell setClosed];
                    _dropDownOpen0 = [cell isOpen];
                    [[cell textLabel] setText:_oldText];
                    _oldText = @"";
                    [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                } else {
                    [cell setOpen];
                    _dropDownOpen0 = [cell isOpen];
                     [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                }
                
                break;
            }
            default:
            {
                _dropDown0 = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
                DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:path];
                [[cell textLabel] setText:_dropDown0];
                 settings.iPad = [_dropDown0 isEqualToString:@"iPad"] ? @"YES" : @"NO";
                settings.iPhone = [_dropDown0 isEqualToString:@"iPhone"] ? @"YES" : @"NO";
                
                // close the dropdown cell
                
                NSIndexPath *path0 = [NSIndexPath indexPathForRow:[path row]+1 inSection:[indexPath section]];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:[path row]+2 inSection:[indexPath section]];
 
                NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
                
                [cell setClosed];
                _dropDownOpen0 = [cell isOpen];
                
                [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                
                break;
            }
        }
    }
    if (indexPath.section == 1) {
        switch ([indexPath row]) {
            case 0:
            {
                DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:indexPath];
                
                if (![[[cell textLabel]text] isEqualToString:@""]) {
                    _oldText = [[cell textLabel]text];
                }
                
                [[cell textLabel] setText:@""];
                
                NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                NSIndexPath *path2 = [NSIndexPath indexPathForRow:[indexPath row]+3 inSection:[indexPath section]];
               
                
                NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, nil];
                
                if ([cell isOpen])
                {
                    [cell setClosed];
                    _dropDownOpen = [cell isOpen];
                    [[cell textLabel] setText:_oldText];
                    _oldText = @"";
                    [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                }
                else
                {
                    [cell setOpen];
                    _dropDownOpen = [cell isOpen];
                    
                    [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                }
                
                break;
            }
            default:
            {
                _dropDown = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
                DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:path];
                
                [[cell textLabel] setText:_dropDown];
                
                settings.paidApps = [_dropDown isEqualToString:@"Show Top 100 Paid Apps"] ? @"YES" : @"NO";
                settings.freeApps = [_dropDown isEqualToString:@"Show Top 100 Free Apps"] ? @"YES" : @"NO";
                settings.grossingApps = [_dropDown isEqualToString:@"Show Top 100 Grossing Apps"] ? @"YES" : @"NO";
                
                // close the dropdown cell
                
                NSIndexPath *path0 = [NSIndexPath indexPathForRow:[path row]+1 inSection:[indexPath section]];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:[path row]+2 inSection:[indexPath section]];
                NSIndexPath *path2 = [NSIndexPath indexPathForRow:[path row]+3 inSection:[indexPath section]];
                
                NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2,nil];
                
                [cell setClosed];
                _dropDownOpen = [cell isOpen];
                
                [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                
                break;
            }
        }
    }
    
    if ((indexPath.section == 3)&&(indexPath.row == 0))  {
        AboutViewController *detailViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        detailViewController.title = @"About";
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    if ((indexPath.section == 3)&&(indexPath.row == 1)) {
        GzViewController *detailViewController = [[GzViewController alloc] initWithNibName:@"GzViewController" bundle:nil];
        detailViewController.title = @"Our Apps";
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// e.g. self.myOutlet = nil;
}

@end
