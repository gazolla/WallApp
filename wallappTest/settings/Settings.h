//
//  Settings.h
//  ImageTest
//
//  Created by sebastiao Gazolla Costa Junior on 01/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject

@property(nonatomic, strong) NSString *iPad;
@property(nonatomic, strong) NSString *iPhone;
@property(nonatomic, strong) NSString *paidApps;
@property(nonatomic, strong) NSString *freeApps;
@property(nonatomic, strong) NSString *novasApps;
@property(nonatomic, strong) NSString *grossingApps;
@property(nonatomic, strong) NSString *randonApps;
@property(nonatomic, strong) NSString *soundEffects;
@property(nonatomic, strong) NSString *messages;
@property(nonatomic, strong) NSString *appPosition;
@property(nonatomic, strong) NSString *appQuantity;
@property(nonatomic, strong) NSString *country;

+ (Settings *)sharedInstance;
-(void)loadSettings;
-(void)saveSettings;

@end
