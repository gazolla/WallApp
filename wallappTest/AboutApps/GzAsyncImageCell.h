//
//  AsyncImageCell.h
//  GazApps
//
//  Created by sebastiao Gazolla Costa Junior on 22/12/11.
//  Copyright (c) 2011 iPhone and Java developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GzAsyncImageCell : UITableViewCell <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSMutableData *data;
}

- (void)loadImageFromURL:(NSString *)anUrl;

@end
