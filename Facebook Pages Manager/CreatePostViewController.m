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
@end

static NSString* placeHolderText = @"Write here";

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textView setText:placeHolderText];
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

-(IBAction) createPost:(id)sender{
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        [[[FBSDKGraphRequest alloc]
          initWithGraphPath:[NSString stringWithFormat:@"%@/feed",_pageId]
          parameters: @{ @"message" : _textView.text}
          HTTPMethod:@"POST"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Post id:%@", result[@"id"]);
             }
         }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (![textView hasText]){
        [textView setText:placeHolderText];
    }

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    [textView setText:@""];
    return true;
}

-(IBAction) dismissKeyPad:(id)sender{
    [_textView resignFirstResponder];
}

-(IBAction)dismissSelf:(id)sender{
    
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
