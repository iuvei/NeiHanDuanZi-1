//
//  SelectionFatherViewController.h
//  NeiHanDuanZi
//
//  Created by ibokan2 on 2016/11/21.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuiJianNormalTableViewCell.h"
#import "TuiJianGuanZhuTableViewCell.h"
#import "TuiJianNeiHanJingHuaTableViewCell.h"
#import "AFNetworkingRequest.h"
#import "AFNetworkingRequest+ProcessHTMLData.h"
#import "ReturnTableViewCellHeight.h"


@interface SelectionFatherViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)NSMutableArray *cellHeigthArray;

@property (nonatomic,strong)NSString *urlString;

@property (nonatomic,strong)ViewAnimation *animatingView;

@property (nonatomic,strong)UIView *view1;



- (void)beginNetworkRequest;

-(void)setCellHeight;

-(void)removeAdFromDataSource;

@end
