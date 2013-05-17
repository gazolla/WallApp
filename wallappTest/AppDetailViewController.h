//
//  ViewController.h
//  SemiModal2ViewTest
//
//  Created by sebastiao Gazolla Costa Junior on 08/07/11.
//  Copyright 2011 iPhone and Java developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDetail.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDetailViewController : UIViewController {
    
   IBOutlet UIImageView *appIcon;
    IBOutlet UILabel *appPosition;
    IBOutlet UILabel *appName;
   IBOutlet UILabel *appCategory;
   IBOutlet UILabel *appPrice;
   IBOutlet UILabel *appSeller;
   AppDetail *appDetail;
}
@property (nonatomic, strong) IBOutlet UILabel *appPosition;
@property (nonatomic, strong) IBOutlet UIImageView *appIcon;
@property (nonatomic, strong) IBOutlet UILabel *appName;
@property (nonatomic, strong) IBOutlet UILabel *appCategory;
@property (nonatomic, strong) IBOutlet UILabel *appPrice;
@property (nonatomic, strong) IBOutlet UILabel *appSeller;
@property (nonatomic, strong) AppDetail *appDetail;
@property (strong, nonatomic) IBOutlet UIImageView *backGroundView;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnAppStore;
@property (strong, nonatomic) IBOutlet UILabel *lblAppName;
@property (strong, nonatomic) IBOutlet UILabel *lblAppCategory;
@property (strong, nonatomic) IBOutlet UILabel *lblAppPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblAppSeller;


- (IBAction)btnAppStoreClick:(id)sender;
- (IBAction)btnFacebookClick:(id)sender;
- (IBAction)btnTwitterClick:(id)sender;
- (IBAction)btnAddToFavoritesClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
-(void) drawPortraitView;
-(void) drawLandscapeView;


@end
