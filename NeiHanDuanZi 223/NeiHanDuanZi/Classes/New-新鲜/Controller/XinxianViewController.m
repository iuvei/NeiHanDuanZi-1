//
//  XinxianViewController.m
//  同城+直播
//
//  Created by fuyuzheng on 2016/11/23.
//  Copyright © 2016年 fuyuzheng. All rights reserved.
//

#import "XinxianViewController.h"
#import "BottomTableViewCell.h"
#import "XinxianTableViewCell.h"
#import "AFNetworkingRequest.h"
#import "ReturnTableViewCellHeight.h"
#import "LoginViewController.h"
#import "submissionViewController.h"

#define footer @"footer"
#define xinxianTableViewCell @"XinxianTableViewCell"

@interface XinxianViewController ()<UITableViewDataSource,UITableViewDelegate>
/*tableView*/
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger pageNum;//当前页码
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)NSMutableArray *source;

@end

@implementation XinxianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBarButtonItems];
    _pageNum=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self netRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(click:) name:@"zan" object:nil];
    
}

#pragma mark --左右两侧item--
- (void)setUpBarButtonItems {
    
    self.navigationItem.title = @"新鲜";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[[UIImage imageNamed:@"defaulthead"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"submission"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(submissionAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark --左右item响应事件--
- (void)loginAction:(UIBarButtonItem *)sender {
    
    NSLog(@"登录");
//    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
//    
}

- (void)submissionAction:(UIBarButtonItem *)sender {
    
    [self.navigationController pushViewController:[submissionViewController new] animated:YES];
}


#pragma --Mark--属性懒加载

-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    
    return _dataSource;
}
-(NSMutableArray*)source{

    if (!_source) {
        _source=[NSMutableArray array];
    }

    return  _source;
}




//tableView懒加载
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=RLColor(241, 241, 241);
        [_tableView registerNib:[UINib nibWithNibName:@"XinxianTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:xinxianTableViewCell];
        [_tableView registerNib:[UINib nibWithNibName:@"BottomTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:footer];
        UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        
        swipe.direction=UISwipeGestureRecognizerDirectionLeft;
        [_tableView addGestureRecognizer:swipe];
 
        
    }
    return _tableView;
}
//单次请求
-(void)netRequest{
    NSString *url=[NSString stringWithFormat:@"http://lf.snssdk.com/2/essay/zone/ugc/recent/v1/?iid=6313313255&os_version=10.1.1&os_api=18&app_name=joke_essay&idfa=CC0E83A4-4C1B-4C64-AA9D-63E8A5F533D9&live_sdk_version=130&vid=36DFF92C-5E71-4658-9C18-B89B337031AD&openudid=7ce3d51c6af82f342ca38bd8e926f4db77914b76&device_type=iPhone8,1&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34641821461&aid=7&app_name=joke_essay&min_create_time=0&tag=joke"];
   [AFNetworkingRequest getRequestWithUrl:url result:^(id result) {
       
       NSArray *array=result[@"data"];
       for (id obj in array) {
           [self.dataSource addObject:obj];
       }
       [self.source addObject:self.dataSource[0]];
       [self.source addObject:@98];//ww
       [self setHeight];
       [self.tableView reloadData];
   }];



}
//刷新请求
-(void)refreashRequest{
  NSString *url=[NSString stringWithFormat:@"http://lf.snssdk.com/2/essay/zone/ugc/recent/v1/?iid=6313313255&os_version=10.1.1&os_api=18&app_name=joke_essay&idfa=CC0E83A4-4C1B-4C64-AA9D-63E8A5F533D9&live_sdk_version=130&vid=36DFF92C-5E71-4658-9C18-B89B337031AD&openudid=7ce3d51c6af82f342ca38bd8e926f4db77914b76&device_type=iPhone8,1&version_code=5.7.1&ac=WIFI&screen_width=750&device_id=34641821461&aid=7&app_name=joke_essay"];
    [AFNetworkingRequest getRequestWithUrl:url result:^(id result) {
        NSArray *array=result[@"data"];
        for (id obj in array) {
            [self.dataSource addObject:obj];
        }
        if (self.dataSource.count!=0) {
            [self.source replaceObjectAtIndex:0 withObject:self.dataSource[0]];
        }
        [self setHeight];
        [self.tableView reloadData];
    }];
    
}


#pragma tableView代理协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.source.count;
    

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        if (self.dataSource.count!=0) {
            NSDictionary *dic=self.source[indexPath.row];

            XinxianTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:xinxianTableViewCell forIndexPath:indexPath];
            cell.dataDic=dic;
            return cell;
        }
        else{
            return nil;
        }
    }
    else{
        BottomTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:footer forIndexPath:indexPath];
        
        cell.backgroundColor=RLColor(241, 241, 241);
        return cell;
    }
    
   
    
    
    
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
         return self.cellHeight;
    }
    else{
        return 80;
    }
    

}


//滑动手势
-(void)swipeAction:(UISwipeGestureRecognizer*)swipe{
    //判断当前是否为最后一页
    if (_pageNum>self.dataSource.count-1) {
        _pageNum=1;
        [self.dataSource removeAllObjects];
        [self refreashRequest];
   
    }
    else{
        
        [self.source replaceObjectAtIndex:0 withObject:self.dataSource[_pageNum]];
        _pageNum++;
        [self setHeight];
        [self.tableView reloadData];

    }
}
-(void)setHeight{
    NSDictionary *dataDic=self.source[0];
    NSDictionary *group=dataDic[@"group"];
    NSInteger num=[group[@"media_type"] integerValue];
    
    CGFloat labelHeight=[ReturnTableViewCellHeight dealWithString:group[@"text"] fontSize:15.0];
    CGFloat imgheight;
    if (num==0) {
     
        imgheight=0;
       
    }
    else if(num==1){
        NSDictionary *large_image=group[@"large_image"];
        
        CGFloat h=[large_image[@"height"] floatValue];
        if (h>=700) {
            
                imgheight=700;
            
            
        }
        else{
            imgheight=[large_image[@"height"] floatValue];
        
        }
        
       
    }
    else if (num==2){
        NSDictionary *gifvideo=group[@"gifvideo"];
        NSDictionary *p_video=gifvideo[@"360p_video"];
        
        CGFloat h=[p_video[@"height"] floatValue];
        if (h>=700) {
           
                imgheight=700;
           
            
        }
        else{
           imgheight=[p_video[@"height"] floatValue];
        }
        
    }

   _cellHeight=labelHeight+imgheight+16+17;

}

//通知回调
-(void)click:(NSNotification*)noti{
    [self swipeAction:nil];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];


}
@end
