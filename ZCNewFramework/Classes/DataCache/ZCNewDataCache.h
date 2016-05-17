//
//  ZCNewDataCache.h
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCNewDataCache : NSObject

+ (ZCNewDataCache *)shareSingleton;

- (BOOL)judgeCachePathTheData:(NSString *)path;//判断对应路径下的缓存

- (void)cacheData:(NSData *)dataSource;//储存数据

- (NSData *)getTheCachedData;//获得缓存的数据

@end
