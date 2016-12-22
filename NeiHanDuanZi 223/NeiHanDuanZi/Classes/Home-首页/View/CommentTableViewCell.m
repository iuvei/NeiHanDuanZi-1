//
//  CommentTableViewCell.m
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userHeaderImageView.layer.cornerRadius = 17.5;
    self.userHeaderImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)digupAction:(UIButton *)sender {
    
    
}
- (IBAction)shareAction:(UIButton *)sender {
    
    
}

#pragma mark --setter--
- (void)setHotCommentDic:(NSDictionary *)hotCommentDic {
    
    self.userNameLabel.text = hotCommentDic[@"user_name"];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:hotCommentDic[@"avatar_url"]]];
    self.digupCountLabel.text = [NSString stringWithFormat:@"%ld",[hotCommentDic[@"digg_count"] integerValue]];
    self.contentLabel.text = hotCommentDic[@"text"];
    
    
}











@end
