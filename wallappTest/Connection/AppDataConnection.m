//
//  AppDataConnection.m
//  wallappTest
//
//  Created by Gazolla on 25/02/13.
//  Copyright (c) 2013 Gazolla. All rights reserved.
//

#import "AppDataConnection.h"
#import "Settings.h"
#import "Countries.h"


@implementation AppDataConnection

-(void) downloadGazappsdata{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *gazappsAppsUrl = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=422657948&entity=software"];
    // A estrutura do arquivo JSON é completamente diferente....
    // ...
    NSURLRequest *request = [NSURLRequest requestWithURL:gazappsAppsUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.appDataCollection = [[NSMutableArray alloc] init];
        int counter = 0;
        //TODO: Reescrever parser do JSON para Apps do Gazapps...
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


-(void) downloadAppData{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
  //  NSURL *gazappsAppsUrl = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=422657948&entity=software"];
    // A estrutura do arquivo JSON é completamente diferente....
    // ...
    
    Settings *settings = [Settings sharedInstance];
    [settings loadSettings];

    Countries *countries = [Countries sharedInstance];
    [countries loadCountries];
    
    NSString *countryCode = [[countries getCountryCode:settings.country] lowercaseString];
    
    NSLog(@"Country Code: %@", countryCode);

    NSURL *topFreeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/topfreeapplications/limit=100/json", countryCode]];
    NSURL *topPaidUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/toppaidapplications/limit=100/json", countryCode]];
    NSURL *TopGrossingUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/topgrossingapplications/limit=100/json", countryCode]];
    
    NSURL *topFreeIpadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/topfreeipadapplications/limit=100/json", countryCode]];
    NSURL *topPaidIpadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/toppaidipadapplications/limit=100/json", countryCode]];
    NSURL *topGrossingIpadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/topgrossingipadapplications/limit=100/json", countryCode]];

    NSURLRequest *request = nil;
    
    if (([settings.iPhone isEqualToString:@"YES"])&&([settings.paidApps isEqualToString:@"YES"])) {
        request = [NSURLRequest requestWithURL:topPaidUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    } else if (([settings.iPhone isEqualToString:@"YES"])&&([settings.freeApps isEqualToString:@"YES"])) {
        request = [NSURLRequest requestWithURL:topFreeUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    } else if (([settings.iPhone isEqualToString:@"YES"])&&([settings.grossingApps isEqualToString:@"YES"])) {
        request = [NSURLRequest requestWithURL:TopGrossingUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    } else if (([settings.iPad isEqualToString:@"YES"])&&([settings.paidApps isEqualToString:@"YES"])) {
        request = [NSURLRequest requestWithURL:topPaidIpadUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    } else if (([settings.iPad isEqualToString:@"YES"])&&([settings.freeApps isEqualToString:@"YES"])) {
        request = [NSURLRequest requestWithURL:topFreeIpadUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    } else  if (([settings.iPad isEqualToString:@"YES"])&&([settings.grossingApps isEqualToString:@"YES"])) {
        request = [NSURLRequest requestWithURL:topGrossingIpadUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    }







//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/newapplications/limit=100/json"];
//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topmacapps/limit=100/json"];
//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topfreemacapps/limit=100/json"];
//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topgrossingmacapps/limit=100/json"];
//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/toppaidmacapps/limit=100/json"];
    
    
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFailedMainView" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFailedMessageTimer" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLogo" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startMessageTimer" object:nil];
    }];
    
    [operation start];
}

-(void)appDataDownloadDone:(NSNotification *)notification{
    NSLog(@"App Data download done!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionSuccessMessageTimer" object:nil];
    NSLog(@"Connection Success !");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startRandonAnimation" object:nil];
    NSLog(@"Randon Animation Done.");
    NSLog(@"Start Loading images...");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImages" object:self.appDataCollection];
    NSLog(@"Load images done.");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLogo" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"startMessageTimer" object:nil];
}

@end
