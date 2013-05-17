//
//  Connection.m
//  JSON
//
//  Created by sebastiao Gazolla Costa Junior on 30/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GzLoadAppsData.h"


@implementation GzLoadAppsData

@synthesize imagePaths;
@synthesize images;
@synthesize urlConn;
@synthesize appDetails;
@synthesize isConnectionOK;

dispatch_queue_t myQueue;



- (id)init {
	if ((self = [super init])) {
      //  [self performSelectorInBackground:@selector(verifyArray) withObject:nil];
    }
    return self;
}

- (void)verifyArray {
    // Create the full file path by appending the desired file name
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayFileName = [documentsDirectory stringByAppendingPathComponent:@"appDetails.dat"];
    
    //Save the array
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:arrayFileName];
    
    if (fileExist){
        NSArray *appDetailSaved = [NSKeyedUnarchiver unarchiveObjectWithFile:arrayFileName];
        if (appDetailSaved != nil) {
            self.appDetails = [NSMutableArray arrayWithArray:appDetailSaved];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JsonNotification" object:self];
        } else{
            [self connect];
        }
    } else {
        [self connect];
    }
}

- (void)connect {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    myQueue = dispatch_queue_create("com.gazapps.myqueue.processjson", 0);
    NSURLRequest *request;
    responseData = [NSMutableData data] ;
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://strong-planet-2094.heroku.com/portfolios.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData
                           timeoutInterval:60.0];
    self.urlConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    isConnectionOK = NO;
    self.appDetails = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    isConnectionOK = YES;
	self.appDetails = nil;
	
	dispatch_async(myQueue, ^{ 
		[self processJSON];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JsonNotification" object:self];
		
        });
	});
	
}

- (void)deleteAppDetailsFile {
    NSError* error;
    // Create the full file path by appending the desired file name
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayFileName = [documentsDirectory stringByAppendingPathComponent:@"appDetails.dat"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:arrayFileName]) {
        [[NSFileManager defaultManager] removeItemAtPath:arrayFileName error:&error];
        NSLog(@"%@",error);
    }
}


- (void)createAppDetailsFile {
    // Create the full file path by appending the desired file name
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *arrayFileName = [documentsDirectory stringByAppendingPathComponent:@"appDetails.dat"];
    
    //Save the array
    BOOL saved = [NSKeyedArchiver archiveRootObject:self.appDetails toFile:arrayFileName];
    if (saved) {
        NSLog(@"array salvo...");
        
    }
}

- (void) processJSON {
    
    NSError* error;
    NSArray* data = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    int counter = 0;
    
	if (data == nil){
		NSLog(@"%@", [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
	} else {
        self.appDetails = [[NSMutableArray alloc] init];
        
		for (NSDictionary *object in data) {
            counter ++;
            GazappsDetail *ad = [[GazappsDetail alloc] init];
			ad.name = [object objectForKey:@"name"];
			ad.owner = [object objectForKey:@"owner"];
			ad.price = [object objectForKey:@"price"];
			ad.url = [object objectForKey:@"url"];
			ad.urlIcon = [object objectForKey:@"icon_url"];
            [self.appDetails addObject:ad];
		}
	}
    
    [self createAppDetailsFile];
    
    NSLog(@"numero de objetos: %i", counter);

}



@end
