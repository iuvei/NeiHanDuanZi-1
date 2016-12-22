//
//  ShenPingBgView.m
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "ShenPingBgView.h"

@implementation ShenPingBgView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.comment.numberOfLines = 0;
    
}


#pragma mark --点赞、转发--
- (IBAction)digUpAction:(UIButton *)sender {
    NSLog(@"digUp");
}
- (IBAction)shareAction:(UIButton *)sender {
    NSLog(@"share");
}

#pragma mark --点击头像---


@end
