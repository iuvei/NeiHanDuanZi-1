//
//  TuiJianNeiHanJingHuaTableViewCell.h
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuiJianNeiHanJingHuaTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgImageViewHeight;

@end
