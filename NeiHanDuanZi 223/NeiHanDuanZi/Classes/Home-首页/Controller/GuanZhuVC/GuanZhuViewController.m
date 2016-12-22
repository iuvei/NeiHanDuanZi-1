//
//  GuanZhuViewController.m
//  NeiHanDuanZi
//
//  Created by ibokan2 on 2016/11/28.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "GuanZhuViewController.h"
#import "DengLuViewController.h"
#import "HomeViewController.h"

@interface GuanZhuViewController ()

@property (nonatomic,strong)HomeViewController *homeVC;

@end

@implementation GuanZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _homeVC.seg.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (IBAction)loginAction:(UIButton *)sender {
    
    [self.navigationController pushViewController:[DengLuViewController new] animated:YES];
    NSArray *vcArray = self.navigationController.viewControllers;
    NSMutableArray *mArray = [NSMutableArray array];
    for (id obj in vcArray) {
        
        if ([obj class] == [HomeViewController class]) {
            [mArray addObject:obj];
        }
    }
    _homeVC = mArray[0];
    _homeVC.seg.hidden = YES;
    
    
}

@end
