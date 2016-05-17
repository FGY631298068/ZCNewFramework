//
//  ZCNewsRequest.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "ZCNewsRequest.h"
#import "AFNetworking.h"
@implementation ZCNewsRequest

+ (void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finishBlock:(void(^)(NSData *data, NSHTTPURLResponse *httpResponseCode))finishBlock failedErrorBlock:(void(^)( NSHTTPURLResponse *httpResponseCode,NSError * error))errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        finishBlock(responseObject,(NSHTTPURLResponse *)task.response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        errorBlock((NSHTTPURLResponse *)task.response, error);
        
    }];

}

+ (void)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finishBlock:(void (^)(NSData *, NSHTTPURLResponse *))finishBlock failedErrorBlock:(void (^)(NSError *))errorBlock{
    
}
@end
