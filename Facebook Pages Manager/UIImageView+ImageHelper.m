//
//  UIImageView+ImageHelper.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/25/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIImageView+ImageHelper.h"

@implementation UIImageView (ImageHelper)

/*
-(void)lazyLoadImageForPage: (NSString*) pageId{
    
    self.image = [UIImage imageNamed:@"imageplaceholder.jpg"];
    
    // make network request here
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"/%@/picture?redirect=1",pageId]
                                      parameters:@{ @"fields":@"picture.type(normal)"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (result == nil || error != nil){
                return;
            }
            
            UIImage *image = [UIImage imageWithData:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
           
        }];
    });
}*/

-(void)lazyLoadImageForPage: (NSDictionary*) picture{
    
    NSString *url = nil;
    if (picture != nil) {
        NSDictionary* data=[picture objectForKey:@"data"];
        url = [data objectForKey:@"url"];
    }
    [self lazyLoadWithUrl:url];
}

-(void) lazyLoadWithUrl:(NSString*) url{

    self.image = [UIImage imageNamed:@"imageplaceholder.jpg"];
    if (url == nil ) return;
    if ([self loadCachedImage:url]) return;
    // make network request here
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        if (image == nil) return;
        [self saveImage:image url:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image];
            [self setNeedsDisplay];
        });
    });
}

-(void) lazyLoadWithId:(NSString*) objectID{
    
    self.image = [UIImage imageNamed:@"imageplaceholder.jpg"];
    
    if (objectID == nil) return;
    // make network request here
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"/%@/picture?fields=url&type=small&redirect=0",objectID]
                                      parameters:nil
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (result == nil || error != nil){
                return;
            }
            
            NSDictionary *data = [result objectForKey:@"data"];
            if (data != nil)
            [self lazyLoadWithUrl:[data objectForKey:@"url"]];
        }];
    });

}

-(BOOL) loadCachedImage: (NSString*) url{

    NSString *imagePath = [self getImagePath:url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath]){
        self.image = [UIImage imageWithContentsOfFile:imagePath];
        return true;
    }
    
    return false;
}

-(void) saveImage:(UIImage*) image url:(NSString*) url{
    
    NSString* imagePath = [self getImagePath:url];
    // lowest compression quality
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    if (![imageData writeToFile:imagePath atomically:YES]){
        NSLog(@"Writing image to cache failed");
    }
}

-(NSString*) getImagePath:(NSString*) url{

    NSArray* libraryDirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryDir = [libraryDirs objectAtIndex:0];
//    NSString *folder = [libraryDir stringByAppendingPathComponent:@"Caches"];
    NSUInteger hashVal = [url hash];
    NSString *imagePath = [libraryDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.jpg",(unsigned long)hashVal]];
    return imagePath;
}

@end
