//
//  SelectionFatherViewController.m
//  NeiHanDuanZi
//
//  Created by ibokan2 on 2016/11/21.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "SelectionFatherViewController.h"
#import "TuiJianNormalTableViewCell.h"
#import "TuiJianGuanZhuTableViewCell.h"
#import "TuiJianNeiHanJingHuaTableViewCell.h"
#import "AFNetworkingRequest.h"
#import "AFNetworkingRequest+ProcessHTMLData.h"
#import "ReturnTableViewCellHeight.h"

@interface SelectionFatherViewController ()


@end

@implementation SelectionFatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _cellHeigthArray=[NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self beginNetworkRequest];
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49-30)];
    self.view1.backgroundColor = [UIColor whiteColor];
}



#pragma mark --animatingView--
- (ViewAnimation *)animatingView {
    
    if (!_animatingView) {
        
        _animatingView = [[ViewAnimation alloc] initWithFrame:CGRectMake(0, 0, 160, 240)];
    }
    
    return _animatingView;
}


#pragma mark --懒加载tableView--
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-94) style:UITableViewStylePlain];
        
        //header
        MJRefreshGifHeader *mjHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //设置普通状态的动画图片
        NSArray *array1 = @[[UIImage imageNamed:@"refresh_head"]];
        [mjHeader setImages:array1 forState:MJRefreshStateIdle];
        //设置即将刷新状态的动画图片
        NSArray *array2 = @[[UIImage imageNamed:@"refresh_head_2"]];
        [mjHeader setImages:array2 forState:MJRefreshStatePulling];
        //设置正在刷新的动画图片
        NSArray *array3 = @[[UIImage imageNamed:@"refresh_head_3"],[UIImage imageNamed:@"refresh_head_4"]];
        [mjHeader setImages:array3 forState:MJRefreshStateRefreshing];
        _tableView.mj_header = mjHeader;
        //隐藏时间
        mjHeader.lastUpdatedTimeLabel.hidden = YES;
        //隐藏状态
        mjHeader.stateLabel.hidden = YES;
        //footer
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //设置尾部
        _tableView.mj_footer = footer;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma mark --懒加载dataSource--
- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark --UITableViewDataSource--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *group = self.dataSource[indexPath.section];
    //防止单元格重用
    static NSString *identifier = @"identifier";
    TuiJianNormalTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell1) {
        
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"TuiJianNormalTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    else{
        //移除原有内容
        NSArray *array = cell1.content.subviews;
        for (int i = 0; i < array.count; i++) {
            UIView *view = array[i];
            [view removeFromSuperview];
        }
    }
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.dataModelDic =group;
    
    return cell1;
}

#pragma mark --UITableViewDelegate--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.cellHeigthArray[indexPath.section] floatValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark --网络请求--
- (void)beginNetworkRequest {
    
}

- (void)loadNewData {
    
    NSLog(@"刷新");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadNewData" object:self];
}

- (void)loadMoreData {
    
    NSLog(@"提载");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreData" object:self];
}

//处理cell高度
-(void)setCellHeight{
    
    static CGFloat h=192+50;
    //首先剔除广告
    [self removeAdFromDataSource];
    for (int i=0; i<self.dataSource.count; i++) {
        
        CGFloat shenpingHeight;
        NSDictionary *group=[self.dataSource[i] objectForKey:@"group"];
        NSMutableString *content=group[@"content"];
        CGFloat topLabelHeight=[ReturnTableViewCellHeight dealWithString:content fontSize:15];
        CGFloat videoHeight;
        
        if ([group[@"media_type"] integerValue] == 3){
            
            NSDictionary *video = group[@"360p_video"];
            CGFloat imgHeight = [video[@"height"] floatValue];
            if (imgHeight > 300) {
                videoHeight = 286;
            }
            else {
                videoHeight = imgHeight;
            }
        }
        else if ([group[@"media_type"] integerValue] == 1){
            
            NSDictionary *largeImagedic = group[@"large_image"];
            CGFloat imgHeight = [largeImagedic[@"height"] floatValue];
            if (imgHeight > 1000) {
                videoHeight = 400;
            }
            else {
                videoHeight = imgHeight;
            }
        }
        else if ([group[@"media_type"] integerValue] == 2) {
            
            NSDictionary *video=group[@"gifvideo"];
            NSDictionary *videoUrllsit=video[@"360p_video"];
            CGFloat imgHeight = [videoUrllsit[@"height"] floatValue];
            if (imgHeight >= 600) {
                videoHeight = 600;
            }
            else {
                videoHeight = imgHeight;
            }
        }
        else if ([group[@"media_type"] integerValue] == 0){
            
            videoHeight = 0;
        }
        else {
            
            NSInteger num;
            NSArray *thumb_image_list=group[@"thumb_image_list"];
            if (thumb_image_list.count%3==0) {
                num=thumb_image_list.count/3;
            }
            else{
                num=(int)(thumb_image_list.count/3)+1;
                
            }
            videoHeight=num*([UIScreen mainScreen].bounds.size.width-40)/3;
            
        }
        NSArray *comments=[self.dataSource[i] objectForKey:@"comments"];
        if (comments.count==0) {
            shenpingHeight = 0;
        }
        else{
            NSDictionary *comment=comments[0];
            NSString *text=comment[@"text"];
            shenpingHeight=[ReturnTableViewCellHeight dealWithString:text fontSize:13]+50;
        }
        CGFloat wholeHeight=topLabelHeight+h+videoHeight+shenpingHeight-40;
        [self.cellHeigthArray addObject:[NSNumber numberWithFloat:wholeHeight]];
    }
}

//移除广告
-(void)removeAdFromDataSource{
    
    for (int i=0; i<self.dataSource.count; i++) {
        
        NSDictionary *dic=self.dataSource[i];
        NSArray *allKeys=[dic allKeys];
        
        if ([allKeys containsObject:@"ad"]) {
            [self.dataSource removeObjectAtIndex:i];
        }
    }
}

@end
