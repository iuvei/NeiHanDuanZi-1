//
//  ZQNavigationViewController.m
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/19.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "ZQNavigationViewController.h"

@interface ZQNavigationViewController ()

@end

@implementation ZQNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:220/255.0 green:217/255.0 blue:207/255.0 alpha:1.0]];
    [self.navigationBar setTintColor:[UIColor brownColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor]}];
    
}

@end
