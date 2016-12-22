//
//  SelecterToolsScrollView.h
//  UI_SelectTool
//
//  Created by fuyuzheng on 2016/11/1.
//  Copyright © 2016年 Rick_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClick)(UIButton *btn);

@interface SelecterToolsScrollView : UIScrollView

@property (nonatomic,strong)NSMutableArray  *btnArray;

@property (nonatomic,strong)UIButton  *previousBtn;

@property (nonatomic,strong)UIButton  *currentBtn;

@property (nonatomic,strong)UIView  *bottomScrollLine;

@property (nonatomic,assign)CGFloat  titleBtnWidth;

@property (nonatomic,copy)BtnClick  btnClick;

- (instancetype)initWithFrame:(CGRect)frame SeleterConditionTitleArray:(NSArray *)titleArray andBtnBlock:(BtnClick)btnClick;

- (void)updateSeletedToolsIndex:(NSInteger)index;

@end














































































