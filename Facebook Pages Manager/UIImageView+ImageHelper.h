//
//  UIImageView+ImageHelper.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/25/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageHelper)
-(void)lazyLoadImageForPage: (NSDictionary*) picture;
-(void) lazyLoadWithUrl:(NSString*) url;
-(void) lazyLoadWithId:(NSString*) objectID;
@end
