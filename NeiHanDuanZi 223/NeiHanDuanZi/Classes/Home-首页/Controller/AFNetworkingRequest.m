//
//  AFNetworkingRequest.m
//  AFNetworking
//
//  Created by fuyuzheng on 2016/10/18.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "AFNetworkingRequest.h"
#import <AFNetworking.h>

@implementation AFNetworkingRequest

//检测网络连接状态
+ (void)reach:(dataBlock)block {
    
    /*
     AFNetworkReachabilityStatusUnknown          = -1,未知
     AFNetworkReachabilityStatusNotReachable     = 0,无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,流量
     AFNetworkReachabilityStatusReachableViaWiFi = 2,wifi
     */
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"%ld",(long)status);
        block(@(status));
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
    
+ (void)getRequestWithUrl:(NSString *)urlString result:(dataBlock)block {
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //absoluteString 完整的 url字符串
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject = %@",responseObject);
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.debugDescription);
    }];
}
    
+ (void)postRequestWithUrl:(NSString *)urlString withParameters:(NSDictionary *)dictionary result:(dataBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:urlString parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.debugDescription);
    }];

}
    
    
    
@end
