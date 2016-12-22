//
//  DiscoverDetailViewController.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/24.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "DetailTopTableViewCell.h"
#import "TuiJianNormalTableViewCell.h"
#import "AFNetworkingRequest.h"
#import "ReturnTableViewCellHeight.h"
#import "DiscoverViewController.h"

#define DETAILCELLTopID @"DetailTopTableViewCell"
#define DETAILCELLID     @"TuiJianNormalTableViewCell"

@interface DiscoverDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

/*tableView*/
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *cellHeigthArray;

@property (nonatomic, strong) DiscoverViewController *discoverVC;

@end

@implementation DiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    NSInteger categroy_id=[self.topDictionary[@"id"] integerValue];
    [self netWrokingRequestFromParameter:categroy_id];
    
//    DiscoverViewController *discoverVC = [DiscoverViewController new];
//    discoverVC.segControl.hidden = YES;
    
    NSArray *array = self.navigationController.viewControllers;
    NSMutableArray *mArray = [NSMutableArray array];
    for (id obj in array) {
        
        if ([obj class] == [DiscoverViewController class]) {
            
            [mArray addObject:obj];
        }
    }
    _discoverVC = mArray[0];
    _discoverVC.segControl.hidden = YES;
    
    [self setupNavigationBar];
    
}

#pragma mark --设置navigationBar--
- (void)setupNavigationBar {
    
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor brownColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"leftBackButtonFGNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"submission"] style:UIBarButtonItemStylePlain target:self action:@selector(submissionAction:)];
}

- (void)backAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

    _discoverVC.segControl.hidden = NO;
    
}

- (void)submissionAction:(UIBarButtonItem *)sender {
    
//    self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
    NSLog(@"发表");
}


-(NSMutableArray*)cellHeigthArray{
    if (!_cellHeigthArray) {
        _cellHeigthArray=[NSMutableArray array];
        [_cellHeigthArray addObject:[NSNumber numberWithFloat:100]];
    }
    return _cellHeigthArray;
}

-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
        [_dataSource addObject:self.topDictionary];
    }
    return _dataSource;
}
//tableView懒加载
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        [_tableView registerNib:[UINib nibWithNibName:@"TuiJianNormalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DETAILCELLID];
        [_tableView registerNib:[UINib nibWithNibName:@"DetailTopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:DETAILCELLTopID];
    }
    return _tableView;
}
-(void)netWrokingRequestFromParameter:(NSInteger)categroy_id{
    
    NSString *str=[NSString stringWithFormat:@"http://lf.snssdk.com/neihan/stream/category/data/v2/?tag=joke&iid=6313313255&os_version=10.1.1&os_api=18&app_name=joke_essay&idfa=CC0E83A4-4C1B-4C64-AA9D-63E8A5F533D9&live_sdk_version=130&vid=36DFF92C-5E71-4658-9C18-B89B337031AD&openudid=7ce3d51c6af82f342ca38bd8e926f4db77914b76&device_type=iPhone8,1&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34641821461&aid=7&category_id=%ld&count=30&level=6&message_cursor=0&mpic=1",categroy_id];
    
    [AFNetworkingRequest getRequestWithUrl:str result:^(id result) {
        
        NSDictionary *dic=result[@"data"];
        NSArray *group=dic[@"data"];
        for (id obj in group) {
            [self.dataSource addObject:obj];
        }
        [self setCellHeight];
        [self removeAdFromDataSource];
        [self.tableView reloadData];
        
    }];

}

#pragma --Mark---UITableViewDelegate,UITableViewDataSource协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *group=self.dataSource[indexPath.section];
    if (indexPath.section==0) {
        DetailTopTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:DETAILCELLTopID forIndexPath:indexPath];
        cell.userInfo=group;
        return cell;
    }
    else{
        static NSString *identifier = @"identifier";
        TuiJianNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuiJianNormalTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        else{
            //移除原有内容
            NSArray *array = cell.content.subviews;
            for (int i = 0; i < array.count; i++) {
                UIView *view = array[i];
                [view removeFromSuperview];
            }
        }
        cell.dataModelDic=group;
        cell.selectionStyle=UITableViewCellAccessoryNone;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    return [self.cellHeigthArray[indexPath.section] floatValue];
    //return 300;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
//处理cell高度
-(void)setCellHeight{
    
    static CGFloat h=192+50;
    //首先剔除广告
    [self removeAdFromDataSource];
    for (int i=1; i<self.dataSource.count; i++) {
        
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
            if (imgHeight > 300) {
                videoHeight = 286;
            }
            else {
                videoHeight = imgHeight;
            }
        }
        else if ([group[@"media_type"] integerValue] == 0){
            
            videoHeight = 0;
        }
        else {
            
            NSLog(@"media_type = %@",group[@"media_type"]);
            NSInteger num;
            NSArray *thumb_image_list=group[@"thumb_image_list"];
            if (thumb_image_list.count%3==0) {
                num=thumb_image_list.count/3;
            }
            else{
                num=(int)(thumb_image_list.count/3)+1;
                
            }
            videoHeight=num*([UIScreen mainScreen].bounds.size.width-40)/3+(num-1)*5;
            NSLog(@"media_type = %@",group[@"media_type"]);
            
            
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
