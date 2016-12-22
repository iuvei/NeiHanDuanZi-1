//
//  DetailTopTableViewCell.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/24.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "DetailTopTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation DetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setUserInfo:(NSDictionary *)userInfo{
    NSString *urlString=userInfo[@"icon_url"];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"big_defaulthead_head"]];
    self.titleLabel.text=userInfo[@"intro"];
    self.userCount.text=[NSString stringWithFormat:@"%@",userInfo[@"subscribe_count"]];
    self.tieCount.text=[NSString stringWithFormat:@"%@",userInfo[@"total_updates"]];
 
}
- (IBAction)dingyueBtn:(UIButton *)sender {
    
    
    
}


@end
