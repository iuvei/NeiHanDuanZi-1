//
//  AFNetworkingRequest.h
//  AFNetworking
//
//  Created by fuyuzheng on 2016/10/18.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^dataBlock)(id result);



@interface AFNetworkingRequest : NSObject

+ (void)getRequestWithUrl:(NSString *)urlString result:(dataBlock)block;
    
+ (void)postRequestWithUrl:(NSString *)urlString withParameters:(NSDictionary *)dictionary result:(dataBlock)block;

//检测网络连接状态
+ (void)reach:(dataBlock)block;
    
    
    
@end
