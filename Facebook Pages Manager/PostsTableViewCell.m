//
//  PostsTableViewCell.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/26/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "PostsTableViewCell.h"
#import "UIImageView+ImageHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UILabel+ViewCount.h"

@implementation PostsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) deletePostForCurrentVC:(UIViewController*)vc successHandler:(void (^)(id result )) successHandler{
    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spinner.center = vc.view.center;
//    [((UITableViewController*)vc).tableView addSubview:spinner];
//    [spinner startAnimating];
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_pages"]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@",[self.post objectForKey:@"id"]]
                                           parameters: nil
                                          tokenString:[self.pageDetails objectForKey:@"access_token"]
                                              version:@"v2.10"
                                           HTTPMethod:@"DELETE"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
//                 [spinner stopAnimating];
//                 [spinner removeFromSuperview];
                 if (!error) {
                     NSLog(@"Deleted Post id:%@", result[@"id"]);
                     successHandler(result);
                 }else{
                     
                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                    message:@"Delete failed!"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action) {}];
                     
                     [alert addAction:defaultAction];
                     [vc presentViewController:alert animated:YES completion:nil];
                 }
             });
         }];
    }
}

-(void) loadData:(NSDictionary*) post andPage:(NSDictionary*) pageDetails{

    self.post = post;
    self.pageDetails = pageDetails;
    self.message.text = [post valueForKey:@"message"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
    NSDate* date = [dateFormatter dateFromString:[post valueForKey:@"created_time"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH:mm:ss"];
    
    self.createdDate.text = [dateFormatter stringFromDate:date];
//    self.viewsContainer.hidden = true;
    NSDictionary *from = [post objectForKey:@"from"];
    NSString* fromtext = nil;
    
    if ( from !=nil && ![[from objectForKey:@"id"] isEqualToString:[pageDetails objectForKey:@"id"]]){
        
        fromtext = [NSString stringWithFormat:@"%@ \u25B6 %@", [from objectForKey:@"name"],
                    [pageDetails objectForKey:@"name"]];
        [self.fromImage lazyLoadWithId:[from objectForKey:@"id"]];
    }else{
        
        fromtext = [NSString stringWithFormat:@"%@",
                    [pageDetails objectForKey:@"name"]];
        [self.fromImage lazyLoadWithId:[pageDetails objectForKey:@"id"]];
    }
    
    self.from.text = fromtext;
    [self.views updateViewCount:[post objectForKey:@"id"]];
}

@end
