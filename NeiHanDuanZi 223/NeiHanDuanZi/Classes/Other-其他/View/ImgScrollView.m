//
//  ImgScrollView.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/25.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "ImgScrollView.h"
#import <UIImageView+WebCache.h>
@implementation ImgScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openimg:)];
    [self.backImgView addGestureRecognizer:tap];
    [self.blackBottomImg  addGestureRecognizer:tap];
    self.showsVerticalScrollIndicator=NO;
    self.showsHorizontalScrollIndicator=NO;
    self.scrollEnabled=NO;
    self.layer.masksToBounds=YES;

}
-(void)openimg:(UITapGestureRecognizer*)ges{

    [self openLongImg];
}


- (IBAction)longsender:(UIButton *)sender {
    [self openLongImg];
    
    
}
//展开图片方法
-(void)openLongImg{  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openImg" object:self userInfo:@{@"height":[NSNumber numberWithFloat:self.imgHeight ]}];

}

//设置器
-(void)setUrlString:(NSString *)urlString{
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
}




@end
