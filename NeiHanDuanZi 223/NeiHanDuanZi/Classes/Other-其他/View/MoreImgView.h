//
//  MoreImgView.h
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/28.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MoreImgViewDelegate <NSObject>

-(void)showLargeImg:(NSInteger)tagIndex mArray:(NSMutableArray *)mArray;


@end

@interface MoreImgView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray *mUrlArray;

@property(nonatomic,strong)NSArray *urlArray;
@property(nonatomic,assign)id<MoreImgViewDelegate>delegate;

@property (nonatomic,strong)UILabel *label;


@property (nonatomic,strong)UIScrollView *bottomScrollView;
@end
