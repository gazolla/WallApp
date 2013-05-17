//
//  GzViewController.m
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "MainViewController.h"
#import "ButtonImage.h"
#import "PlaySound.h"
#import "UIResponder+MotionRecognizers.h"
#import "AppDataConnection.h"
#import "AppDetailViewController.h"
#import "ToolBarViewController.h"
#import "Settings.h"

@interface MainViewController ()

@end

static CGFloat _screenWidth;
static CGFloat _screenHeight;

@implementation MainViewController

+ (void) initialize {
    _screenWidth = [[UIScreen mainScreen] bounds].size.width;
    _screenHeight = [[UIScreen mainScreen] bounds].size.height;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (([self toolBarIsOpen])&&(! [self isIpad])) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToolBar" object:nil];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];

    _transposed = NO;
    [self loadAppsData:nil];
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRandonAnimation:) name:@"startRandonAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAppDetailView:) name:@"noshowdetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"ReloadImages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImages:) name:@"loadImages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setToolBarOpen:) name:@"setToolBarOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setToolBarClose:) name:@"setToolBarClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed:) name:@"connectionFailedMainView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRandonAnimation:) name:@"stopRandonAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetButtonsImage:) name:@"resetButtonsImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAppsData:) name:@"loadAppsData" object:nil];
    [self addMotionRecognizerWithAction:@selector(shakeWasRecognized:)];
	[self addScroll];
    [self addButtons];
    if ([self isIpad]) {
        [self showToolBar];
    }
}

- (void)showToolBar {
    self.tbvc = [[ToolBarViewController alloc] init];
    self.tbvc.navController = self.navigationController;
    [self.view addSubview:self.tbvc.theToolbar];
    [self.view bringSubviewToFront:self.tbvc.theToolbar];
    [self.tbvc showToolBar];
}

- (void) shakeWasRecognized:(NSNotification*)notif{
    NSLog(@"shaked !");
    if (![self isIpad]) {
        if (! self.toolBarIsOpen) {
            [self showToolBar];
        }
    }
}

-(void) connectionFailed:(NSNotification *) notification{
    self.isConnectionOk = NO;
}


//-(void) reload:(NSNotification *) notification{
//    [self stopRandonAnimation];
//    [self resetButtonsImage];
//    [self loadAppsData];
//}

-(void) setToolBarOpen:(NSNotification*)notif{
    [self setToolBarIsOpen:YES];
}

-(void)setToolBarClose:(NSNotification*)notif{
    [self setToolBarIsOpen:NO];
}

-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)addScroll{
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, _screenHeight)];
    _scroll.contentSize = [self isIpad] ? CGSizeMake(1050, 1050) : CGSizeMake(640, 640);
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
}

-(void)resetButtonsImage:(NSNotification *) notification{
    for (ButtonImage *imageButton in _buttonImageViewCollection) {
        [imageButton setImage:nil forState:UIControlStateSelected];
        [imageButton setSelected:NO];
         [imageButton setAlpha:0.3];
    }
}

- (void)addButtons{
    _buttonImageViewCollection = [NSMutableArray array];
    int count = 0;
    for (int i=0; i<=9; i++) {
        for (int j=0; j<=9; j++) {
            ButtonImage *imageButton = [ButtonImage buttonWithType:UIButtonTypeCustom];
            
            [imageButton setImage:[UIImage imageNamed:@"Launcher.png"] forState:UIControlStateNormal];
            [imageButton setSelected:NO];
            [imageButton setAlpha:0.3];
            [imageButton setNeedsDisplay];
            imageButton.frame = [self isIpad] ? CGRectMake(0+(i*100), 0+(j*97), 100, 100) : CGRectMake(0+(i*64), 0+(j*60), 55, 55);
            imageButton.tag = [[NSString stringWithFormat:@"%i%i", i, j] intValue];
            [imageButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonImageViewCollection addObject:imageButton];
            [_scroll addSubview:imageButton];
            count++;
        }
    }
}

-(void) loadAppsData:(NSNotification *) notification{
    dispatch_queue_t myQueue = dispatch_queue_create("com.gazapps.myqueue.processjson", 0);
    dispatch_async(myQueue, ^{
        AppDataConnection *adc = [[AppDataConnection alloc] init];
        [adc downloadAppData];
    });

}

-(void)loadImages: (NSNotification*) notification{
    self.isConnectionOk = YES;
    dispatch_queue_t myQueue = dispatch_queue_create("com.gazapps.myqueue.processjson", 0);
    dispatch_async(myQueue, ^{
        NSArray *buttonImageCollection = self.buttonImageViewCollection;
        _appDetailCollection = (NSMutableArray *) notification.object;
        if (_appDetailCollection != nil) {
            for (int counter = 0; counter<= [_appDetailCollection count]-1; counter++) {
                ButtonImage *buttonImage = [buttonImageCollection objectAtIndex:(counter)];
                AppDetail *ap  = [_appDetailCollection objectAtIndex:counter];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [buttonImage loadImageFromURL:ap.label100 ];
                });
                
                
                [buttonImage setAppDetail:ap];
            }
        }
   });

    
}

-(void)transpose{
    CGRect newFrame;
    [CATransaction begin];
    for (int i=0; i<=9; i++) {
        for (int j=0; j<=9; j++) {
             UIView *view = [_scroll viewWithTag:[[NSString stringWithFormat:@"%i%i", i, j] intValue]];
            if ([view isKindOfClass:[ButtonImage class]] ) {
                if ([self isIpad]) {
                    newFrame = (_transposed) ? CGRectMake(0+(i*100), 0+(j*97), 100, 100) : CGRectMake(0+(j*100), 0+(i*97), 100, 100);
                } else {
                    newFrame = (_transposed) ? CGRectMake(0+(i*64), 0+(j*60), 55, 55) : CGRectMake(0+(j*64), 0+(i*60), 55, 55);
                }
                [UIView animateWithDuration:0.8 animations:^{ view.layer.frame = newFrame;}];
             }
        }
    }
    [CATransaction commit];
    
    _transposed = ! _transposed;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ((orientation == UIDeviceOrientationPortrait)||((orientation == UIDeviceOrientationPortrait)&&(orientation == UIDeviceOrientationFaceUp))){
        [UIView animateWithDuration:0.5 animations:^{ _scroll.frame =  CGRectMake(0, 0, _screenWidth, _screenHeight);}];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startMessageTimer" object:nil];
        
        if (_transposed) {
            [self transpose];
         }
        if (_showDetail) {
            [UIView animateWithDuration:0.8 animations:^{
                CGFloat x = ( _screenWidth  - 248 )/2;
                CGFloat y = ( _screenHeight - 392 )/2;
                
                _appdvc.view.frame = CGRectMake(x, y, 248, 392);
                _appdvc.backGroundView.frame = CGRectMake(0, 0, 248, 392);
                _appdvc.lblAppName.frame = CGRectMake(10, 90, 230, _appdvc.lblAppName.frame.size.height);
                _appdvc.lblAppCategory.frame = CGRectMake(10, 140, 228, _appdvc.lblAppCategory.frame.size.height);
                _appdvc.lblAppPrice.frame = CGRectMake(10, 160, 228, _appdvc.lblAppPrice.frame.size.height);
                _appdvc.lblAppSeller.frame = CGRectMake(10, 175, 228, _appdvc.lblAppSeller.frame.size.height);
                [_appdvc.btnAppStore setAlpha:1];
                [_appdvc.btnFacebook setAlpha:1];
                [_appdvc.btnTwitter setAlpha:1];
                _appdvc.btnAppStore.frame = CGRectMake(13, 205, _appdvc.btnAppStore.frame.size.width, _appdvc.btnAppStore.frame.size.height);
                _appdvc.btnFacebook.frame = CGRectMake(13, 250, _appdvc.btnFacebook.frame.size.width, _appdvc.btnFacebook.frame.size.height);
                _appdvc.btnTwitter.frame = CGRectMake(13, 295, _appdvc.btnTwitter.frame.size.width, _appdvc.btnTwitter.frame.size.height);
                _appdvc.btnCancel.frame = CGRectMake(13, 345, _appdvc.btnCancel.frame.size.width, _appdvc.btnCancel.frame.size.height);}];
        }
    } else if ((orientation == UIDeviceOrientationLandscapeLeft)||(orientation == UIDeviceOrientationLandscapeRight)||((orientation == UIDeviceOrientationLandscapeLeft)&&(orientation == UIDeviceOrientationFaceUp))||((orientation == UIDeviceOrientationLandscapeRight)&&(orientation == UIDeviceOrientationFaceUp))) {
        [UIView animateWithDuration:0.5 animations:^{_scroll.frame =  CGRectMake(0, 0, _screenHeight, _screenWidth);}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMessageTimer" object:nil];
        
        if (! _transposed) {
            [self transpose];
        }
        if (_showDetail) {
            [UIView animateWithDuration:0.8 animations:^{
                CGFloat x = (_screenHeight - 392)/2;
                CGFloat y = (_screenWidth - 248)/2;
                
                
                _appdvc.view.frame = CGRectMake(x, y, 392, 248);
                _appdvc.backGroundView.frame = CGRectMake(0, 0, 392, 248);
                _appdvc.lblAppName.frame = CGRectMake(10, 82, 370, _appdvc.lblAppName.frame.size.height);
                _appdvc.lblAppCategory.frame = CGRectMake(10, 135, 372, _appdvc.lblAppCategory.frame.size.height);
                _appdvc.lblAppPrice.frame = CGRectMake(10, 155, 372, _appdvc.lblAppPrice.frame.size.height);
                _appdvc.lblAppSeller.frame = CGRectMake(10, 170, 372, _appdvc.lblAppSeller.frame.size.height);
                [_appdvc.btnAppStore setAlpha:0];
                [_appdvc.btnFacebook setAlpha:0];
                [_appdvc.btnTwitter setAlpha:0];
                _appdvc.btnCancel.frame = CGRectMake(90, 200, _appdvc.btnCancel.frame.size.width, _appdvc.btnCancel.frame.size.height);}];
        }
    }
    _appdvc.lblAppName.adjustsFontSizeToFitWidth = YES;
}


- (void)detailPortrait {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    
    [_appdvc.view.layer setCornerRadius:15.0f];
    [_appdvc.view.layer setMasksToBounds:YES];
    if ((orientation == UIDeviceOrientationPortrait)||(orientation == UIDeviceOrientationUnknown)||((uiOrientation == UIInterfaceOrientationPortrait)&&(orientation == UIDeviceOrientationFaceUp))){
        _appdvc.view.frame = CGRectMake((( _screenWidth  - 228 )/2), 1000, 228, 372);
    } else if ((orientation == UIDeviceOrientationLandscapeLeft)||(orientation == UIDeviceOrientationLandscapeRight)||((uiOrientation == UIInterfaceOrientationLandscapeLeft)&&(orientation == UIDeviceOrientationFaceUp))||((uiOrientation == UIInterfaceOrientationLandscapeRight)&&(orientation == UIDeviceOrientationFaceUp))) {
        _appdvc.view.frame = CGRectMake((( _screenHeight  - 372 )/2), 1000, 372, 228);
    }
    [_appdvc.view.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_appdvc.view.layer setBorderWidth: 2.0];
    
    

    _appdvc.lblAppName.adjustsFontSizeToFitWidth = YES;
    
    if ((orientation == UIDeviceOrientationPortrait)||(orientation == UIDeviceOrientationUnknown)||((uiOrientation == UIInterfaceOrientationPortrait)&&(orientation == UIDeviceOrientationFaceUp))){
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat x = ( _screenWidth  - 248 )/2;
            CGFloat y = ( _screenHeight - 392 )/2;

            _appdvc.view.frame = CGRectMake(x, y, 248, 392);
            _appdvc.backGroundView.frame = CGRectMake(0, 0, 248, 392);
            _appdvc.lblAppName.frame = CGRectMake(10, 90, 230, _appdvc.lblAppName.frame.size.height);
            _appdvc.lblAppCategory.frame = CGRectMake(10, 140, 228, _appdvc.lblAppCategory.frame.size.height);
            _appdvc.lblAppPrice.frame = CGRectMake(10, 160, 228, _appdvc.lblAppPrice.frame.size.height);
            _appdvc.lblAppSeller.frame = CGRectMake(10, 175, 228, _appdvc.lblAppSeller.frame.size.height);
            [_appdvc.btnAppStore setAlpha:1];
            [_appdvc.btnFacebook setAlpha:1];
            [_appdvc.btnTwitter setAlpha:1];
            _appdvc.btnAppStore.frame = CGRectMake(13, 205, _appdvc.btnAppStore.frame.size.width, _appdvc.btnAppStore.frame.size.height);
            _appdvc.btnFacebook.frame = CGRectMake(13, 250, _appdvc.btnFacebook.frame.size.width, _appdvc.btnFacebook.frame.size.height);
            _appdvc.btnTwitter.frame = CGRectMake(13, 295, _appdvc.btnTwitter.frame.size.width, _appdvc.btnTwitter.frame.size.height);
            _appdvc.btnCancel.frame = CGRectMake(13, 345, _appdvc.btnCancel.frame.size.width, _appdvc.btnCancel.frame.size.height);}];
        
    } else if ((orientation == UIDeviceOrientationLandscapeLeft)||(orientation == UIDeviceOrientationLandscapeRight)||((uiOrientation == UIInterfaceOrientationLandscapeLeft)&&(orientation == UIDeviceOrientationFaceUp))||((uiOrientation == UIInterfaceOrientationLandscapeRight)&&(orientation == UIDeviceOrientationFaceUp))) {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat x = (_screenHeight - 392)/2;
            CGFloat y = (_screenWidth - 248)/2;


            _appdvc.view.frame = CGRectMake(x, y, 392, 248);
            _appdvc.backGroundView.frame = CGRectMake(0, 0, 392, 248);
            _appdvc.lblAppName.frame = CGRectMake(10, 82, 370, _appdvc.lblAppName.frame.size.height);
            _appdvc.lblAppCategory.frame = CGRectMake(10, 135, 372, _appdvc.lblAppCategory.frame.size.height);
            _appdvc.lblAppPrice.frame = CGRectMake(10, 155, 372, _appdvc.lblAppPrice.frame.size.height);
            _appdvc.lblAppSeller.frame = CGRectMake(10, 170, 372, _appdvc.lblAppSeller.frame.size.height);
            [_appdvc.btnAppStore setAlpha:0];
            [_appdvc.btnFacebook setAlpha:0];
            [_appdvc.btnTwitter setAlpha:0];
            _appdvc.btnCancel.frame = CGRectMake(90, 200, _appdvc.btnCancel.frame.size.width, _appdvc.btnCancel.frame.size.height);}];
        
    }
    _appdvc.backGroundView.contentMode = UIViewContentModeScaleToFill;

    Settings *set = [Settings sharedInstance];
    if ([set.iPad isEqualToString:@"YES"]&&(! [self isIpad])) {
        [_appdvc.btnAppStore setHidden:YES];
        [_appdvc.btnAppStore setEnabled:NO];
    } else {
        [_appdvc.btnAppStore setHidden:NO];
        [_appdvc.btnAppStore setEnabled:YES];
    }
    

    _appdvc.view.alpha = 0.0;
}

-(void) buttonPushed:(id)sender{
    ButtonImage *bi = sender;
    _appDetailSelected = bi.appDetail;
    [[PlaySound sharedInstance] playClick];
    if (! _showDetail) {
        
        if (bi.appDetail != nil) {
            
            _showDetail = YES;
            
            if (_appdvc==nil) {
                _appdvc = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
            }

            [self detailPortrait];
            
            ButtonImage *image = [[ButtonImage alloc] init];
            _appdvc.appIcon.image = [image maskImage:bi.appDetail.appIcon];
            
            _appdvc.appPosition.text = [NSString stringWithFormat:@"#%@",_appDetailSelected.position];
            _appdvc.appName.text = [NSString stringWithFormat:@"%@",_appDetailSelected.name];
            _appdvc.appCategory.text = [NSString stringWithFormat:@"Category: %@",_appDetailSelected.category];
            _appdvc.appPrice.text = [NSString stringWithFormat:@"Price: %@", _appDetailSelected.price];
            _appdvc.appSeller.text = [NSString stringWithFormat:@"Seller: %@", bi.appDetail.artist];
            _appdvc.appDetail = _appDetailSelected;

            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _appdvc.view.alpha = 1.0;
            } completion:nil];
            
            [self.view addSubview:_appdvc.view];
        }
        
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            _appdvc.appIcon.alpha = 0.0;
            _appdvc.appPosition.alpha = 0.0;
            _appdvc.appName.alpha = 0.0;
            _appdvc.appCategory.alpha = 0.0;
            _appdvc.appPrice.alpha = 0.0;
            _appdvc.appSeller.alpha = 0.0;
        }];
        
        ButtonImage *image = [[ButtonImage alloc] init];
        _appdvc.appIcon.image = [image maskImage:bi.appDetail.appIcon];

        _appdvc.appPosition.text = [NSString stringWithFormat:@"#%@",_appDetailSelected.position];
        _appdvc.appName.text = [NSString stringWithFormat:@"%@",_appDetailSelected.name];
        _appdvc.appCategory.text = [NSString stringWithFormat:@"Category: %@",_appDetailSelected.category];
        _appdvc.appPrice.text = [NSString stringWithFormat:@"Price: %@", _appDetailSelected.price];
        _appdvc.appSeller.text = [NSString stringWithFormat:@"Seller: %@", bi.appDetail.artist];
        _appdvc.appDetail = _appDetailSelected;

        [UIView animateWithDuration:0.4 animations:^{
            _appdvc.appIcon.alpha = 1.0;
            _appdvc.appPosition.alpha = 1.0;
            _appdvc.appName.alpha = 1.0;
            _appdvc.appCategory.alpha = 1.0;
            _appdvc.appPrice.alpha = 1.0;
            _appdvc.appSeller.alpha = 1.0;
        }];

        
    }
}

- (void) dismissAppDetailView:(NSNotification*) notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if ((orientation == UIDeviceOrientationPortrait)||(orientation == UIDeviceOrientationUnknown)||((uiOrientation == UIInterfaceOrientationPortrait)&&(orientation == UIDeviceOrientationFaceUp))){
            _appdvc.view.frame = CGRectMake((( _screenWidth  - 228 )/2), 1000, 228, 372);
        } else if ((orientation == UIDeviceOrientationLandscapeLeft)||(orientation == UIDeviceOrientationLandscapeRight)||((uiOrientation == UIInterfaceOrientationLandscapeLeft)&&(orientation == UIDeviceOrientationFaceUp))||((uiOrientation == UIInterfaceOrientationLandscapeRight)&&(orientation == UIDeviceOrientationFaceUp))) {
            _appdvc.view.frame = CGRectMake((( _screenHeight  - 372 )/2), 1000, 372, 228);
        }
    } completion:^(BOOL finished){
        _showDetail = NO;
        [_appdvc.view removeFromSuperview];
    }];
    
}

- (void) startRandonAnimation:(NSNotification *) notification {
        Settings *settings = [Settings sharedInstance];
        
        if ([settings.randonApps isEqualToString:@"YES"]) {
            if (self.randonAnimationTimer == nil) {
                self.randonAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                            target:self
                                                          selector:@selector(updateRandonAnimation:)
                                                          userInfo:nil
                                                           repeats:YES];
            }
        }
}

- (void)updateRandonAnimation:(NSTimer *)theTimer {
    
    ButtonImage *i = nil;
    AppDetail *ap = nil;
    
    int randIdx = arc4random() % [_appDetailCollection count];
    ap = [_appDetailCollection objectAtIndex:randIdx];
    
    if (ap.appIcon) {
        i = [self.buttonImageViewCollection objectAtIndex:(arc4random()%[self.buttonImageViewCollection count])];
        if (i != nil) {
            [i setAppDetail:nil];
            
            int randIdx = arc4random() % [_appDetailCollection count];
            ap = [_appDetailCollection objectAtIndex:randIdx];
            [i setAppDetail:ap];
            [i setSelected:NO];
            
            ButtonImage *image = [[ButtonImage alloc] init];
            [i setImage:[image maskImage:ap.appIcon] forState:UIControlStateSelected];
            
            [i setSelected:YES];
            [i setAlpha:0.0];
            [UIView beginAnimations:@"fadeinout" context:nil];
            [UIView setAnimationDuration:0.8];
            [i setAlpha:1.0];
            [UIView commitAnimations];
        } else {
            NSLog(@"button not loaded..............");
        }
        
    } else {
        NSLog(@"image not loaded..............");
    }
}

-(void)stopRandonAnimation:(NSNotification *) notification{
	[self.randonAnimationTimer invalidate];
    self.randonAnimationTimer = nil;
}


-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRandonAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noshowdetail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadImages" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadImages" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setToolBarOpen" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setToolBarClose" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectionFailedMainView" object:nil];
}

@end
