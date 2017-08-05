//
//  CreatePostViewController.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/27/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "CreatePostViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Constants.h"

@interface CreatePostViewController ()
@property(nonatomic) BOOL dirty;
@property(nonatomic) UIDatePicker* picker;
@property(nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic) NSTimeInterval timeToPost;
@end

static NSString* placeHolderText = @"Write here";
static NSString* backdate = @"Backdate";
static NSString* scheduleTitle = @"Schedule";
static NSString* postTitle = @"Post";

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.textView setText:placeHolderText];
    _dirty=NO;
    
    _picker = [[UIDatePicker alloc] init];
    _picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [_picker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [_picker sizeThatFits:CGSizeZero];
    _picker.frame = CGRectMake(0, [self.view frame].size.height - pickerSize.height, [self.view frame].size.width, pickerSize.height);
    [self.view addSubview:_picker];
    _picker.hidden = YES;
     _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH:mm"];
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
    
    if(![self validate]) return;
    [self makeRequest:NO];
}

-(IBAction)savePost:(id)sender{

    if(![self validate]) return;
    [self makeRequest:YES];
}

-(void) makeRequest:(BOOL) saveOnly{

    NSDictionary *params = [self getParameters:saveOnly];
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:managePages]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:pageFeedPath,_pageId]
                                           parameters: params
                                          tokenString: _pageAccessToken
                                              version:graphAPIVersion
                                           HTTPMethod:HTTP_POST]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Post id:%@", result[idKey]);
                 
                 // persist saved ids
/*                 if (saveOnly){
                     [NSString stringWithFormat:@"%@:%@",savedPostsKeyInDefaults,_pageId];
                     NSMutableArray* array = [[[NSUserDefaults standardUserDefaults] objectForKey:savedPostsKeyInDefaults] mutableCopy];
                     if (array == nil){
                         
                         array = [[NSMutableArray alloc] init];
                     }
                     [array addObject:result[idKey]];
                     [[NSUserDefaults standardUserDefaults] setObject:array forKey:savedPostsKeyInDefaults];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
*/                 
                 [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:reloadPageNotification object:nil]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self dismissSelf:nil];
                 });
             }
         }];
    }
}

-(BOOL) validate{

    if (!_dirty || ![_textView hasText]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter some text!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return false;
    }
    
    return true;
}

-(NSDictionary*) getParameters:(BOOL) saveOnly{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary: @{ @"message" : _textView.text}];
    
    if (saveOnly){
    
        [params setObject:@"false" forKey:publishedParam];
        return params;
    }
    
    NSNumber *timeToPostInt = [NSNumber numberWithDouble:_timeToPost];
    
    if ([[[_postButton titleLabel] text] isEqualToString:backdate]){
    
        [params setObject:timeToPostInt forKey:backdatedTimeParam];
    }else if ([[[_postButton titleLabel] text] isEqualToString:scheduleTitle]){
        
        [params setObject:timeToPostInt forKey:scheduledPublishTimeParam];
        [params setObject:@"false" forKey:publishedParam];
    }
    
    return params;
}

-(IBAction) dismissKeyPad:(id)sender{
    [_textView resignFirstResponder];
    [_picker setHidden:YES];
}

-(IBAction)dismissSelf:(id)sender{
    
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)schedulePost:(id)sender{

}

-(IBAction)selectTime:(id)sender{

    [_picker setHidden:NO];
}

-(void)onDatePickerValueChanged:(UIDatePicker*) picker{

    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeNow = [currentDate timeIntervalSince1970];
    NSDate* selectedDate = picker.date;
    NSTimeInterval timeSelected = [selectedDate timeIntervalSince1970];
    NSTimeInterval diff = timeSelected - timeNow;
    _timeToPost = timeSelected;
    
    if(diff < 60 && diff > -60){
        
        [_postButton setTitle:postTitle forState:UIControlStateNormal];
        _timeToPost = 0;
    }else if (diff < 0){
        
        [_postButton setTitle:backdate forState:UIControlStateNormal];
    }else if (diff > 0){
    
        [_postButton setTitle:scheduleTitle forState:UIControlStateNormal];
    }
}

@end
