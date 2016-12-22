//
//  ReturnTableViewCellHeight.m
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "ReturnTableViewCellHeight.h"

#define TotalSpace 105
#define TotalControlHeight 87

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ReturnTableViewCellHeight

+ (CGFloat)returnTableViewCellHeightWithContent:(NSString *)content imageViewHeigh:(CGFloat)height shenPingContentArray:(NSArray<NSString *> *)array {
    
    CGFloat cellHeight;
    
    CGFloat contentheight = [self dealWithString:content fontSize:15];
    
    for (NSString *str in array) {
        
        CGFloat height = [self dealWithString:str fontSize:13];
        cellHeight+=height;
    }
    
    cellHeight = cellHeight + contentheight + height + TotalSpace + TotalControlHeight;
    
    return cellHeight;
}

+ (CGFloat)dealWithString:(NSString *)string fontSize:(CGFloat)size {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth-41, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    return rect.size.height;
}

@end
