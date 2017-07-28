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
    self.tableView.estimatedRowHeight = 500;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createPost)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPageFeed) name:@"reloadPageFeed" object:nil];
    [self setTitle:[self.pageDetails valueForKey:@"name"]];
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
    return [_posts count]*2 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row]%2!=0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blank"];
        return cell;
    }
    
    NSDictionary *post = [_posts objectAtIndex:[indexPath row]/2];
    NSLog(@"************************");
    NSLog(@"%@",[post objectForKey:@"type"] );
    NSLog(@"%@",[post objectForKey:@"message"] );
    NSLog(@"************************");
    PostsTableViewCell *cell;
    static NSString* cellIdentifier = @"postsImageViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([[post objectForKey:@"type"] isEqualToString:@"photo"]){
        
        static NSString* cellIdentifier = @"postsImageViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [[(PostImageTableViewCell*)cell  image] lazyLoadWithUrl:[post objectForKey:@"full_picture"]];
    }else{
        
        static NSString* cellIdentifier = @"postsTextViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.message.text = [post valueForKey:@"message"];
    cell.viewsContainer.hidden = true;
    NSDictionary *from = [post objectForKey:@"from"];
    NSString* fromtext = nil;
    
    if ( from !=nil && ![[from objectForKey:@"id"] isEqualToString:[_pageDetails objectForKey:@"id"]]){
     
        fromtext = [NSString stringWithFormat:@"%@ \u25B6 %@", [from objectForKey:@"name"],
                    [_pageDetails objectForKey:@"name"]];
        [cell.fromImage lazyLoadWithId:[from objectForKey:@"id"]];
    }else{
        
        fromtext = [NSString stringWithFormat:@"%@",
                    [_pageDetails objectForKey:@"name"]];
        [cell.fromImage lazyLoadWithId:[_pageDetails objectForKey:@"id"]];
    }
    
    cell.from.text = fromtext;
    /// Make a Superclass for both cells
// if ([post valueForKey:@"views"] != nil){
//        
//        cell.viewsContainer.hidden = false;
//        
//    }else{
//    
//        cell.viewsContainer.hidden = true;
//    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) getPageFeed{

    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSString* pageid =[_pageDetails valueForKey:@"id"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[pageid stringByAppendingString:@"/feed"] parameters:@{ @"fields": @"id,full_picture,object_id,name,message,created_time, is_hidden, is_published,privacy,type,from",} HTTPMethod:@"GET"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"%@", result);
                 _posts = [result valueForKey:@"data"];
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
        [createCntl setPageId:[_pageDetails objectForKey:@"id"]];
        [createCntl setPageAccessToken:[_pageDetails objectForKey:@"access_token"]];
    }];
    
}

//- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
//    
//    [self getPageFeed];
//}
@end
