//
//  Messages.m
//  wallappTest
//
//  Created by Gazolla on 12/04/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "Messages.h"
#import "Settings.h"
#import "Countries.h"

static int counter;

@implementation Messages

/***********************************************************************
 * Singleton Implementation
 */

+ (Messages *)sharedInstance{
    static Messages *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Messages alloc] init];
        sharedInstance.isConnectionOk = YES;
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(startMessageTimer:) name:@"startMessageTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(stopMessageTimer:) name:@"stopMessageTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(reloadTimer:) name:@"reloadTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(connectionFailed:) name:@"connectionFailedMessageTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(connectionSuccess:) name:@"connectionSuccessMessageTimer" object:nil];

    });
    return sharedInstance;
}
/***********************************************************************/

-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

-(void) connectionFailed:(NSNotification *) notification{
    self.isConnectionOk = NO;
    Settings *settings = [Settings sharedInstance];
    if ([settings.messages isEqualToString:@"YES"]) {
        [self startMessageTimer:nil];
        [self updateMessageTimer:nil];
    }
}

-(void) connectionSuccess:(NSNotification *) notification{
    self.isConnectionOk = YES;
}

- (void) startMessageTimer:(NSNotification *) notification {
    Settings *settings = [Settings sharedInstance];
    
    if ([settings.messages isEqualToString:@"YES"]) {
        if (_messageTimer == nil) {
            _messageTimer = [NSTimer scheduledTimerWithTimeInterval:8.0f
                                                            target:self
                                                          selector:@selector(updateMessageTimer:)
                                                          userInfo:nil
                                                           repeats:YES];
            _slideMessage = [[SlidingMessageViewController alloc] initWithTitle:@"Shake the phone" message:@"to refresh icons or adjust settings"];
            [self.window addSubview:_slideMessage.view];
        }
    }
}

- (void) stopMessageTimer:(NSNotification *) notification {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _slideMessage.view.frame;
        frame.origin.y = -60;
        _slideMessage.view.frame = frame;
    }
    completion:^(BOOL finished) {
                         [_slideMessage.view removeFromSuperview];
                         _slideMessage = nil;
                         [_messageTimer invalidate];
                         _messageTimer = nil;
    }];
}

- (void) reloadTimer:(NSNotification *) notification {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _slideMessage.view.frame;
        frame.origin.y = -60;
        _slideMessage.view.frame = frame;
    }
    completion:^(BOOL finished) {
         [_slideMessage.view removeFromSuperview];
         _slideMessage = nil;
         [_messageTimer invalidate];
         _messageTimer = nil;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRandonAnimation" object:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"resetButtonsImage" object:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAppsData" object:nil];
    }];
}

- (void)updateMessageTimer:(NSTimer *)theTimer {
    counter ++;
    Settings *settings = [Settings sharedInstance];
    [settings loadSettings];
    Countries *countries = [Countries sharedInstance];
    [countries loadCountries];
    if (! _isConnectionOk) {
        [_slideMessage setTitle:@"Connection Failed:"];
        [_slideMessage setMessage:[self isIpad] ? @"tap in refresh icon on the toolbar":@"Shake the phone and tap in reload icon"];
        counter = 0;
    } else {
        if (counter == 1) {
            [_slideMessage setTitle:[self isIpad] ? @"Use the toolbar below":@"Shake the phone"];
            [_slideMessage setMessage:@"to refresh icons or adjust settings"];
        } else if (counter == 2) {
            [_slideMessage setTitle:@"You are seening"];
            if ([settings.paidApps isEqualToString:@"YES"]){
                NSString *msg = [NSString stringWithFormat:@"Top 100 paid %@ apps %@",
                                 ([settings.iPad isEqualToString:@"YES" ] ? @"iPad" : @"iPhone"),
                                 ([settings.randonApps isEqualToString:@"YES" ] ? @"in randon mode" : @"")];
                [_slideMessage setMessage:msg];
            } else if ([settings.freeApps isEqualToString:@"YES"]){
                NSString *msg = [NSString stringWithFormat:@"Top 100 free %@ apps %@",
                                 ([settings.iPad isEqualToString:@"YES" ] ? @"iPad" : @"iPhone"),
                                 ([settings.randonApps isEqualToString:@"YES" ] ? @"in randon mode" : @"")];
                [_slideMessage setMessage:msg];
            } else if ([settings.grossingApps isEqualToString:@"YES"]){
                NSString *msg = [NSString stringWithFormat:@"Top 100 grossing %@ apps %@",
                                 ([settings.iPad isEqualToString:@"YES" ] ? @"iPad" : @"iPhone"),
                                 ([settings.randonApps isEqualToString:@"YES" ] ? @"in randon mode" : @"")];
                [_slideMessage setMessage:msg];
            }
            
        } else if (counter == 3) {
            [_slideMessage setTitle:@"You are seening"];
            NSString *msg = [NSString stringWithFormat:@"Apps from %@ AppStore", [settings.country stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            [_slideMessage setMessage:msg];
             counter = 0;
        }
        
    }
    
    [_slideMessage showMsgWithDelay:5];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startMessageTimer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"stopMessageTimer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectionFailedMessageTimer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectionSuccessMessageTimer" object:nil];
}


@end
