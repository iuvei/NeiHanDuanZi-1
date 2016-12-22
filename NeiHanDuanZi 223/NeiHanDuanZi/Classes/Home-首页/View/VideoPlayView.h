//
//  VideoPlayView.h
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;

@property (strong, nonatomic) IBOutlet UILabel *playCount;

@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic,strong)NSString *urlString;

@end
