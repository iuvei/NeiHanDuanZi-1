//
//  DetailViewController.m
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/22.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "TuiJianNormalTableViewCell.h"
#import "ReturnTableViewCellHeight.h"
#import "AFNetworkingRequest.h"
#import "CommentTableViewCell.h"
#import "CommentHeaderView.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *hotCommentDataSource;
@property (nonatomic,strong)NSMutableArray *recentCommentDataSource;

@property (nonatomic,strong)NSDictionary *dataDic;

@property (nonatomic,strong)UIView *bottomView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    _hotCommentDataSource = [NSMutableArray array];
    _recentCommentDataSource = [NSMutableArray array];
    _dataDic = [NSDictionary dictionary];
   
    [self setupNavigationBar];
    
    [self beginNetworkRequest];
    
    [self setupBottomView];
    
    
    
}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor brownColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"leftBackButtonFGNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(jubaoAction:)];
}

- (void)backAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.bottomView removeFromSuperview];
    
    NSArray *vcArray = self.navigationController.viewControllers;
    NSMutableArray *mArray = [NSMutableArray array];
    for (id obj in vcArray) {
        
        if ([obj class] == [HomeViewController class]) {
            [mArray addObject:obj];
        }
    }
    HomeViewController *homeVC = mArray[0];
    homeVC.seg.hidden = NO;
    
}

- (void)jubaoAction:(UIBarButtonItem *)sender {
    
    NSLog(@"举报");
}

- (void)setupBottomView {
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar addSubview:_bottomView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 9.5, ScreenWidth-20, 30);
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setTitle:@"期待你的神评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, -200, 0, 0);
    
    [button addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:button];
    
}

- (void)commentAction:(UIButton *)sender {
    
    NSLog(@"评论");
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CommentHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"CommentHeaderIdentifier"];
        
    }
    return _tableView;
}

#pragma mark --UITableViewDataSource--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }
    else if (section == 1){
        
        return self.hotCommentDataSource.count;
    }
    else {
        
        return self.recentCommentDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //防止单元格重用
        static NSString *identifier = @"TuiJianIdentifier";
        TuiJianNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuiJianNormalTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModelDic = self.groupDic;
        cell.shenPingHeight.constant = 0;
        [cell.shenPingBGView removeFromSuperview];
        cell.disLikeBtn.hidden = YES;
        
        return cell;
    }
    else {
        
        static NSString *identifier = @"CommentCellIdentifier";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] lastObject];
        }
        
        if (indexPath.section == 1) {
            
            cell.hotCommentDic = self.hotCommentDataSource[indexPath.row];
            if (self.hotCommentDataSource.count == 0) {
                
                
            }
        }
        else {
            
            cell.hotCommentDic= self.recentCommentDataSource[indexPath.row];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark --UITableViewDelegate--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self setCellHeight];
    }
    else if (indexPath.section == 1){
        NSString *commentStr = [self.hotCommentDataSource[indexPath.row] objectForKey:@"text"];
        return [ReturnTableViewCellHeight dealWithString:commentStr fontSize:14] + 90;
    }
    else {
        NSString *commentStr = [self.recentCommentDataSource[indexPath.row] objectForKey:@"text"];
        return [ReturnTableViewCellHeight dealWithString:commentStr fontSize:14] + 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 1;
    }
    else {
        return 10;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    else {
       return 30;
    }
    
}

#pragma mark --tableView HeaderView--
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc] init];
        
        return view;
    }
    else {
        
        CommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommentHeaderIdentifier"];
        header.contentView.backgroundColor = [UIColor whiteColor];
        
        if (section == 1) {
            
            
            header.commentTypeLabel.text = [NSString stringWithFormat:@"热门评论(%ld)",self.hotCommentDataSource.count];
        }
        else {
            
            
            header.commentTypeLabel.text = [NSString stringWithFormat:@"新鲜评论(%ld)",self.recentCommentDataSource.count];
        }
        
        return header;
    }
    
}



//处理cell高度
-(CGFloat)setCellHeight{
    
    static CGFloat h=192+50;
    NSDictionary *group=[self.groupDic objectForKey:@"group"];
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
            if (imgHeight > 600) {
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
            
//            NSLog(@"media_type = %@",group[@"media_type"]);
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
    
    CGFloat wholeHeight=topLabelHeight+h+videoHeight-40;
    
    return wholeHeight;
}

#pragma mark --网络请求--
- (void)beginNetworkRequest {
    
    [AFNetworkingRequest getRequestWithUrl:self.commentStr result:^(id result) {
       
        NSDictionary *dataDic = result[@"data"];
        _recentCommentDataSource = dataDic[@"recent_comments"];
        _hotCommentDataSource = dataDic[@"top_comments"];
        
        [self.tableView reloadData];
    }];
    
    
    
}

@end








































