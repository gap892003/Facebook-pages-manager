//
//  UIView+ViewCount.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/27/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "UILabel+ViewCount.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation UILabel (ViewCount)

-(void)updateViewCount:(NSString*) objectID{
    
    self.text = @"-";
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/insights/post_impressions/lifetime",objectID] parameters:nil HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        NSArray* data = [result objectForKey:@"data"];
        if (data != nil && [data count] > 0) {
            NSDictionary* dataVal = [data objectAtIndex:0];
            NSArray *values = [dataVal objectForKey:@"values"];
            NSDictionary *valuesDict = [values objectAtIndex:0];
            NSNumber* value = [valuesDict objectForKey:@"value"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.text = [value stringValue];
            });
        }
    }];
}

@end
