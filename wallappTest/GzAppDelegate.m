//
//  GzAppDelegate.m
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "GzAppDelegate.h"
#import "MainViewController.h"
#import "AppDataConnection.h"
#import "CPMotionRecognizingWindow.h"
#import "GzLoadAppsData.h"
#import "Messages.h"

@implementation GzAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLogo:) name:@"hideLogo" object:nil];
  
    self.window = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MainViewController alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
        nav.navigationBar.tintColor = [UIColor blackColor];
        [nav setNavigationBarHidden:YES];
        self.window.rootViewController = nav;
    } else {
        self.viewController = [[MainViewController alloc] initWithNibName:@"MainViewController_iPad" bundle:nil];
        self.window.rootViewController = self.viewController;
    }
    
    [self showLogo:([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)];
    [self.window makeKeyAndVisible];
    _messages = [Messages sharedInstance];
    _messages.window = self.window;
    return YES;
}


-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


- (void) showLogo: (BOOL)isIpad {
    _logo = [CALayer layer];
    
    if (isIpad) {
        _logo.frame = CGRectMake(384,512, 0, 0);
    } else {
        _logo.frame = CGRectMake(160,240, 0, 0);
    }
	
	_logo.backgroundColor = [[UIColor clearColor] CGColor];
	_logo.contents = (id)[[UIImage imageNamed:@"wallapp.png"] CGImage]; // Sem o (id) vc recebe um warning
	[self.viewController.view.layer addSublayer:_logo];
	
	CGRect oldBounds = _logo.bounds;
    CGRect newBounds;
    if (isIpad) {
        newBounds = CGRectMake(10,200, 501, 132);
    } else {
        newBounds = CGRectMake(10,200, 300, 90);;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	animation.duration = 0.8f;
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    _logo.bounds = newBounds;
    [_logo addAnimation:animation forKey:@"bounds"];
    
}

-(void)hideLogo:(NSNotification *) notification{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	animation.duration = 0.8f;
    animation.fromValue = [NSValue valueWithCGRect:[_logo bounds]];
    animation.toValue = [NSValue valueWithCGRect:[self isIpad] ? CGRectMake(384,512, 0, 0) : CGRectMake(160,240, 0, 0)];
    _logo.bounds = [self isIpad] ? CGRectMake(384,512, 0, 0) : CGRectMake(160,240, 0, 0);
    [_logo addAnimation:animation forKey:@"bounds"];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger appLaunchAmounts = [userDefaults integerForKey:@"LaunchAmounts"];
    NSLog(@"LaunchAmounts: %d", appLaunchAmounts);
    if ((appLaunchAmounts == 6)||(appLaunchAmounts == 0))
    {
        NSLog(@">>>>>> RELOADING APPS DETAIL....");
        GzLoadAppsData *lad = [[GzLoadAppsData alloc]init];
        [lad deleteAppDetailsFile];
        [lad verifyArray];
        appLaunchAmounts = 1;
    }
    [userDefaults setInteger:appLaunchAmounts+1 forKey:@"LaunchAmounts"];
    [userDefaults synchronize];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
