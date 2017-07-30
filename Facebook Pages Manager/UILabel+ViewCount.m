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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });

}

@end
