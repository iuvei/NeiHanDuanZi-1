//
//  DingyueViewController.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/22.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "DingyueViewController.h"
#import <UIImageView+WebCache.h>
#import "AFNetworkingRequest.h"
#import "DingyueTableViewCell.h"
#import "DiscoverDetailViewController.h"

@interface DingyueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation DingyueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self netWrokingRequest];
    [[NSNotificationCenter   defaultCenter]addObserver:self selector:@selector(refreashData:) name:@"success" object:nil];
    
    
    
}

#pragma 懒加载
-(NSMutableArray*)dataSource{
    
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }

    return _dataSource;
    
    
}
-(UITableView*)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=RLColor(241, 241, 241);
        [_tableView registerNib:[UINib nibWithNibName:@"DingyueTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"dingyueCell"];
        
    }
    return _tableView;
}
-(void)netWrokingRequest{
    
    NSString *urlString=@"http://i.snssdk.com/api/2/essay/zone/subscribe_categories/?iid=6313313255&screen_width=750&app_name=joke_essay&vid=36DFF92C-5E71-4658-9C18-B89B337031AD&openudid=CC0E83A4-4C1B-4C64-AA9D-63E8A5F533D9&device_type=iPhone8%2C1&version_code=5.7.1&ac=WIFI&device_id=34641821461&aid=7&os_version=10.1.1&csrfmiddlewaretoken=undefined";
    [AFNetworkingRequest getRequestWithUrl:urlString result:^(id result) {
        NSArray *array=result[@"data"];
        for (id obj in array) {
            [self.dataSource addObject:obj];
        }
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
    
  
        DingyueTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"dingyueCell" forIndexPath:indexPath];
        cell.dataDic=self.dataSource[indexPath.row];
        cell.selectionStyle=UITableViewCellAccessoryNone;
        return cell;
  
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}


-(void)refreashData:(NSNotification*)noti{
    [self.dataSource removeAllObjects];
    [self netWrokingRequest];


}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=self.dataSource[indexPath.row];
    
    DiscoverDetailViewController *dv=[[DiscoverDetailViewController alloc]init];
    dv.topDictionary=dic;
    [self.parentViewController.navigationController pushViewController:dv animated:YES];
    
    
}




@end
