//
//  AsyncImageCell.m
//  GazApps
//
//  Created by sebastiao Gazolla Costa Junior on 22/12/11.
//  Copyright (c) 2011 iPhone and Java developer. All rights reserved.
//

#import "GzAsyncImageCell.h"

@implementation GzAsyncImageCell

- (void)loadImageFromURL:(NSString *)anUrl {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:anUrl] 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:60.0];
    
    NSLog(@"url: %@", anUrl);
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    if (data != nil) {
        
        [self.imageView.layer setCornerRadius:10.0f];
        [self.imageView.layer setMasksToBounds:YES]; 
        self.imageView.frame = CGRectMake(0, 0, 0, 0);
        [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.imageView.layer setBorderWidth: 1.0];
        self.imageView.image = [[UIImage alloc] initWithData:data];
        self.imageView.alpha = 0;
        [self setNeedsLayout];
        [UIView animateWithDuration:0.8 animations:^{self.imageView.alpha = 1;}];
       
        data = nil;
        connection = nil;    
        
    } else {
        NSLog(@"Data is equal nil !!!!!!!!!!");
    }
    
}


-(void)dealloc{
    connection = nil;
    data = nil;
}


@end
