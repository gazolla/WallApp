//
//  ButtonImage.m
//  ImageTest
//
//  Created by sebastiao Gazolla Costa Junior on 09/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonImage.h"

static int counter;

@implementation ButtonImage


+(void) resetCounter{
    counter = 0;
}


- (void)loadImageFromURL:(NSString *)anUrl {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:anUrl]];
    AFImageRequestOperation *operation = [AFImageRequestOperation
                                          imageRequestOperationWithRequest:request
                                          imageProcessingBlock:^UIImage *(UIImage *image) {
                                              return [self maskImage:image];
                                          }
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              counter ++;
                                              
                                              self.appDetail.appIcon = image;
                                              [self setImage:image forState:UIControlStateSelected];
                                              [self setAlpha:1.0];
                                              [self setSelected:YES];
                                              [self setNeedsDisplay];
                                              
                                              [self setAlpha:0.0];
                                              [UIView beginAnimations:@"fadeinout" context:nil];
                                              [UIView setAnimationDuration:0.5];
                                              [self setAlpha:1.0];
                                              [UIView commitAnimations];
                                              
                                              if (counter == 100) {
                                                  counter = 0;
                                                  [self performSelectorOnMainThread:@selector(loadImagesDone:) withObject:self waitUntilDone:YES];
                                              }
                                          }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              NSLog(@"Error getting photo");
                                          }];
    
    [operation start];
    
    
    
}


- (UIImage*) maskImage:(UIImage *)image  {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIImage *maskImage = [UIImage imageNamed:@"AppIconMask-72.png"];
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width/ image.size.width;
    
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image.size.height;
    }
    
    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
    
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    // return the image
    return theImage;
}

-(void)loadImagesDone:(NSNotification *)notification{
    NSLog(@"Load Image done!");
  //  TODO: Start animation ?????
}



@end
