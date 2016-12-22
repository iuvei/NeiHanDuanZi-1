//
//  RebaViewController.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/22.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "RebaViewController.h"
#import "DiscoverTableViewCell.h"
#import "AFNetworkingRequest.h"
#import "TopTableViewCell.h"
#import "DiscoverDetailViewController.h"
@class DiscoverViewController;
@interface RebaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *imgArray;

@property (nonatomic,strong)UIView *view1;

@property (nonatomic,strong)ViewAnimation *animatingView;

@end

@implementation RebaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self netWrokingRequest];
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49)];
    self.view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view1];
    [self.view1 addSubview:self.animatingView];
    self.animatingView.center = self.view1.center;
}

- (ViewAnimation *)animatingView {
    
    if (!_animatingView) {
        
        _animatingView = [[ViewAnimation alloc] initWithFrame:CGRectMake(0, 0, 160, 240)];
    }
    
    return _animatingView;
}


#pragma 懒加载
-(NSMutableArray*)dataSource{
    
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    
    
    return _dataSource;
    
    
}
-(NSMutableArray*)imgArray{
    if (!_imgArray) {
        _imgArray=[NSMutableArray array];
    }
    return _imgArray;
}
-(UITableView*)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=RLColor(241, 241, 241);
        [_tableView registerNib:[UINib nibWithNibName:@"TopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"topCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"discoverID" ];
        
    }
    return _tableView;
}

#pragma 网络请求
-(void)netWrokingRequest{
    
    NSString *urlString=@"http://iu.snssdk.com/2/essay/discovery/v3/?iid=6283173394&os_version=10.0&os_api=18&app_name=joke_essay&channel=App%20Store&device_platform=iphone&idfa=BE8C5831-482D-43E9-9A6E-B5E97EDA7583&live_sdk_version=130&vid=9E81C4DD-570F-4E4B-86B2-06045DCF3C23&openudid=b108c8e2cddf068f234207f72c5859321f81a13a&device_type=iPhone8,1&version_code=5.7.0&ac=WIFI&screen_width=750&device_id=34160507909&aid=7";
    [AFNetworkingRequest getRequestWithUrl:urlString result:^(id result) {
        
        NSDictionary *data=result[@"data"];
        NSDictionary *rotate_banner=data[@"rotate_banner"];
        NSArray *banners=rotate_banner[@"banners"];
        for (int i=0; i<banners.count; i++) {
            NSDictionary *dic=banners[i];
            NSDictionary *banner_url=dic[@"banner_url"];
            NSArray *url_list=banner_url[@"url_list"];
            NSString *str=[url_list[0] objectForKey:@"url"];
            [self.imgArray addObject:str];
        }
        
        NSDictionary *cate=data[@"categories"];
        NSArray *array=cate[@"category_list"];
        for (id obj in array) {
            [self.dataSource addObject:obj];
        }
        [self.animatingView stopAnimating];
        [self.view1 removeFromSuperview];
        [self.tableView reloadData];
        
    }];
    
    
}



#pragma 协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
    
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    
    return self.dataSource.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        TopTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier: @"topCell"forIndexPath:indexPath];
        cell.imgArray=self.imgArray;
        return cell;
        
    }
    else{
        DiscoverTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"discoverID" forIndexPath:indexPath];
        cell.dataDic=self.dataSource[indexPath.row-1];
        cell.selectionStyle=UITableViewCellAccessoryNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 248;
    }
    else{
        return 80;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverDetailViewController *detailVC=[[DiscoverDetailViewController alloc]init];
    detailVC.topDictionary=self.dataSource[indexPath.row-1];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
    
}



@end
