//
//  SelecterContentsScrollView.h
//  UI_SelectTool
//
//  Created by fuyuzheng on 2016/11/1.
//  Copyright © 2016年 Rick_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollPage)(int num);

@interface SelecterContentsScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray  *vcArray;

@property (nonatomic,copy)ScrollPage  scrollPage;

- (instancetype)initWithFrame:(CGRect)frame SelecterConditionVCArray:(NSArray *)vcArray andBtnBlock:(ScrollPage)scrollPage;

- (void)updateVCViewFromIndex:(NSInteger)index;

@end






















































































