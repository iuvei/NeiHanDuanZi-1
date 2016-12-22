//
//  DingyueTableViewCell.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "DingyueTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation DingyueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
-(void)setDataDic:(NSDictionary *)dataDic{
    self.title.text=dataDic[@"name"];
    NSString *url=dataDic[@"icon"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"big_defaulthead_head"]];
    self.content.text=dataDic[@"intro"];
    self.updateCount.text=[NSString stringWithFormat:@"%@",dataDic[@"today_updates"]];

}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
