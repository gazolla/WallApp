//
//  AppDataConnection.h
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AppDetail.h"


@interface AppDataConnection : NSObject

@property (nonatomic, strong) NSMutableArray *appDataCollection;

-(void) downloadAppData;

@end
