//
//  UIView+UIViewExtension.m
//  UIViewExtension
//
//  Created by fuyuzheng on 2016/10/12.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "UIView+UIViewExtension.h"

@implementation UIView (UIViewExtension)

- (CGFloat)Z_width {
    
    return self.frame.size.width;
}

- (void)setZ_width:(CGFloat)Z_width {
    
    CGRect frame = self.frame;
    frame.size.width = Z_width;
    self.frame = frame;
    
}

- (CGFloat)Z_height {
    
    return self.frame.size.height;
}

- (void)setZ_height:(CGFloat)Z_height {
    
    CGRect frame = self.frame;
    frame.size.height = Z_height;
    self.frame = frame;
}

- (CGFloat)Z_x {
    
    return self.frame.origin.x;
}

-(void)setZ_x:(CGFloat)Z_x {
    
    CGRect frame = self.frame;
    frame.origin.x = Z_x;
    self.frame = frame;
}

- (CGFloat)Z_y {
    
    return self.frame.origin.y;
}

-(void)setZ_y:(CGFloat)Z_y {
    
    CGRect frame = self.frame;
    frame.origin.y = Z_y;
    self.frame = frame;
}

- (CGFloat)Z_centerX {
    
    return self.center.x;
}

- (void)setZ_centerX:(CGFloat)Z_centerX {
    
    CGPoint center = self.center;
    center.x = Z_centerX;
    self.center = center;
}

- (CGFloat)Z_centerY {
    
    return self.center.y;
}

- (void)setZ_centerY:(CGFloat)Z_centerY {
    
    CGPoint center = self.center;
    center.y = Z_centerY;
    self.center = center;
}

- (CGFloat)Z_right {
    
    return self.Z_x + self.Z_width;
}

- (void)setZ_right:(CGFloat)Z_right {
    
    self.Z_x = Z_right - self.Z_width;//确定X值
}

- (CGFloat)Z_bottom {
    
    return self.Z_y + self.Z_height;
}

- (void)setZ_bottom:(CGFloat)Z_bottom {
    
    self.Z_y = Z_bottom - self.Z_height;
}


@end




























































