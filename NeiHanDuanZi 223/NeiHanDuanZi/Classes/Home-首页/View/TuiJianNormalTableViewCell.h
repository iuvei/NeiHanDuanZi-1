//
//  TuiJianNormalTableViewCell.h
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShenPingBgView.h"
#import "VideoPlayView.h"
#import <UIImageView+WebCache.h>

@interface TuiJianNormalTableViewCell : UITableViewCell

@property (nonatomic,strong)VideoPlayView *videoView;
@property (nonatomic,strong)ShenPingBgView *shenPingBGView;

@property (strong, nonatomic) IBOutlet UIImageView *labelImage;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *kindBtn;
@property (strong, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) IBOutlet UIView *shenPingView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shenPingHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@property (strong, nonatomic) IBOutlet UILabel *caicount;
@property (strong, nonatomic) IBOutlet UILabel *commentcount;
@property (strong, nonatomic) IBOutlet UILabel *sharecount;
@property (strong, nonatomic) IBOutlet UILabel *digupCount;

@property (strong, nonatomic) IBOutlet UIButton *disLikeBtn;


@property (nonatomic,strong)NSDictionary *dataModelDic;
@property (nonatomic,strong)NSDictionary *group;

@property (nonatomic,strong)NSDictionary *userDic;
@property(nonatomic,strong)NSString *videoStr;//视频地址
@property(nonatomic,assign)CGFloat   videoHeight;

@property (nonatomic,strong)NSNumber *userID;
@property (nonatomic,strong)NSNumber *groupID;


@end
