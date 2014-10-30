//
//  FriendGroupTableViewCell.m
//  MyChat
//
//  Created by sky on 10/6/14.
//  Copyright (c) 2014 sky. All rights reserved.
//

#import "FriendGroupTableViewCell.h"

@implementation FriendGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.greatButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.contentView addSubview:self.greatButton];
    self.discussButton = [UIButton buttonWithType:UIButtonTypeSystem];
 
    [self.contentView addSubview:self.discussButton];
    
    
}


//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
