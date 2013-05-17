//
//  AboutViewController.m
//  AboutView
//
//  Created by sebastiao Gazolla Costa Junior on 19/07/11.
//  Copyright 2011 iPhone and Java developer. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GzCell.h"


@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setContentSizeForViewInPopover:CGSizeMake(320, 400)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		return 30; // your dynamic height...
	} else if (indexPath.row == 1) {
		return  80;
	} else if (indexPath.row == 3) {
		return 45;
	} else {
        return 45;
    }
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UACellBackgroundViewPosition pos;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = @"Thanks for purchase";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = NO;
    } else if (indexPath.row == 1) {
        UIImage* myImage = [UIImage imageNamed:@"wallapp-about"];
        UIImageView* myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40,20, myImage.size.width, myImage.size.height)];
        [myImageView setImage:myImage];	
        [cell.contentView addSubview:myImageView];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];

        
    } else if (indexPath.row == 2) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = @"Version: 1.5";
        cell.userInteractionEnabled = NO;
        
    } else if (indexPath.row == 3) {
        
        
        UIButton *button    = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        [button setFrame: CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
         [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"Contact us" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16]];
        //[button setTitleShadowColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        //[button.titleLabel setShadowOffset:CGSizeMake(1, 2)];
        [button setTintColor:[UIColor clearColor]];
        [button setBackgroundColor: [UIColor clearColor]];
       // button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 10.0f;
        [button addTarget:self action:@selector(contactus:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        pos = UACellBackgroundViewPositionSingle;
        UACellBackgroundView *bkgView = [[UACellBackgroundView alloc] initWithFrame:cell.frame];
        bkgView.position = pos;
        cell.backgroundView = bkgView;

    } else if (indexPath.row == 4) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = @"Powered by:";
        cell.userInteractionEnabled = NO;
    } else if (indexPath.row == 5) {
        UIImage* myImage = [UIImage imageNamed:@"gazapps.png"];
       
        UIImageView* myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70,0, myImage.size.width, myImage.size.height)];
        [myImageView setImage:myImage];	
        [cell.contentView addSubview:myImageView];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

-(void)contactus:(id)sender{
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"indexPath.row do About: %d", indexPath.row);
//    if (indexPath.row == 3) {
     //   [AudioEffect playClick];
        [self displayMailComposerSheet];
   // }
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayMailComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    [picker setToRecipients:[NSArray arrayWithObject:@"gz@gazapps.com"]];
    [picker setTitle:@"Hello Gazapps"];
    [picker setSubject:@"FeedBack - WallApp"];
	
	[self presentViewController:picker animated:YES completion:nil];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	NSString *message;
    NSString *title;
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
            title =  @"";
			message = @"Email canceled.";
			break;
		case MFMailComposeResultSaved:
            title =  @"Success";
			message = @"Email saved.";
			break;
		case MFMailComposeResultSent:
            title =  @"Success";
			message = @"Email sent.";
			break;
		case MFMailComposeResultFailed:
            title =  @"";
			message = @"Email failed.";
			break;
		default:
            title =  @"";
			message = @"Email not sent.";
			break;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle: @"Ok"
										  otherButtonTitles:nil];
	[alert show];
    
}

@end
