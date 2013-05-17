//
//  Settings.m
//  ImageTest
//
//  Created by sebastiao Gazolla Costa Junior on 01/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


@implementation Settings

/***********************************************************************
 * Singleton Implementation
 */

+ (Settings *)sharedInstance
{
    static Settings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Settings alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
/***********************************************************************/

-(BOOL)isIpad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

-(void)loadSettings{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.iPad = nil;
	self.iPad = [defaults objectForKey:@"iPad"];
	if (self.iPad == nil) {
		self.iPad = ([self isIpad])?@"YES":@"NO";
	}
	
	self.iPhone = nil;
	self.iPhone = [defaults objectForKey:@"iPhone"];
	if (self.iPhone == nil) {
		self.iPhone = ([self isIpad])?@"NO":@"YES";
	}
	
	self.paidApps = nil;
	self.paidApps = [defaults objectForKey:@"paiedApps"];
	if (self.paidApps == nil) {
		self.paidApps = @"YES";
	}
	
	self.freeApps = nil;
	self.freeApps = [defaults objectForKey:@"freeApps"];
	if (self.freeApps == nil) {
		self.freeApps = @"NO";
	}
	
	self.novasApps = nil;
	self.novasApps = [defaults objectForKey:@"newApps"];
	if (self.novasApps == nil) {
		self.novasApps = @"NO";
	}
	
	self.grossingApps = nil;
	self.grossingApps = [defaults objectForKey:@"grossingApps"];
	if (self.grossingApps == nil) {
		self.grossingApps = @"NO";
	}
	
	self.randonApps = nil;
	self.randonApps = [defaults objectForKey:@"randonApps"];
	if (self.randonApps == nil) {
		self.randonApps = @"NO";
	}
	
	self.soundEffects = nil;
	self.soundEffects = [defaults objectForKey:@"soundEffects"];
	if (self.soundEffects == nil) {
		self.soundEffects = @"YES";
	}
	
	self.messages = nil;
	self.messages = [defaults objectForKey:@"messages"];
	if (self.messages == nil) {
		self.messages = @"YES";
	}
	
	self.appPosition = nil;
	self.appPosition = [defaults objectForKey:@"appPosition"];
	if (self.appPosition == nil) {
		self.appPosition = @"NO";
	}
	
	self.country = nil;
	self.country = [defaults objectForKey:@"country"];
	if (self.country == nil) {
		self.country = @"United States";
	}
	
}

-(void)saveSettings{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_iPhone forKey:@"iPhone"];
	[defaults setObject:_iPad forKey:@"iPad"];
	[defaults setObject:_paidApps forKey:@"paiedApps"];
	[defaults setObject:_freeApps forKey:@"freeApps"];
	[defaults setObject:_novasApps forKey:@"newApps"];
	[defaults setObject:_grossingApps forKey:@"grossingApps"];
	[defaults setObject:_randonApps forKey:@"randonApps"];
	[defaults setObject:_messages forKey:@"messages"];
	[defaults setObject:_soundEffects forKey:@"soundEffects"];
	[defaults setObject:_appPosition forKey:@"appPosition"];
	[defaults setObject:_country forKey:@"country"];
	[defaults synchronize];
}


@end
