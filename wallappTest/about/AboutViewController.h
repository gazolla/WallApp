//
//  AboutViewController.h
//  AboutView
//
//  Created by sebastiao Gazolla Costa Junior on 19/07/11.
//  Copyright 2011 iPhone and Java developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
}

-(void)displayMailComposerSheet;

@end
