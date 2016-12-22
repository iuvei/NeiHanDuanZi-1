//
//  SelectionViewController.m
//  NeiHanDuanZi
//
//  Created by 清邹 on 2016/11/19.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelecterToolsScrollView.h"
#import "SelecterContentsScrollView.h"
#import "ZhiBoViewController.h"
#import "TuiJianViewController.h"
#import "ShiPinViewController.h"
#import "TuPianViewController.h"
#import "DuanZiViewController.h"
#import "TongChengViewController.h"

@interface SelectionViewController ()

@property (nonatomic,strong)NSMutableArray *textArray;
@property (nonatomic,strong)NSMutableArray *vcArray;

@property (nonatomic, strong) SelecterToolsScrollView *selectToolScrollView;
@property (nonatomic, strong) SelecterContentsScrollView *selectContentScrollView;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSelectToolScrollView];
    _selectToolScrollView.layer.borderWidth = 0.5;
    _selectToolScrollView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self createSelectContentScrollView];

}

#pragma mark --懒加载--
- (NSMutableArray *)textArray {
    
    if (!_textArray) {
        
        _textArray = [NSMutableArray arrayWithObjects: @"推荐", @"视频", @"图片", @"段子", @"同城", nil];
    }
    return _textArray;
}


- (NSMutableArray *)vcArray {
    
    if (!_vcArray) {
        
        _vcArray = [NSMutableArray array];
        
        TuiJianViewController *tuijianVC = [TuiJianViewController new];
        ShiPinViewController *shipinVC = [ShiPinViewController new];
        TuPianViewController *tupianVC = [TuPianViewController new];
        DuanZiViewController *duanziVC = [DuanZiViewController new];
        TongChengViewController *tongchengVC = [TongChengViewController new];

        [_vcArray addObject:tuijianVC];
        [_vcArray addObject:shipinVC];
        [_vcArray addObject:tupianVC];
        [_vcArray addObject:duanziVC];
        [_vcArray addObject:tongchengVC];
        
        tuijianVC.vc = _vc;
        tupianVC.vc = _vc;
        shipinVC.vc = _vc;
        duanziVC.vc = _vc;
        tongchengVC.vc = _vc;
        
    }
    return _vcArray;
}

#pragma mark --创建顶部toolscrollView--
- (void)createSelectToolScrollView {
    
    __weak typeof(self) weakSelf = self;

    CGRect rect = CGRectMake(0, 64, ScreenWidth, 35);
    _selectToolScrollView = [[SelecterToolsScrollView alloc] initWithFrame:rect SeleterConditionTitleArray:self.textArray andBtnBlock:^(UIButton *btn) {
       
        [weakSelf upDateVCViewFromIndex:btn.tag-300];
    }];
    
    [self.view addSubview:_selectToolScrollView];
}

- (void)upDateVCViewFromIndex:(NSInteger)index {
    
    [_selectContentScrollView updateVCViewFromIndex:index];
}


#pragma mark --创建下面contentscrollView--
- (void)createSelectContentScrollView {
    
    __weak typeof(self) weakSelf = self;
    CGRect rect = CGRectMake(0, 99, ScreenWidth, ScreenHeight-99-49);
    _selectContentScrollView = [[SelecterContentsScrollView alloc] initWithFrame:rect SelecterConditionVCArray:self.vcArray andBtnBlock:^(int num) {
       
        [weakSelf upDateSelectToolIndex:num];
    }];
    _selectContentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_selectContentScrollView];
}

- (void)upDateSelectToolIndex:(NSInteger)index {
    
    [_selectToolScrollView updateSeletedToolsIndex:index];
}


@end




























