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
#import "Constants.h"

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
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:publishPages]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@",[self.post objectForKey:idKey]]
                                           parameters: nil
                                          tokenString:[self.pageDetails objectForKey:accessTokenKey]
                                              version:graphAPIVersion
                                           HTTPMethod:HTTP_DELETE]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
//                 [spinner stopAnimating];
//                 [spinner removeFromSuperview];
                 if (!error) {
                     NSLog(@"Deleted Post id:%@", result[idKey]);
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
    self.message.text = [post valueForKey:messageKey];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
    NSDate* date = [dateFormatter dateFromString:[post valueForKey:createdTimeKey]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH:mm:ss"];
    
    self.createdDate.text = [dateFormatter stringFromDate:date];
//    self.viewsContainer.hidden = true;
    NSDictionary *from = [post objectForKey:fromKey];
    NSString* fromtext = nil;
    
    if ( from !=nil && ![[from objectForKey:idKey] isEqualToString:[pageDetails objectForKey:idKey]]){
        
        fromtext = [NSString stringWithFormat:@"%@ \u25B6 %@", [from objectForKey:nameKey],
                    [pageDetails objectForKey:nameKey]];
        [self.fromImage lazyLoadWithId:[from objectForKey:idKey]];
    }else{
        
        fromtext = [NSString stringWithFormat:@"%@",
                    [pageDetails objectForKey:nameKey]];
        [self.fromImage lazyLoadWithId:[pageDetails objectForKey:idKey]];
    }
    
    self.from.text = fromtext;
    [self.views updateViewCount:[post objectForKey:idKey]];
}

@end
