//
//  LoginViewController.m
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/28.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "DengLuViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)HomeViewController *homeVC;

@property (nonatomic,strong)UIView *view1;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    self.navigationController.navigationBar.alpha = 0;

    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    [self setupBarButtonItems];
    _dataArray = [NSMutableArray array];
    
    [self setupSegmentCtrol];
    
}


- (void)setupBarButtonItems {
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    _view1.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_view1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2, 5, 40, 30)];
    label.text = @"我的";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    [_view1 addSubview:label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 5, 40, 30);
    [button setImage:[[UIImage imageNamed:@"leftBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToHomeVC:) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(ScreenWidth-40, 5, 40, 30);
    [button1 setImage:[[UIImage imageNamed:@"Setup"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(ScreenWidth-40-40, 5, 40, 30);
    [button2 setImage:[[UIImage imageNamed:@"nightbutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeToNight:) forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:button2];
    
}

- (void)backToHomeVC:(UIButton *)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    NSArray *vcArray = self.navigationController.viewControllers;
//    NSMutableArray *mArray = [NSMutableArray array];
    for (id obj in vcArray) {
        
        if ([obj class] == [HomeViewController class]) {
            self.navigationController.navigationBar.alpha = 1;
            [self.navigationController popToViewController:obj animated:YES];
            [_view1 removeFromSuperview];
            HomeViewController *homeVC = obj;
            homeVC.seg.hidden = NO;
        }
//        else if ([obj class] == [DengLuViewController class]) {
//            
//            [self.navigationController popToViewController:obj animated:YES];
//            [_view1 removeFromSuperview];
//        }
    }
//    HomeViewController *homeVC = mArray[0];
//    homeVC.seg.hidden = NO;
    
    
    
    
    
}

- (void)changeToNight:(UIBarButtonItem *)sender {
    
    NSLog(@"change");
}

- (void)settingAction:(UIBarButtonItem *)sender {
    
    NSLog(@"setting");
}

- (void)setupSegmentCtrol {
    
    NSArray *array = @[@"投稿",@"收藏",@"评论"];
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * ScreenWidth/3, 0, ScreenWidth/3, 37);
        [button setTitle:array[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
            self.typeImageView.image = [UIImage imageNamed:@"relation"];
        }
        else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_dataArray addObject:button];
        [self.selectView addSubview:button];
    }
}

- (void)selectAction:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    
    
    switch (index) {
        case 100:
        {
            
            [sender setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
            [_dataArray[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_dataArray[2] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case 101:
        {
            
            [sender setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
            self.typeImageView.image = [UIImage imageNamed:@"nocollection"];
            [_dataArray[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_dataArray[2] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case 102:
        {
            
            [sender setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
            self.typeImageView.image = [UIImage imageNamed:@"relation"];
            [_dataArray[1] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_dataArray[0] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
//    _homeVC.seg.hidden = NO;
}

- (IBAction)loginAction:(UIButton *)sender {
    
    NSLog(@"登录");
//    [self.navigationController pushViewController:[DengLuViewController new] animated:YES];
//    NSArray *vcArray = self.navigationController.viewControllers;
//    NSMutableArray *mArray = [NSMutableArray array];
//    for (id obj in vcArray) {
//        
//        if ([obj class] == [HomeViewController class]) {
//            [mArray addObject:obj];
//        }
//    }
//    _homeVC = mArray[0];
//    _homeVC.seg.hidden = YES;

}


@end























