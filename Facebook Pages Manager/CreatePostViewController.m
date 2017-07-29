//
//  CreatePostViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/27/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "CreatePostViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CreatePostViewController ()
@property(nonatomic) BOOL dirty;
@end

static NSString* placeHolderText = @"Write here";

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.textView setText:placeHolderText];
    _dirty=NO;
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

#pragma mark - Textview delegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (![textView hasText]){
        [textView setText:placeHolderText];
        _dirty=NO;
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [textView setText:@""];
    _dirty=YES;
    return true;
}



#pragma mark - Actions

-(IBAction) createPost:(id)sender{
    
    if (!_dirty || ![_textView hasText]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter some text!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"manage_pages"]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/feed",_pageId]
          parameters: @{ @"message" : _textView.text}
          tokenString: _pageAccessToken
          version:@"v2.10"
          HTTPMethod:@"POST"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Post id:%@", result[@"id"]);
                 [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadPageFeed" object:nil]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self dismissSelf:nil];
                 });
             }
         }];
    }
}

-(IBAction) dismissKeyPad:(id)sender{
    [_textView resignFirstResponder];
}

-(IBAction)dismissSelf:(id)sender{
    
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)schedulePost:(id)sender{

}

@end
