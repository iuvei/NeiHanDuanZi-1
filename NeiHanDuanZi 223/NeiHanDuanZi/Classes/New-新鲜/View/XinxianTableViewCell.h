//
//  XinxianTableViewCell.h
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XinxianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property(nonatomic,strong)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@end
