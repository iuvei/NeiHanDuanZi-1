//
//  SelecterToolsScrollView.m
//  UI_SelectTool
//
//  Created by fuyuzheng on 2016/11/1.
//  Copyright © 2016年 Rick_Liu. All rights reserved.
//

#import "SelecterToolsScrollView.h"

@interface SelecterToolsScrollView ()

@property (nonatomic,strong)NSMutableArray  *titleArray;

@end

@implementation SelecterToolsScrollView

- (CGFloat)titleBtnWidth{
    
    if(!_titleBtnWidth){
        
        _titleBtnWidth = ScreenWidth/5;
    }
    return _titleBtnWidth;
}

- (instancetype)initWithFrame:(CGRect)frame SeleterConditionTitleArray:(NSArray *)titleArray andBtnBlock:(BtnClick)btnClick{

    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        CGFloat titleFont = 15;
        
        _btnArray = [NSMutableArray array];
        
        for (int i = 0; i < titleArray.count; i++) {
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            titleBtn.frame = CGRectMake(i*self.titleBtnWidth, 0, self.titleBtnWidth, 35);
            [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            
            [titleBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            
            titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:titleFont];
            
            titleBtn.tag = 300+i;
            [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:titleBtn];
            
            [_btnArray addObject:titleBtn];
            
            if (i == 0) {
                _previousBtn = titleBtn;
                _currentBtn = titleBtn;
                
                titleBtn.selected = YES;
                
                [titleBtn setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
            }
            else {
                
                
//                [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:titleFont]};
        
        CGSize size = [titleArray[0] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        CGFloat bottomScrollLineWidth = size.width;
        
        _bottomScrollLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, bottomScrollLineWidth, 3)];
        _bottomScrollLine.center = CGPointMake(_currentBtn.center.x, _bottomScrollLine.center.y);
        _bottomScrollLine.backgroundColor = [UIColor clearColor];
//        [self addSubview:_bottomScrollLine];
        
        self.contentSize = CGSizeMake(frame.size.width, 0);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.btnClick = btnClick;
        
        _titleArray = [NSMutableArray arrayWithArray:titleArray];
    }
    return self;
}

#pragma mark 响应事件
- (void)titleBtnAction:(UIButton *)sender{

    self.btnClick(sender);
}

- (void)updateSeletedToolsIndex:(NSInteger)index{

    UIButton *button = _btnArray[index];
    
    [self changeSelectBtn:button];
}

- (void)changeSelectBtn:(UIButton *)sender{

    _previousBtn = _currentBtn;
    
    [_previousBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    
    _currentBtn = sender;
    
    [_currentBtn setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
    
    _previousBtn.selected = NO;
    _currentBtn.selected = YES;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize size = [_titleArray[sender.tag-300] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        CGRect frame = _bottomScrollLine.frame;
        frame.size.width = size.width;
        _bottomScrollLine.frame = frame;
        _bottomScrollLine.center = CGPointMake(_currentBtn.center.x, _bottomScrollLine.center.y);
    }];
    
    //toolBtn居中
//    if (_currentBtn.center.x < ScreenWidth/2) {
//        
//        [self setContentOffset:CGPointZero animated:YES];
//    }
//    else if (_currentBtn.center.x > self.contentSize.width - ScreenWidth/2){
//    
//        [self setContentOffset:CGPointMake(self.contentSize.width - ScreenWidth, 0) animated:YES];
//    }
//    else{
//        [self setContentOffset:CGPointMake(_currentBtn.center.x - ScreenWidth/2, 0) animated:YES];
//    }
}


@end



















































































