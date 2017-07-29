//
//  ScheduledPostsViewController.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/28/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduledPostsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) NSDictionary *pageDetails;
@end
