//
//  Connection.h
//  JSON
//
//  Created by sebastiao Gazolla Costa Junior on 30/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GazappsDetail.h"
//#import "JSON.h"


@interface GzLoadAppsData : NSObject {
	NSMutableData *responseData;
	NSMutableArray *imagePaths;
	NSMutableArray *images;
	NSMutableArray *appDetails;
	NSURLConnection *urlConn;
	BOOL isThereASplash;
    BOOL isConnectionOK;
}
@property (nonatomic,retain) NSMutableArray *imagePaths;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *appDetails;
@property (nonatomic, retain) NSURLConnection *urlConn;
@property BOOL isConnectionOK;

- (void)processJSON;
- (void)verifyArray;
- (void)deleteAppDetailsFile;

@end
