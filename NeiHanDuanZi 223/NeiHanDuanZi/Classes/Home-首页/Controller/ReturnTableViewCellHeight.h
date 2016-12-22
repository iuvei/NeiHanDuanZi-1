//
//  ReturnTableViewCellHeight.h
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReturnTableViewCellHeight : NSObject

+ (CGFloat)returnTableViewCellHeightWithContent:(NSString *)content imageViewHeigh:(CGFloat)height shenPingContentArray:(NSArray<NSString *> *)array;
+ (CGFloat)dealWithString:(NSString *)string fontSize:(CGFloat)size;

@end
