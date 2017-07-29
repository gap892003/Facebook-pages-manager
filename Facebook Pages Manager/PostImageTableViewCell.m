//
//  PostTableViewCell.m
//  Facebook Pages Manager
//
//  Created by Gaurav Joshi on 7/24/17.
//  Copyright © 2017 Gaurav Joshi. All rights reserved.
//

#import "PostImageTableViewCell.h"
#import "UIImageView+ImageHelper.h"

@implementation PostImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) loadData:(NSDictionary*) post andPage:(NSDictionary*) _pageDetails{
    [super loadData:post andPage:_pageDetails];
    [[self  image] lazyLoadWithUrl:[post objectForKey:@"full_picture"]];
}
@end
