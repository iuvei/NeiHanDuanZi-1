//
//  AFNetworkingRequest+ProcessHTMLData.m
//  PlayWhatToday
//
//  Created by fuyuzheng on 2016/11/4.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "AFNetworkingRequest+ProcessHTMLData.h"
#import <AFNetworking.h>

@implementation AFNetworkingRequest (ProcessHTMLData)

+ (void)processHTMLWithUrl:(NSString *)urlString result:(dataBlock)block {
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //absoluteString 完整的 url字符串
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.debugDescription);
    }];
}

+ (void)processPlainWithUrl:(NSString *)urlString result:(dataBlock)block {
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //absoluteString 完整的 url字符串
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.debugDescription);
    }];
}


@end
