//
//  ViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/19/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController ()
@property (nonatomic) FBSDKLoginButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _loginButton = [[FBSDKLoginButton alloc] init];
    //_loginButton.center = self.view.center;
    //[self.view addSubview:_loginButton];
    [self.stackView addArrangedSubview:_loginButton];
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    _loginButton.publishPermissions = @[@"manage_pages", @"publish_pages",@"publish_actions"];
    // make graph api call here
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/accounts" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
    }

/*    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        [[[FBSDKGraphRequest alloc]
          initWithGraphPath:@"me/feed"
          parameters: @{ @"message" : @"hello world"}
          HTTPMethod:@"POST"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Post id:%@", result[@"id"]);
             }
         }];
    }
*/
}

- (void) viewDidAppear:(BOOL)animated{
    
    [self.continueButton setHidden:([FBSDKAccessToken currentAccessToken]==NO)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
