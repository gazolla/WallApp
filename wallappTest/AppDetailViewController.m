//
//  ViewController.m
//  SemiModal2ViewTest
//
//  Created by sebastiao Gazolla Costa Junior on 08/07/11.
//  Copyright 2011 iPhone and Java developer. All rights reserved.
//

#import "AppDetailViewController.h"
#import "MainViewController.h"
#import <Social/Social.h>
#import "PlaySound.h"



@implementation AppDetailViewController
@synthesize appIcon;
@synthesize appPosition;
@synthesize appName;
@synthesize appCategory;
@synthesize appPrice;
@synthesize appSeller;
@synthesize appDetail;


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

-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnAppStoreClick:(id)sender {
    NSLog(@"%@", appDetail.link);
    NSString *site_id = @"2754919";
    NSString *link = [appDetail.link stringByAppendingFormat:@"&partnerId=30&tduid=%@",site_id];
    
    NSLog(@"%@", link);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)btnFacebookClick:(id)sender {
    [[PlaySound sharedInstance] playClick];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *msg = [NSString stringWithFormat: @"Checkout this app: %@ ", appDetail.name];
        [controller setInitialText:msg];

        [controller addImage:appDetail.appIcon ];
        [self presentViewController:controller animated:YES completion:Nil];
    }

}

- (IBAction)btnTwitterClick:(id)sender {
    [[PlaySound sharedInstance] playClick];

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *msg = [NSString stringWithFormat: @"WallApp >> Checkout this app: %@", appDetail.name];
        [tweetSheet setInitialText:msg];
        [tweetSheet addImage:appDetail.appIcon ];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }

}

- (IBAction)btnAddToFavoritesClick:(id)sender {
}

- (IBAction)btnCancelClick:(id)sender {
     [[PlaySound sharedInstance] playClick];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noshowdetail" object:self]; 
}

-(void) drawPortraitView{
    [self.view.layer setCornerRadius:15.0f];
    [self.view.layer setMasksToBounds:YES];
    self.view.frame = CGRectMake(0, 0, 0, 0);
    [self.view.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.view.layer setBorderWidth: 2.0];
    
    self.view.frame = CGRectMake(10, 10, 228, 372);
    self.view.center = self.view.superview.center;
    
    self.view.alpha = 0.0;
}

-(void) drawLandscapeView{
    [self.view.layer setCornerRadius:15.0f];
    [self.view.layer setMasksToBounds:YES];
    self.view.frame = CGRectMake(0, 0, 0, 0);
    [self.view.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.view.layer setBorderWidth: 2.0];
    
    self.view.frame = CGRectMake(10, 5, 372, 228);
    self.view.center = self.view.superview.center;
    self.view.alpha = 0.0;
}

@end
