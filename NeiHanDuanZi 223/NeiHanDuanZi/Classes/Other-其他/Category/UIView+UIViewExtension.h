//
//  UIView+UIViewExtension.h
//  UIViewExtension
//
//  Created by fuyuzheng on 2016/10/12.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewExtension)

@property (nonatomic,assign)CGFloat Z_width;//避免与系统或者第三方同名，可以加一些独有的前缀
@property (nonatomic,assign)CGFloat Z_height;
@property (nonatomic,assign)CGFloat Z_x;
@property (nonatomic,assign)CGFloat Z_y;
@property (nonatomic,assign)CGFloat Z_centerX;
@property (nonatomic,assign)CGFloat Z_centerY;
@property (nonatomic,assign)CGFloat Z_right;
@property (nonatomic,assign)CGFloat Z_bottom;

@end
