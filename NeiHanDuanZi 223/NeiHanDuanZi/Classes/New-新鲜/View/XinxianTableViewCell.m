//
//  XinxianTableViewCell.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "XinxianTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <UIImage+GIF.h>
#import "ReturnTableViewCellHeight.h"
@implementation XinxianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.content.numberOfLines=0;
   
}

-(void)setDataDic:(NSDictionary *)dataDic{
    NSDictionary *group=dataDic[@"group"];
    NSInteger num=[group[@"media_type"] integerValue];;
    self.content.text=group[@"text"];

    CGFloat h=[ReturnTableViewCellHeight dealWithString:group[@"text"] fontSize:15.0];
    self.contentHeight.constant=h+17;
    if (num==0) {
        self.imgHeight.constant=0;
        [self.img removeFromSuperview];
    }
    else if(num==1){
        NSDictionary *middle_image=group[@"middle_image"];
        
        CGFloat h=[middle_image[@"height"] floatValue];
        if (h>=700) {
                self.imgHeight.constant=700;
        }
        else{
            self.imgHeight.constant=[middle_image[@"height"] floatValue];
        }
        NSArray *url_list=middle_image[@"url_list"];
        NSString *url=[url_list[1] objectForKey:@"url"];
        [self.img sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@""]options:SDWebImageRetryFailed];
        
    }
    else if (num==2){
        NSDictionary *gifvideo=group[@"gifvideo"];
        NSDictionary *p_video=gifvideo[@"360p_video"];
        NSArray *url_list=p_video[@"url_list"];
        NSString *url=[url_list[1] objectForKey:@"url"];
        
        CGFloat h=[p_video[@"height"] floatValue];
        if (h>=700) {
                self.imgHeight.constant=700;
        }
        else{
            self.imgHeight.constant=[p_video[@"height"] floatValue];
        }
        
        //缺图片数据
        [self.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]options:SDWebImageRetryFailed];
        
   
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
