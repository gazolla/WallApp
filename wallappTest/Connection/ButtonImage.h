//
//  ButtonImage.h
//  ImageTest
//
//  Created by sebastiao Gazolla Costa Junior on 09/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDetail.h"
#import "AFNetworking.h"



@interface ButtonImage : UIButton  
    
@property (nonatomic, strong) AppDetail *appDetail;

+(void) resetCounter;
- (void)loadImageFromURL:(NSString *)anUrl;
- (UIImage*) maskImage:(UIImage *)image ;

@end
