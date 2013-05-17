//
//  SlidingMessageViewController.m
//
//  http://iPhoneDeveloperTips.com
//

#import "ToolBarViewController.h"
#import "GzAppDelegate.h"
#import "PlaySound.h"


@implementation ToolBarViewController

-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)showToolBar{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setToolBarOpen" object:nil];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.theToolbar.frame;
            //  frame.origin.y = [self isIpad] ? 974 : [[UIScreen mainScreen] bounds].size.height - 70;
            frame.origin.y = [[UIScreen mainScreen] bounds].size.height - 70;
            self.theToolbar.frame = frame;}];
        
        [[PlaySound sharedInstance] playServoOpen];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setToolBarOpen" object:nil];
}

- (void)hideToolBar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setToolBarClose" object:nil];

    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.theToolbar.frame;
        frame.origin.y = [self isIpad] ? 1024 : [[UIScreen mainScreen] bounds].size.height;
        self.theToolbar.frame = frame;}];

    [[PlaySound sharedInstance] playServoClose];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setToolBarClose" object:nil];

}


- (id)init{
  if (self == [super init]) {
      [self initial];
  }
    return self;
}

-(void) initial{
    [[PlaySound sharedInstance] playServoOpen];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshToolBar:) name:@"refreshToolBar" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"setToolBarClose" object:nil];
    self.theToolbar = [UIToolbar new];
    self.theToolbar.barStyle = UIBarStyleBlack;// StyleBlackTranslucent;
    [self.theToolbar sizeToFit];
    self.theToolbar.frame = [self isIpad] ? CGRectMake(0, 1024, 768, 50): CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 50);
     _btnHide = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowdownWhite.png"] style:UIBarButtonItemStylePlain target:self action:@selector(hide:)];
    _btnRefresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refreshWhite.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    _btnPreferences = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preferencesWhite.png"] style:UIBarButtonItemStylePlain target:self action:@selector(preferences:)];

    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    NSArray *items;
    //Add buttons to the array
    if ([self isIpad]) {
        items = [NSArray arrayWithObjects: flexItem, _btnRefresh, flexItem, _btnPreferences, nil];
    } else {
        items = [NSArray arrayWithObjects: _btnHide, flexItem, _btnRefresh, flexItem, _btnPreferences, nil];
    }
    [_theToolbar setItems:items animated:YES];
}

-(void) hide:(id)sender{
    if (![self isIpad]) {
        [[PlaySound sharedInstance] playClick];
    }
	[self hideToolBar];
}

-(void) games:(id)sender{
	[[PlaySound sharedInstance] playClick];	//label.text = @"Take Action";
}
-(void) preferences:(UIBarButtonItem *)sender{
    UIButton *btn = (UIButton *) sender; 
	[[PlaySound sharedInstance] playClick];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMessageTimer" object:nil];

    _set = [[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _set.title = @"Preferences";
    [_set.navigationItem setTitle:@"Preferences"];
   if ([self isIpad]) {

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_set];
        _pop = [[UIPopoverController alloc] initWithContentViewController:nav];
        _pop.delegate = _set;
        UIView *view = [btn valueForKey:@"view"];
        [_pop presentPopoverFromRect:view.frame inView:_theToolbar permittedArrowDirections:UIPopoverArrowDirectionDown  animated:YES];
        
       // [pop setPassthroughViews:[NSArray arrayWithObject:self.view]];
    } else {
        [_navController pushViewController:_set animated:YES];
        
       // _navModal = [[UINavigationController alloc] init];
       // [_navModal setView:_theToolbar];
        //[_navModal presentViewController:_navController animated:YES completion:nil];
    }
}

-(void) refreshToolBar:(NSNotification *) notification{
    [_navModal dismissViewControllerAnimated:YES completion:nil];
    [self refresh:nil];
}

-(void) refresh:(id)sender{
    if (![self isIpad]) {
         [self hideToolBar];
    }
	[[PlaySound sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimer" object:nil];

}


@end