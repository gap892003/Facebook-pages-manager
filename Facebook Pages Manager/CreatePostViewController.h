//
//  CreatePostViewController.h
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/27/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController<UITextViewDelegate>
@property (nonatomic,weak) IBOutlet UITextView *textView;
@property (nonatomic,weak) IBOutlet UILabel *placeholder;
@property(nonatomic,copy) NSString *pageId;
@property(nonatomic,copy) NSString *pageAccessToken;
-(IBAction) dismissKeyPad:(id)sender;
-(IBAction)dismissSelf:(id)sender;
@end
