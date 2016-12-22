//
//  TuiJianGuanZhuTableViewCell.h
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuiJianGuanZhuTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userType;
@property (strong, nonatomic) IBOutlet UILabel *userDescribe;
@property (strong, nonatomic) IBOutlet UIButton *attentionBtn;

@end
