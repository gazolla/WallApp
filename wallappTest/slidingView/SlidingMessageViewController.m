//
//  SlidingMessageViewController.m
//
//  http://iPhoneDeveloperTips.com
//

#import "SlidingMessageViewController.h"

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface SlidingMessageViewController(private)
- (void)hideMsg;
@end

@implementation SlidingMessageViewController

/**************************************************************************
 *
 * Private implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Private Methods

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)hideMsg;
{
    // Slide the view up off screen
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -60;
        self.view.frame = frame;
    }];
}

/**************************************************************************
 *
 * Class implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Initialization

- (void) setMessage: (NSString *) msg  {
    // Message
    msgLabel.font = [UIFont systemFontOfSize:15];
    msgLabel.text = msg;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.backgroundColor = [UIColor clearColor];
}

- (void) setTitle: (NSString *) title  {
    // Title
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)initWithTitle:(NSString *)title message:(NSString *)msg
{
    if (self == [super init]) 
    {
        
        BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        
        if (iPad) {
            self.view = [[UIView alloc] initWithFrame:CGRectMake(0, -60, 768, 56)];
            [self.view setBackgroundColor:[UIColor blackColor]];
            [self.view setAlpha:.70];
            
            // Message
            msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 748, 80)];
            [self setMessage:msg]; 
            [self.view addSubview:msgLabel];
            
            // Title
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 748, 30)];
            [self setTitle: title];
            [self.view addSubview:titleLabel];
            
            [self setMessage: msg];

        } else {
            // Notice the view y coordinate is offscreen (480)
            // This hides the view
            //      self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 90)] autorelease];
            self.view = [[UIView alloc] initWithFrame:CGRectMake(0, -60, 320, 56)];
            [self.view setBackgroundColor:[UIColor blackColor]];
            //[self.view setAlpha:.87];
            [self.view setAlpha:.70];
            
            // Message
            msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 80)];
            [self setMessage:msg]; 
            [self.view addSubview:msgLabel];
            
            // Title
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
            [self setTitle: title];
            [self.view addSubview:titleLabel];
            
            [self setMessage: msg];
        }
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Message Handling

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)showMsgWithDelay:(int)delay
{
    // Slide the view down on screen
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
         frame.origin.y = 10;
        self.view.frame = frame;
    }];
    
    // Hide the view after the requested delay
    [self performSelector:@selector(hideMsg) withObject:nil afterDelay:delay];
    
}

#pragma mark -
#pragma mark Cleanup

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)dealloc 
{
    if ([self.view superview])
        [self.view removeFromSuperview];
}

@end