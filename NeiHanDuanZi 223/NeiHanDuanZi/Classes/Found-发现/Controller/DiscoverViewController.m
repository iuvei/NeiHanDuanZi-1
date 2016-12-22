//
//  DiscoverViewController.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/22.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "AFNetworkingRequest.h"
#import "RebaViewController.h"
#import "DingyueViewController.h"

@interface DiscoverViewController ()

@property(nonatomic,strong)NSMutableArray *navArray;
@property(nonatomic,strong) RebaViewController *reBa;
@property(nonatomic,strong) DingyueViewController *dingyue;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNavgationBar];
    [self creatnavArray];
    
    
}

-(NSMutableArray*)navArray{

    if (!_navArray) {
        _navArray=[NSMutableArray array];
    }
    return _navArray;
}
//导航栏
-(void)setNavgationBar{
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"foundsearch"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nearbypeople"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(locationAction:)];
    
    _segControl=[[UISegmentedControl alloc]initWithItems:@[@"热吧",@"订阅"]];
    
    _segControl.frame=CGRectMake((ScreenWidth-125)/2, 7, 125, 30);
    [_segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
//    [_segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor]} forState:UIControlStateNormal];
//    [_segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateHighlighted];
    _segControl.tintColor=[UIColor brownColor];
    _segControl.selectedSegmentIndex=0;
    [_segControl addTarget:self action:@selector(selectVC:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:_segControl];

}

#pragma mark --响应事件--
- (void)searchAction:(UIBarButtonItem *)sender {
    
    NSLog(@"搜索");
}

- (void)locationAction:(UIBarButtonItem *)sender {
    
    NSLog(@"定位");
}


-(void)selectVC:(UISegmentedControl*)seg{

    NSInteger index=seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            _reBa.view.hidden=NO;
            _dingyue.view.hidden=YES;
            break;
        case 1:
            _reBa.view.hidden=YES;
            _dingyue.view.hidden=NO;
            break;
        default:
            break;
    }

}

-(void)creatnavArray{
    _dingyue=[[DingyueViewController alloc]init];
    [self addChildViewController:_dingyue];
    [self.view addSubview:_dingyue.view];
    [self.navArray addObject:_dingyue];
    _reBa=[[RebaViewController alloc]init];
    [self addChildViewController:_reBa];
    [self.view addSubview:_reBa.view];
    [self.navArray addObject:_reBa];
}




@end
