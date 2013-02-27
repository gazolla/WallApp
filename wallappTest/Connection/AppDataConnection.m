//
//  AppDataConnection.m
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "AppDataConnection.h"


@implementation AppDataConnection

-(void) downloadAppData{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topfreeipadapplications/limit=100/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.appDataCollection = [[NSMutableArray alloc] init];
        int counter = 0;
        
        NSDictionary *feed =  [JSON valueForKeyPath:@"feed"];
		NSArray *entry = (NSArray *)  [feed objectForKey:@"entry"];
		for (NSDictionary *object in entry) {
            counter ++;
			
			AppDetail *ap = [[AppDetail alloc] init];
            ap.position = [NSString stringWithFormat:@"%d", counter];
			NSDictionary *name = [object objectForKey:@"im:name"];
			ap.name = [name objectForKey:@"label"];
			
			NSArray *jsonImages = [object objectForKey:@"im:image"];
			NSDictionary *imageDic = [jsonImages objectAtIndex:0];
            ap.label53 = [imageDic objectForKey:@"label"];
			
			imageDic = [jsonImages objectAtIndex:1];
			ap.label75 = [imageDic objectForKey:@"label"];
			
			imageDic = [jsonImages objectAtIndex:2];
			ap.label100 = [imageDic objectForKey:@"label"];
			
			NSDictionary *detail = [object objectForKey:@"summary"];
			ap.summary = [detail objectForKey:@"label"];
			
			detail = [object objectForKey:@"im:price"];
			ap.price = [detail objectForKey:@"label"];
			
			detail = [object objectForKey:@"im:artist"];
			ap.artist = [detail objectForKey:@"label"];
			
			detail = [object objectForKey:@"category"];
			detail = [detail objectForKey:@"attributes"];
			ap.category = [detail objectForKey:@"label"];
			
			detail = [object objectForKey:@"im:releaseDate"];
			ap.releaseDate = [detail objectForKey:@"label"];
			
			id links = [object objectForKey:@"link"];
			
			if ([links isKindOfClass:[NSDictionary class]]) {
				detail = [detail objectForKey:@"attributes"];
				ap.link = [detail objectForKey:@"href"];
			} else if ([links isKindOfClass:[NSArray class]]) {
				detail = [links objectAtIndex:0];
				detail = [detail objectForKey:@"attributes"];
				ap.link = [detail objectForKey:@"href"];
			}
            
 			[self.appDataCollection addObject:ap];
			
		}
        [self performSelectorOnMainThread: @selector(appDataDownloadDone:) withObject: self waitUntilDone: YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
}

-(void)appDataDownloadDone:(NSNotification *)notification{
    NSLog(@"App Data download done!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImages" object:self.appDataCollection];
}

@end
