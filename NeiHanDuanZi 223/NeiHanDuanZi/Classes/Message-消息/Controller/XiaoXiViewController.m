//
//  XiaoXiViewController.m
//  测试
//
//  Created by fuyuzheng on 2016/11/17.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import "XiaoXiViewController.h"
#import "XiaoXiTableViewCell.h"
#import "XiaoXiImageTableViewCell.h"
#import "DengLuViewController.h"
#import "LoginViewController.h"

#define XiaoXiTableViewCellIdentifier @"XiaoXiTableViewCellIdentifier"
#define XiaoXiImageTableViewCellIdentifier @"XiaoXiImageTableViewCellIdentifier"

@interface XiaoXiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation XiaoXiViewController
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RLColor(241, 241, 241);
        [_tableView registerNib:[UINib nibWithNibName:@"XiaoXiTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:XiaoXiTableViewCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:@"XiaoXiImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:XiaoXiImageTableViewCellIdentifier];
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setUpBarButtonItems];
}

-(void)initData{
    _dataSource = [NSMutableArray array];
    
    NSArray *NameArray = @[@"投稿互动",@"系统消息",@"粉丝关注"];
    NSArray *imageArray = @[@"interaction",@"systemmessage",@"vermicelli"];
    
    [_dataSource addObjectsFromArray:imageArray];
    [_dataSource addObjectsFromArray:NameArray];
}

#pragma mark --左右两侧item--
- (void)setUpBarButtonItems {
    
    self.navigationItem.title = @"消息";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[[UIImage imageNamed:@"defaulthead"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"黑名单" style:UIBarButtonItemStylePlain target:self action:@selector(submissionAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark --左右item响应事件--
- (void)loginAction:(UIBarButtonItem *)sender {
    
        NSLog(@"登录");
    
//    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

- (void)submissionAction:(UIBarButtonItem *)sender {
    
        NSLog(@"黑名单");
    
}


#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row < 3) {
        XiaoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XiaoXiTableViewCellIdentifier forIndexPath:indexPath];
        cell.XiaoXiTitleLabel.text = _dataSource[indexPath.row+3];
        cell.XiaoXiImageView.image = [UIImage imageNamed:_dataSource[indexPath.row]];
        return cell;
        
    }else{
        
        XiaoXiImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XiaoXiImageTableViewCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = RLColorA(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
    
    
}



#pragma mark  UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.transform = CGAffineTransformMakeTranslation(ScreenWidth/7, 0);
    [UIView animateWithDuration:indexPath.row*0.1+0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 220;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    if (indexPath.row == 3) {
        return;
    }
    DengLuViewController *DLVC = [[DengLuViewController alloc] init];
    [self.navigationController pushViewController:DLVC animated:YES];
    
    
    
    
}

- (void)deselect

{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

@end
