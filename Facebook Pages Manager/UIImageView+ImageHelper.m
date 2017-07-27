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
    // make network request here
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        if (image == nil) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image];
            [self setNeedsDisplay];        
        });
    });
}

@end
