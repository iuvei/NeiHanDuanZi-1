//
//  ImgScrollView.h
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/25.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgScrollView : UIScrollView
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *blackBottomImg;
@property (weak, nonatomic) IBOutlet UIButton *longBtn;
@property(nonatomic,assign)CGFloat  imgHeight;//展开图片的高度
@property(nonatomic,strong)NSString *urlString;
@end
