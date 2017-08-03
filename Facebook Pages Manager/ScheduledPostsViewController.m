//
//  ScheduledPostsViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/28/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "ScheduledPostsViewController.h"
#import "PostsTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Constants.h"

@interface ScheduledPostsViewController ()
@property (nonatomic,copy) NSMutableArray *posts;
@end

@implementation ScheduledPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = ESTIMATED_ROW_HEIGHT;
    [self getScheduledPosts];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_posts count]*2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
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

-(void) getScheduledPosts{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSString* pageid =[_pageDetails valueForKey:@"id"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[pageid stringByAppendingString:promotablePostsPath] parameters:scheduledPostsParams
            tokenString:[_pageDetails objectForKey:accessTokenKey] version:graphAPIVersion
                                           HTTPMethod:HTTP_GET]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"%@", result);
                 _posts = [[result valueForKey:dataKey] mutableCopy];
                 [self.tableView reloadData];
             }
         }];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return [indexPath row]%2==0;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; [self.view addSubview:spinner];
    //    [spinner startAnimating];
    
    //NSDictionary *post = [_posts objectAtIndex:[indexPath row]];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PostsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell deletePostForCurrentVC:self successHandler:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[spinner stopAnimating];
                [_posts removeObject:cell.post];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
                
            });
        }];
    }
}

@end
