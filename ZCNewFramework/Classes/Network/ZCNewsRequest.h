//
//  ZCNewsRequest.h
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCNewsRequest : NSObject

+ (void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finishBlock:(void(^)(NSData *data, NSHTTPURLResponse *httpResponseCode))finishBlock failedErrorBlock:(void(^)(NSHTTPURLResponse *httpResponseCode ,NSError * error))errorBlock;


+ (void)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finishBlock:(void(^)(NSData *data, NSHTTPURLResponse *httpResponseCode))finishBlock failedErrorBlock:(void(^)(NSError * error))errorBlock;

@end
