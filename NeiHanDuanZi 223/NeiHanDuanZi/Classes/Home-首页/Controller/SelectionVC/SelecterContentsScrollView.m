//
//  SelecterContentsScrollView.m
//  UI_SelectTool
//
//  Created by fuyuzheng on 2016/11/1.
//  Copyright © 2016年 Rick_Liu. All rights reserved.
//

#import "SelecterContentsScrollView.h"

@implementation SelecterContentsScrollView

- (instancetype)initWithFrame:(CGRect)frame SelecterConditionVCArray:(NSArray *)vcArray andBtnBlock:(ScrollPage)scrollPage{

    if (self = [super init]) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        _vcArray = [NSArray arrayWithArray:vcArray];
        
        [self lazyLoadVCFromIndex:0];
        
        self.contentSize = CGSizeMake(ScreenWidth * vcArray.count, 0);
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        
        self.scrollPage = scrollPage;
    }
    return self;
}

- (void)lazyLoadVCFromIndex:(NSInteger)index{

    UIViewController *pageVC = _vcArray[index];
    pageVC.view.frame = CGRectMake(ScreenWidth*index, 0, ScreenWidth, self.frame.size.height);
    [self addSubview:pageVC.view];
}

- (void)updateVCViewFromIndex:(NSInteger)index{

    [self setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int pageNum = scrollView.contentOffset.x  / ScreenWidth;
    [self lazyLoadVCFromIndex:pageNum];
    self.scrollPage(pageNum);
}

@end




















































































