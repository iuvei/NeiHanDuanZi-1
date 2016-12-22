//
//  DiscoverTableViewCell.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/22.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "AFNetworkingRequest.h"
@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.cornerRadius=5;
    self.dingyueBtn.layer.borderWidth=1;
    self.dingyueBtn.layer.borderColor=[UIColor brownColor].CGColor;
    self.dingyueBtn.layer.cornerRadius=3;
}
- (IBAction)dingyueBtn:(UIButton *)sender {
    
    NSString *str=@"http://lf.snssdk.com/2/essay/zone/subscribe/?iid=6313313255&os_version=10.1.1&os_api=18&app_name=joke_essay&idfa=CC0E83A4-4C1B-4C64-AA9D-63E8A5F533D9&live_sdk_version=130&vid=36DFF92C-5E71-4658-9C18-B89B337031AD&openudid=7ce3d51c6af82f342ca38bd8e926f4db77914b76&device_type=iPhone8,1&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34641821461&aid=7&";
    NSString *url=[str stringByAppendingString:[NSString stringWithFormat:@"category_id=%ld&device_id=34641821461",[self.idNum integerValue]]];
    [AFNetworkingRequest getRequestWithUrl:url result:^(id result) {
        NSString *message =result[@"message"];
        if ([message isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"success" object:self];
        }
    }];
    NSLog(@"tuutuutuutu");
}

-(void)setDataDic:(NSDictionary *)dataDic{
    NSString *urlString=dataDic[@"icon_url"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"big_defaulthead_head"]];
    self.titleLabel.text=dataDic[@"name"];
    self.contentlabel.text=dataDic[@"intro"];
    self.dingyueCount.text=[NSString stringWithFormat:@"%@",dataDic[@"subscribe_count"]];
    self.tieCount.text=[NSString stringWithFormat:@"%@",dataDic[@"total_updates"]];
    self.idNum=dataDic[@"id"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
