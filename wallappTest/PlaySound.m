//
//  PlaySound.m
//  wallappTest
//
//  Created by Gazolla on 26/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "PlaySound.h"
#import "Settings.h"

@implementation PlaySound


/***********************************************************************
 * Singleton Implementation
 */

+ (PlaySound *)sharedInstance
{
    static PlaySound *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PlaySound alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
/***********************************************************************/

-(void) playClick{
    Settings *settings = [Settings sharedInstance];
	if ([settings.soundEffects  isEqualToString:@"YES"]) {
        SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click-1" ofType:@"caf"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

-(void) playServoOpen{
    Settings *settings = [Settings sharedInstance];
	if ([settings.soundEffects  isEqualToString:@"YES"]) {
        SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"servo" ofType:@"caf"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

-(void) playServoClose{
	Settings *settings = [Settings sharedInstance];
	if ([settings.soundEffects  isEqualToString:@"YES"]) {    SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"servo" ofType:@"caf"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

@end
