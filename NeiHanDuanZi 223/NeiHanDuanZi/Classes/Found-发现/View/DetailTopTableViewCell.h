//
//  DetailTopTableViewCell.h
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/24.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userCount;
@property (weak, nonatomic) IBOutlet UILabel *tieCount;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) NSDictionary    *userInfo;
@end
