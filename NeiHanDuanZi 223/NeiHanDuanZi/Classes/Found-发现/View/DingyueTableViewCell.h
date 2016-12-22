//
//  DingyueTableViewCell.h
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingyueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *updateCount;
@property(nonatomic,strong)NSDictionary  *dataDic;

@end
