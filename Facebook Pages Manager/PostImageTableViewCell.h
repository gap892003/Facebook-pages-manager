//
//  PostTableViewCell.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/24/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostImageTableViewCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *image;
@property(nonatomic,weak) IBOutlet UILabel *text;
@property(nonatomic,weak) IBOutlet UILabel *views;
@end
