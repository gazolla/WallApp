//
//  SlidingMessageViewController.h
//
//  http://iPhoneDeveloperTips.com
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"

@interface ToolBarViewController : UIViewController


@property (nonatomic, strong) UIToolbar *theToolbar;
@property (nonatomic, strong) UIBarButtonItem *btnHide;
@property (nonatomic, strong) UIBarButtonItem *btnRefresh;
@property (nonatomic, strong) UIBarButtonItem *btnPreferences;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) SettingViewController *set;
@property (nonatomic, strong) UINavigationController *navModal;
@property (nonatomic, strong) UIPopoverController *pop;


- (id)init;
- (void)showToolBar;
- (void)hideToolBar;
- (void)refresh:(id)sender;


@end
