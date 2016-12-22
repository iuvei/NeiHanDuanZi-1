//
//  TuPianViewController.m
//  NeiHanDuanZi
//
//  Created by 清邹 on 2016/11/19.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "TuPianViewController.h"
#import "DetailViewController.h"
#import "HomeViewController.h"

@interface TuPianViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)NSMutableArray *cellHeigthArray;

@property (nonatomic,strong)NSString *urlString;

@property (nonatomic,strong)ViewAnimation *animatingView;

@property (nonatomic,strong)UIView *view1;


@property (nonatomic,strong)NSString *userStr;
@property (nonatomic,strong)NSString *commentStr;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)NSMutableArray *oldDataArray;


@end

@implementation TuPianViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    _oldDataArray = [NSMutableArray array];
    
    _cellHeigthArray=[NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self beginNetworkRequest];
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49-30)];
    self.view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.view1];
    [self.view1 addSubview:self.animatingView];
    self.animatingView.center = self.view1.center;
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


- (void)beginNetworkRequest {
    
    self.urlString = @"http://ic.snssdk.com/neihan/stream/mix/v1/?content_type=-103";
    [AFNetworkingRequest getRequestWithUrl:self.urlString result:^(id result) {
        
        NSDictionary *dic = result[@"data"];
        NSArray *array = dic[@"data"];
        for (id object in array) {
            [self.dataSource addObject:object];
        }
//        NSLog(@"%p",self.dataSource);
        [self setCellHeight];
        [self removeAdFromDataSource];
        [self.animatingView stopAnimating];
        [self.view1 removeFromSuperview];
        [self.tableView reloadData];
    }];
}

- (void)loadNewData {
    
    NSLog(@"刷新");
    NSString *urlString = @"http://lf.snssdk.com/neihan/stream/mix/v1/?content_type=-103&iid=6313378117&os_version=10.0&os_api=18&app_name=joke_essay&channel=App%20Store&device_platform=iphone&idfa=BE8C5831-482D-43E9-9A6E-B5E97EDA7583&live_sdk_version=130&vid=9E81C4DD-570F-4E4B-86B2-06045DCF3C23&openudid=b108c8e2cddf068f234207f72c5859321f81a13a&device_type=iPhone8,1&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34160507909&aid=7&city=%E5%B9%BF%E4%B8%9C%E7%9C%81&content_type=-103&count=30&essence=1&latitude=23.13519785356154&longitude=113.2495263417854&message_cursor=0&min_time=1480379813&mpic=1";
    [AFNetworkingRequest getRequestWithUrl:urlString result:^(id result) {
        
        NSDictionary *dic = result[@"data"];
        NSArray *array = dic[@"data"];
        for (id obj in self.dataSource) {
            
            [_oldDataArray addObject:obj];
        }
        [self.dataSource removeAllObjects];
        
        for (id object in array) {
            [self.dataSource addObject:object];
        }
        [self.cellHeigthArray removeAllObjects];
        [self setCellHeight];
        [self removeAdFromDataSource];
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
    }];

    
}

- (void)loadMoreData {
    
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        for (id obj in self.oldDataArray) {
            [self.dataSource addObject:obj];
        }
        [self.cellHeigthArray removeAllObjects];
        [self setCellHeight];
        [self.tableView.mj_footer endRefreshing];
        [self.oldDataArray removeAllObjects];
        [self.tableView reloadData];
    }

    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic1 = self.dataSource[indexPath.section];
    
    NSDictionary *dic2 = dic1[@"group"];
//    NSNumber *userID = [dic2[@"user"] objectForKey:@"user_id"];
    NSNumber *groupID = dic2[@"group_id"];
    //    _dic = dic1;
    //用户数据信息
//    NSString *str1 = @"http://isub.snssdk.com/neihan/user/profile/v2/?iid=6313378117&os_version=10.0&os_api=18&app_name=joke_essay&channel=App%20Store&device_platform=iphone&idfa=BE8C5831-482D-43E9-9A6E-B5E97EDA7583&live_sdk_version=130&vid=9E81C4DD-570F-4E4B-86B2-06045DCF3C23&openudid=b108c8e2cddf068f234207f72c5859321f81a13a&device_type=iPhone8,1&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34160507909&aid=7&user_id";
    //    _userStr = [NSString stringWithFormat:@"%@=%ld",str1,[userID integerValue]];
    //评论信息
    NSString *str2 = @"http://isub.snssdk.com/neihan/comments/?iid=6313378117&os_version=10.0&os_api=18&app_name=joke_essay&idfa=BE8C5831-482D-43E9-9A6E-B5E97EDA7583&live_sdk_version=130&vid=9E81C4DD-570F-4E4B-86B2-06045DCF3C23&openudid=b108c8e2cddf068f234207f72c5859321f81a13a&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34160507909&aid=7&count=20&device_id=34160507909&group_id";
    NSString *str3 = @"&offset=0&sort=hot&tag=joke";
    NSString *commentStr = [NSString stringWithFormat:@"%@=%ld%@",str2,[groupID integerValue],str3];
    
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.commentStr = commentStr;
    detailVC.groupDic = dic1;
    [self.vc.navigationController pushViewController:detailVC animated:YES];
    HomeViewController *homeVC = (HomeViewController *)self.vc;
    homeVC.seg.hidden = YES;
}

@end
