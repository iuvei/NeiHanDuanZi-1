//
//  DengLuViewController.m
//  测试
//
//  Created by fuyuzheng on 2016/11/18.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import "DengLuViewController.h"
#import "DengLuTableViewCell.h"

#define denglutableViewCellIdentifier @"denglutableViewCellIdentifier"

@interface DengLuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *mArray;

@end

@implementation DengLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *bbIt = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"leftBackButtonFGNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(bbItAction:)];
    
    self.navigationItem.leftBarButtonItem = bbIt;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    
    [tableView registerNib:[UINib nibWithNibName:@"DengLuTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:denglutableViewCellIdentifier];
    _mArray = [NSMutableArray array];
    NSArray *array1 = @[@"login_weixin",@"xinlangweibo_popover",@"login_qq",@"login_weibo",@"login_renrern",@"login_kaixin"];
    
    NSArray *array2 = @[@"微信",@"新浪微博",@"QQ",@"腾讯微博",@"人人网",@"开心网"];
    
    [_mArray addObject:array1];
    [_mArray addObject:array2];

}

#pragma mark UITableViewDataSource
//每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return 1;
    }else{
        return 6;
    }
}


//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DengLuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:denglutableViewCellIdentifier forIndexPath:indexPath];

    if (indexPath.section > 0) {
        NSArray *array1 = _mArray[0];
        NSArray *array2 = _mArray[1];
        cell.dengLuImageView.image = [UIImage imageNamed:array1[indexPath.row]];
        cell.dengLuLabel.text = array2[indexPath.row];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.transform = CGAffineTransformMakeTranslation(ScreenWidth/4, 0);
    [UIView animateWithDuration:indexPath.row*0.1+0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}


-(void)bbItAction:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
