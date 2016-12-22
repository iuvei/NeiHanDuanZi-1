//
//  MoreImgView.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/28.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "MoreImgView.h"
#import <UIImageView+WebCache.h>
#import "AFNetworkingRequest.h"
#import "MoreImgBtn.h"
#define ImgItemWidth   ([UIScreen mainScreen].bounds.size.width-30)/3
#define padding 5

@interface MoreImgView ()

@property (nonatomic,strong)UITapGestureRecognizer *tap;

@end

@implementation MoreImgView




-(void)setUrlArray:(NSArray *)urlArray{
    NSInteger count=urlArray.count;
    //行数   UIViewContentModeScaleAspectFit
    NSInteger num;
    //当前位置
    NSInteger index=0;
    if (count%3==0) {
        num=count/3;
    }
    else{
        num=(int)count/3+1;
  
    }
    for (int i=0; i<num; i++) {
        
        for (int j=0; j<3; j++) {
            if (index<urlArray.count) {
                
                MoreImgBtn *btn = [[[NSBundle mainBundle] loadNibNamed:@"MoreImgBtn" owner:nil options:nil] lastObject];
                btn.frame=CGRectMake((ImgItemWidth+padding)*j, (ImgItemWidth+padding)*i, ImgItemWidth, ImgItemWidth);
                btn.tag=500+index;
                NSString *urlString=[urlArray[index] objectForKey:@"url"];
                [btn.imgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
                
                [btn addTarget:self action:@selector(showlargeImg:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:btn];
                index++;
            }
            else{
                break;
            }
        }
    }
}
//点击代理
-(void)showlargeImg:(MoreImgBtn *)btn{
    NSInteger tag=btn.tag-500;
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bottomScrollView.contentSize = CGSizeMake(self.mUrlArray.count * ScreenWidth, 0);
    _bottomScrollView.contentOffset = CGPointMake(tag * ScreenWidth, 0);
    _bottomScrollView.backgroundColor = [UIColor blackColor];
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.bounces = NO;
    _bottomScrollView.delegate = self;

    [[UIApplication sharedApplication].keyWindow addSubview:_bottomScrollView];
    _label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2, 20, 40, 20)];

    _label.text = [NSString stringWithFormat:@"%ld/%ld",tag+1,self.mUrlArray.count];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:_label];
    for (int i = 0; i < self.mUrlArray.count; i++) {
        
        CGFloat imgHeight = [[self.mUrlArray[i] objectForKey:@"height"] doubleValue];
        if (imgHeight > ScreenHeight) {
            
            UIScrollView *smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight)];
            [_bottomScrollView addSubview:smallScrollView];
            smallScrollView.contentSize = CGSizeMake(0, imgHeight);
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
            imgView.center = _bottomScrollView.center;
            [UIView animateWithDuration:0.5 animations:^{
                
                imgView.frame = CGRectMake(0, 0, ScreenWidth, imgHeight);
            }];
            
            imgView.userInteractionEnabled = YES;
            _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imgView addGestureRecognizer:_tap];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.mUrlArray[i] objectForKey:@"url"]]];
            [smallScrollView addSubview:imgView];
        }
        else {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, (ScreenHeight-imgHeight)/2, ScreenWidth, imgHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.mUrlArray[i] objectForKey:@"url"]]];
            [_bottomScrollView addSubview:imgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            
        }
    }
}

#pragma mark --scrollView--
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x/ScreenWidth+1;
    _label.text = [NSString stringWithFormat:@"%ld/%ld",index,self.mUrlArray.count];
    
}

#pragma mark --手势--
- (void)tap:(UITapGestureRecognizer *)sender {
    
    [_bottomScrollView removeFromSuperview];
    [_label removeFromSuperview];
}

@end
