//
//  HomeViewController.m
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "HomeViewController.h"
#import "GuanZhuViewController.h"
#import "SelectionViewController.h"
#import "LoginViewController.h"
#import "submissionViewController.h"
#import "DetailViewController.h"
#import "ShareBtn.h"

@interface HomeViewController ()

@property (nonatomic,strong)GuanZhuViewController *guanZhuVC;
@property (nonatomic,strong)SelectionViewController *selectVC;

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic, assign) BOOL is_selected_0;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationController.navigationBar.shadowImage = nil;
//    self.navigationController.navigationBar.back
//    [self.navigationController.navigationBar setBarTintColor:[UIColor brownColor]];
    _dataArray = [NSMutableArray array];
    NSArray *array1 = @[@"login_weixin",@"xinlangweibo_popover",@"login_qq",@"login_weibo",@"login_renrern",@"login_kaixin"];
    NSArray *array2 = @[@"微信",@"新浪微博",@"QQ",@"腾讯微博",@"人人网",@"开心网"];
    [_dataArray addObject:array2];
    [_dataArray addObject:array1];
    
    [self setUpSegmentControl];
    //精选VC
    _selectVC = [SelectionViewController new];
    _selectVC.vc = self;
    //关注VC
    _guanZhuVC = [GuanZhuViewController new];
    
    [self addChildViewController:_guanZhuVC];
    [self.view addSubview:_guanZhuVC.view];
    
    [self addChildViewController:_selectVC];
    [self.view addSubview:_selectVC.view];
    
    [self setupRefreshBtn];
    
    [self setUpBarButtonItems];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShareView:) name:@"showShareView" object:nil];
    
}

#pragma mark --refresh button--
- (void)setupRefreshBtn {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth-40-10, ScreenHeight-49-40-10, 40, 40);
    [button setImage:[[UIImage imageNamed:@"html_refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    
    [self.view addSubview:button];
}

#pragma mark --通知回调--
- (void)showShareView:(NSNotification *)sender {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBgView:)];
    [_bgView addGestureRecognizer:tap];
    
    [self.tabBarController.view addSubview:_bgView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-250)];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-60)/2, 15, 60, 21)];
    label.text = @"分享到";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [_contentView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, _contentView.frame.size.height-80, ScreenWidth, 80);
    
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
    
    CGFloat space = (ScreenWidth-60*4)/5;
    CGFloat btn_width = 60;
    CGFloat btn_height = btn_width;
    NSArray *array1 = _dataArray[0];
    NSArray *array2 = _dataArray[1];
    int count = 0;
    for (int i = 0; i < 2; i++) {
        
        for (int j = 0; j < 4; j++) {
            ShareBtn *shareBtn = [[[NSBundle mainBundle] loadNibNamed:@"ShareBtn" owner:nil options:nil] lastObject];
            shareBtn.frame = CGRectMake(space*(j+1) + btn_width*j, 20 + i * btn_height + space*(i+1), btn_width, btn_height);
            shareBtn.nameLabel.text = array1[count];
            shareBtn.imgView.image = [UIImage imageNamed:array2[count]];
            [_contentView addSubview:shareBtn];
            count++;
            if (count > 5) {
                break;
            }
        }
    }    
    [self.tabBarController.view addSubview:_contentView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _contentView.frame = CGRectMake(0, 250, ScreenWidth, ScreenHeight-250);
    }];

}

#pragma mark --tap手势--
- (void)hideBgView:(UITapGestureRecognizer *)sender  {
    
    [_bgView removeFromSuperview];
    [_contentView removeFromSuperview];
    
}

- (void)cancel:(UIButton *)sender {
    
    [_bgView removeFromSuperview];
    [_contentView removeFromSuperview];
}

#pragma mark --顶部选择栏--
- (void)setUpSegmentControl {
    
    NSArray *array = @[@"精选",@"关注"];
    _seg = [[UISegmentedControl alloc] initWithItems:array];

    _seg.tintColor = [UIColor brownColor];
    _seg.frame = CGRectMake((ScreenWidth-125)/2, 7, 125, 30);
    _seg.selectedSegmentIndex = 0;

    [_seg setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_seg];
    
    [_seg addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark --选择事件--
- (void)selectedAction:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    
    switch (index) {
        case 0:{

            _guanZhuVC.view.hidden = YES;
            _selectVC.view.hidden = NO;
        }
            break;
        case 1:{

            _selectVC.view.hidden = YES;
            _guanZhuVC.view.hidden = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark --左右两侧item--
- (void)setUpBarButtonItems {
    
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
    
//    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    
    self.seg.hidden = YES;
    
}

- (void)submissionAction:(UIBarButtonItem *)sender {

    [self.navigationController pushViewController:[submissionViewController new] animated:YES];
    self.seg.hidden = YES;
    
}



@end













































