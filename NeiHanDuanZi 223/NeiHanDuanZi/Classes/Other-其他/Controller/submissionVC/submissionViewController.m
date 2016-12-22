//
//  submissionViewController.m
//  NeiHanDuanZi
//
//  Created by 清邹 on 2016/11/19.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "submissionViewController.h"
#import "HomeViewController.h"
#import "XinxianViewController.h"
#import "SelectPhotoAndVideoView.h"

@interface submissionViewController ()<UITextViewDelegate>

@property (nonatomic,strong)SelectPhotoAndVideoView *selectView;

@end

@implementation submissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification  object:nil];
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpBarButtonItems];
    [self setupTextField];
    
}

#pragma mark --通知回调--
//- (void)showKeyBoard:(NSNotification *)sender {
//    
//    NSValue *value = [sender.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGRect rect = [value CGRectValue];
////    NSLog(@"%f",rect.size.height);
//    CGFloat height = rect.size.height;
//}

#pragma mark --左右两侧item--
- (void)setUpBarButtonItems {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[[UIImage imageNamed:@"leftBackButtonFGNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(submission:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark --响应事件--
- (void)backAction:(UIBarButtonItem *)sender {
    
    NSArray *vcArray = self.navigationController.viewControllers;
    for (id obj in vcArray) {
        
        if ([obj class] == [HomeViewController class]) {
            
            HomeViewController *homeVC = obj;
            [self.navigationController popToViewController:homeVC animated:YES];
            homeVC.seg.hidden = NO;
            self.tabBarController.tabBar.hidden = NO;
        }
        else if ([obj class] == [XinxianViewController class]) {
            
            XinxianViewController *xinxianVC = obj;
            [self.navigationController popToViewController:xinxianVC animated:YES];
            self.tabBarController.tabBar.hidden = NO;
        }
    }
}

- (void)submission:(UIBarButtonItem *)sender {
    
    NSLog(@"发表");
}

#pragma mark --setupTextField--
- (void)setupTextField {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 20)];
    label.text = @"投稿至";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(60, 10, 60, 20);
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = RLCommonBgColor.CGColor;
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button setTitle:@"点击选吧" forState:UIControlStateNormal];
    [button setTitleColor:RLCommonBgColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, ScreenWidth-20, 100)];
    textView.text = @"您的粉丝第一时间会看见您的投稿，请严肃对待哦！我们的目标是：专注内涵，拒绝黄反！可以矫情，不要煽情！敬告：发布色情敏感内容会被封号处理。";
    textView.textColor = [UIColor grayColor];
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    [self.view addSubview:textView];

    _selectView = [[[NSBundle mainBundle] loadNibNamed:@"SelectPhotoAndVideoView" owner:nil options:nil] lastObject];
    _selectView.frame = CGRectMake(0, ScreenHeight-80, ScreenWidth, 80);
    [self.view addSubview:_selectView];
    
}

- (void)selectAction:(UIButton *)sender {
    
    NSLog(@"点击选吧");
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    
    textView.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectView.frame = CGRectMake(0, ScreenHeight-258-80-20, ScreenWidth, 80);
    }];
    return YES;
}


@end
