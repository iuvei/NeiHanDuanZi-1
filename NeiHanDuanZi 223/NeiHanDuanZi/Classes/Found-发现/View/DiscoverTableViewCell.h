//
//  DiscoverTableViewCell.h
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/22.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DiscoverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UILabel *dingyueCount;
@property (weak, nonatomic) IBOutlet UILabel *tieCount;
@property(nonatomic,strong)NSDictionary  *dataDic;
@property (weak, nonatomic) IBOutlet UIButton *dingyueBtn;
@property(nonatomic,assign)NSNumber   *idNum;
@end
