//
//  SlidingMessageViewController.h
//
//  http://iPhoneDeveloperTips.com
//

#import <UIKit/UIKit.h>

@interface SlidingMessageViewController : UIViewController
{
  UILabel   *titleLabel;              
  UILabel   *msgLabel;  
}

- (id)initWithTitle:(NSString *)title message:(NSString *)msg;
- (void)showMsgWithDelay:(int)delay;
- (void) setMessage: (NSString *) msg;
- (void) setTitle: (NSString *) title;
- (void)hideMsg;

@end
