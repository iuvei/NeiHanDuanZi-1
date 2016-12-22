//
//  AFNetworkingRequest+ProcessHTMLData.h
//  PlayWhatToday
//
//  Created by fuyuzheng on 2016/11/4.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "AFNetworkingRequest.h"

@interface AFNetworkingRequest (ProcessHTMLData)

+ (void)processHTMLWithUrl:(NSString *)urlString result:(dataBlock)block;
+ (void)processPlainWithUrl:(NSString *)urlString result:(dataBlock)block;

@end
