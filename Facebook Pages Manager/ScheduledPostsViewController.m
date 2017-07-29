//
//  ScheduledPostsViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/28/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "ScheduledPostsViewController.h"
#import "PostsTableViewCell.h"

@interface ScheduledPostsViewController ()
@property (nonatomic,copy) NSArray *posts;
@end

@implementation ScheduledPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduled"];
        return cell;
    }
    
    if ([indexPath row]%2!=0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blank"];
        return cell;
    }
    
    NSDictionary *post = [_posts objectAtIndex:([indexPath row]-1)/2];
    
    PostsTableViewCell *cell;
    NSString* cellIdentifier= nil ;
    if ([[post objectForKey:@"type"] isEqualToString:@"photo"]){
        
        cellIdentifier = @"postsImageViewCell";
    }else{
        
        cellIdentifier = @"postsTextViewCell";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell loadData:post andPage:_pageDetails];
    return cell;
}

@end
