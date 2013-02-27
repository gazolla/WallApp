//
//  PlaySound.h
//  wallappTest
//
//  Created by Gazolla on 26/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolBox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface PlaySound : NSObject

-(void) playClick;
+ (PlaySound *)sharedInstance;


@end
