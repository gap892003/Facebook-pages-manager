//
//  ViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/19/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController ()
@property (nonatomic) FBSDKLoginButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _loginButton = [[FBSDKLoginButton alloc] init];
    [self.stackView addArrangedSubview:_loginButton];
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    _loginButton.publishPermissions = @[@"manage_pages", @"publish_pages",@"publish_actions"];
    [_loginButton setDelegate:self];
    // make graph api call here
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/accounts" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error{
    
    [self updateView];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{

    [self updateView];
}

-(void) updateView{
    
    [self.continueButton setHidden:([FBSDKAccessToken currentAccessToken]==NO)];
    [self.stackView invalidateIntrinsicContentSize];
}
@end
