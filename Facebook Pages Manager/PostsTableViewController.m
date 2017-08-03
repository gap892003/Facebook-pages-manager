//
//  PostsTableViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/22/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PostsTableViewController.h"
#import "PostImageTableViewCell.h"
#import "PostsTableViewCell.h"
#import "UIImageView+ImageHelper.h"
#import "CreatePostViewController.h"
#import "ScheduledPostsViewController.h"
#import "Constants.h"

@interface PostsTableViewController ()

@end

@implementation PostsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = ESTIMATED_ROW_HEIGHT;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createPost)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPageFeed) name:reloadPageNotification object:nil];
    [self setTitle:[self.pageDetails valueForKey:nameKey]];
    if (_pageDetails == nil) return;
    [self getPageFeed];
}

-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_posts count]*2 + 1;
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
    if ([[post objectForKey:typeKey] isEqualToString:photoPost]){
        
        cellIdentifier = @"postsImageViewCell";
    }else{
        
        cellIdentifier = @"postsTextViewCell";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell loadData:post andPage:_pageDetails];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return ([indexPath row]%2==0 && [indexPath row]!=0);
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //NSDictionary *post = [_posts objectAtIndex:[indexPath row]];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 
        PostsTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell deletePostForCurrentVC:self successHandler:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_posts removeObject:cell.post];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
                
            }); 
        }];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toScheduledPosts"])
    {
        ScheduledPostsViewController *vc = [segue destinationViewController];
        
        //set page ID here
        [vc setPageDetails:_pageDetails];
    }
}

#pragma mark - User functions

-(void) getPageFeed{

    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSString* pageid =[_pageDetails valueForKey:idKey];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[pageid stringByAppendingString:feedPath] parameters:FEED_PARAMS HTTPMethod:HTTP_GET]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"%@", result);
                 _posts = [[result valueForKey:dataKey] mutableCopy];
                 [self.tableView reloadData];
             }
         }];
    }
}

-(void) createPost{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *posts = [storyBoard instantiateViewControllerWithIdentifier:@"createPosts"];
    posts.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover =  posts.popoverPresentationController;
    [popover setDelegate:self];
    [self.navigationController presentViewController:posts animated:YES completion:^{
        
        CreatePostViewController* createCntl= (CreatePostViewController*)[posts topViewController] ;
        [createCntl setPageId:[_pageDetails objectForKey:idKey]];
        [createCntl setPageAccessToken:[_pageDetails objectForKey:accessTokenKey]];
    }];
    
}

//- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
//    
//    [self getPageFeed];
//}
@end
