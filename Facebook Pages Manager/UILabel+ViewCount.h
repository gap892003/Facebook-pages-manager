//
//  UIView+ViewCount.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/27/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ViewCount)
-(void)updateViewCount:(NSString*) objectID accessToken:(NSString*) accessToken;
@end
