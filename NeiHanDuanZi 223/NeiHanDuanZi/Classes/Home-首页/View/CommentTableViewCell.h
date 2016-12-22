//
//  CommentTableViewCell.h
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *digupBtn;
@property (strong, nonatomic) IBOutlet UILabel *digupCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,strong)NSDictionary *hotCommentDic;
@property (nonatomic,strong)NSDictionary *recentCommentDic;

@end
