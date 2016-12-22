//
//  ZQTabBarController.m
//  NeiHanDuanZi
//
//  Created by fuyuzheng on 2016/11/19.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "ZQTabBarController.h"
#import "HomeViewController.h"
#import "ZQNavigationViewController.h"
#import "XiaoXiViewController.h"
#import "XinxianViewController.h"
#import "DiscoverViewController.h"
#import "MoreImgView.h"
#import <UIImageView+WebCache.h>

@interface ZQTabBarController ()<MoreImgViewDelegate>



@end

@implementation ZQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViewController];
    [self.tabBar setTintColor:[UIColor brownColor]];
    
    MoreImgView *moreImgView = [MoreImgView new];
    moreImgView.delegate = self;
    
}

//建立Controller
- (void)setUpViewController {
    
    [self setUpOneViewController:[[ZQNavigationViewController alloc] initWithRootViewController:[HomeViewController new]] title:@"首页" image:@"home" selectedImage:@"home_door_press"];
//    [self setUpOneViewController:[[ZQNavigationViewController alloc] initWithRootViewController:[FoundViewController new]] title:@"发现" image:@"Found" selectedImage:@"Found_press"];
    [self setUpOneViewController:[[ZQNavigationViewController alloc] initWithRootViewController:[DiscoverViewController new]] title:@"发现" image:@"Found" selectedImage:@"Found_press"];
    
    [self setUpOneViewController:[[ZQNavigationViewController alloc] initWithRootViewController:[XinxianViewController new]] title:@"新鲜" image:@"freshnew" selectedImage:@"freshnew_press"];
    
    [self setUpOneViewController:[[ZQNavigationViewController alloc] initWithRootViewController:[XiaoXiViewController new]] title:@"消息" image:@"newstab" selectedImage:@"newstab_press"];
}

- (void)setUpOneViewController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:viewController];
}

#pragma mark --MoreImgViewDelegate--
-(void)showLargeImg:(NSInteger)tagIndex mArray:(NSMutableArray *)mArray{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2, 20, 40, 20)];
    label.text = [NSString stringWithFormat:@"%ld/%ld",tagIndex,mArray.count];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:label];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bottomScrollView.contentSize = CGSizeMake(mArray.count * ScreenWidth, 0);
    bottomScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomScrollView];
    
    for (int i = 0; i < mArray.count; i++) {
        
        CGFloat imgHeight = [[mArray[i] objectForKey:@"height"] doubleValue];
        if (imgHeight > ScreenHeight) {
            
            UIScrollView *smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight)];
            [bottomScrollView addSubview:smallScrollView];
            smallScrollView.contentSize = CGSizeMake(0, imgHeight);
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, imgHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[mArray[i] objectForKey:@"url"]]];
            [smallScrollView addSubview:imgView];
            
        }
        else {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-imgHeight)/2, ScreenWidth, imgHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[mArray[i] objectForKey:@"url"]]];
            [bottomScrollView addSubview:imgView];
        }
    }
}

@end






















































