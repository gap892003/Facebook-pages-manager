//
//  PostsTableViewCell.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/26/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *views;
@property(nonatomic,weak) IBOutlet UIView *viewsContainer;
@property(nonatomic,weak) IBOutlet UILabel *message;
@end
