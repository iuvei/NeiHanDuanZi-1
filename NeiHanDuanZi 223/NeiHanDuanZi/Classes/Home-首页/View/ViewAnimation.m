//
//  ViewAnimation.m
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/29.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "ViewAnimation.h"

@implementation ViewAnimation


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i = 1; i < 26; i++) {
            
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [imgArray addObject:img];
        }
        
        self.contentMode = UIViewContentModeScaleAspectFit;
//        [imgArray addObject:[UIImage imageNamed:@"refreshjoke_loading"]];
        [self setAnimationImages:imgArray];
        
        [self setAnimationDuration:0.6];
        self.animationRepeatCount = 0;
        [self startAnimating];
    }
    
    return self;
}



@end
