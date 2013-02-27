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

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImages:) name:@"loadImages" object:nil];
    [self addMotionRecognizerWithAction:@selector(shakeWasRecognized:)];
	[self addScroll];
    [self addButtons];
}

- (void) shakeWasRecognized:(NSNotification*)notif{
    NSLog(@"shaked !");
}

-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)addScroll
{
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    _scroll.contentSize = [self isIpad] ? CGSizeMake(1024, 990) : CGSizeMake(640, 640);
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
}

- (void)addButtons{
    _buttonImageViewCollection = [NSMutableArray array];
    int count = 0;
    for (int i=0; i<=9; i++) {
        for (int j=0; j<=9; j++) {
            ButtonImage *imageButton = [ButtonImage buttonWithType:UIButtonTypeCustom];
            
            [imageButton setImage:[UIImage imageNamed:@"Launcher.png"] forState:UIControlStateNormal];
            [imageButton setSelected:NO];
            [imageButton setAlpha:0.1];
            [imageButton setNeedsDisplay];
            imageButton.frame = [self isIpad] ? CGRectMake(0+(i*100), 0+(j*97), 100, 100) : CGRectMake(0+(i*64), 0+(j*60), 55, 55);
            [imageButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonImageViewCollection addObject:imageButton];
            [_scroll addSubview:imageButton];
            count++;
        }
    }
}

-(void)loadImages: (NSNotification*) notification{
    
    NSArray *buttonImageCollection = self.buttonImageViewCollection;
    NSMutableArray *appDetails = (NSMutableArray *) notification.object;
	if (appDetails != nil) {
        for (int counter = 0; counter<= [appDetails count]-1; counter++) {
            ButtonImage *buttonImage = [buttonImageCollection objectAtIndex:(counter)];
            AppDetail *ap  = [appDetails objectAtIndex:counter];
            
            [buttonImage loadImageFromURL:ap.label100 ];
            [buttonImage setAppDetail:ap];
        }
    }
}


-(void) buttonPushed:(id)sender{
    [[PlaySound sharedInstance] playClick];
}


-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset < 0)
    {
        NSLog(@"ScrollOffSet: %f", scrollOffset);
    }else if (scrollOffset == 0)
    {
        NSLog(@"ScrollView on top");
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        NSLog(@"scrollview at botton");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
