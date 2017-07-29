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

@implementation PostsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) deletePost:(NSDictionary*) post forPage:(NSDictionary*)pageDetails
      andCurrentVC:(UIViewController*)vc successHandler:(void (^)(id result )) successHandler{
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_pages"]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@",[post objectForKey:@"id"]]
                                           parameters: nil
                                          tokenString:[pageDetails objectForKey:@"access_token"]
                                              version:@"v2.10"
                                           HTTPMethod:@"DELETE"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Deleted Post id:%@", result[@"id"]);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     successHandler(result);
                 });
             }else{
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                    message:@"Delete failed!"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action) {}];
                     
                     [alert addAction:defaultAction];
                     [vc presentViewController:alert animated:YES completion:nil];
                 });
             }
         }];
    }
}

-(void) loadData:(NSDictionary*) post andPage:(NSDictionary*) pageDetails{

    self.message.text = [post valueForKey:@"message"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
    NSDate* date = [dateFormatter dateFromString:[post valueForKey:@"created_time"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH:mm:ss"];
    
    self.createdDate.text = [dateFormatter stringFromDate:date];
    self.viewsContainer.hidden = true;
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
}

@end
