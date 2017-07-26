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

-(void)lazyLoadImageForPage: (NSString*) pageId{
    
    self.image = [UIImage imageNamed:@"imageplaceholder.jpg"];
    
    // make network request here
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"/%@/picture",pageId]
                                      parameters:nil
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
}

@end
