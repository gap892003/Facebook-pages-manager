//
//  PostsTableViewCell.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/26/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "PostsTableViewCell.h"
#import "UIImageView+ImageHelper.h"

@implementation PostsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
