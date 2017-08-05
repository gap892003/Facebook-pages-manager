//
//  ViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/19/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Constants.h"

@interface ViewController ()
@property (nonatomic) FBSDKLoginButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _loginButton = [[FBSDKLoginButton alloc] init];
    [self.stackView addArrangedSubview:_loginButton];
    _loginButton.readPermissions = READ_PERMISSIONS;
    _loginButton.publishPermissions = PUBLISH_PERMISSIONS;
    [_loginButton setDelegate:self];
    // make graph api call here
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:accountsRequest parameters:nil]
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

-(IBAction)createTestUsers:(id)sender{

    /* make the API call */
    ///oauth/access_token
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:oauthPath parameters:APP_ACCESS_PARAM HTTPMethod:HTTP_GET] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//       
//        NSLog (@"Response %@", result);
//        if (error!=nil) return;
    
    for (int i=0; i< 30; ++i){
    
    
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:createTestUsersPath, appID]
                                           parameters:TEST_USER_PERMS
                                          tokenString:[NSString stringWithFormat:@"%@|%@",appID,appSecret] version:graphAPIVersion
                                           HTTPMethod:HTTP_POST] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                                              id result,
                                                                                              NSError *error) {
            NSLog(@"Response:%@",result);
            
            if (error==nil){
                
                // make it like the page
                //681421808714961
                NSString *accessTokenForCurrentUser = [result valueForKey:accessTokenKey];
                NSDictionary *params = @{
                                         @"object": @"https://graph.facebook.com/681421808714961",
                                         };
                /* make the API call */
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:@"me/og.likes"
                                              parameters:params
                                              tokenString:accessTokenForCurrentUser version:graphAPIVersion
                                              HTTPMethod:HTTP_POST];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                    
                    if (error!=nil){
                        
                        NSLog(@"Liked Page");
                    }
                }];
            }
        }];
    }

        
//    }];
}

@end
