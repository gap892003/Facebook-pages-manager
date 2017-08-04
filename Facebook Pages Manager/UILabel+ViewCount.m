//
//  UIView+ViewCount.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/27/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "UILabel+ViewCount.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Constants.h"

@implementation UILabel (ViewCount)

-(void)updateViewCount:(NSString*) objectID accessToken:(NSString*) accessToken{
    
    self.text = @"-";
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:insights_postImpressions,objectID] parameters:POST_VIEWS_PARAM tokenString:accessToken version:graphAPIVersion HTTPMethod:HTTP_GET] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (error!=nil) return;
        NSArray* data = [result objectForKey:dataKey];
        if (data != nil && [data count] > 0) {
            NSDictionary* dataVal = [data objectAtIndex:0];
            NSArray *values = [dataVal objectForKey:valuesKey];
            NSDictionary *valuesDict = [values objectAtIndex:0];
            NSNumber* value = [valuesDict objectForKey:valueKey];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.text = [value stringValue];
            });
        }
    }];
}

@end
