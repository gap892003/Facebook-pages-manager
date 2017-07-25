//
//  PostsTableViewController.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/22/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy) NSDictionary *pageDetails;
@end
