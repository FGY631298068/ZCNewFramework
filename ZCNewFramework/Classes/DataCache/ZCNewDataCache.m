//
//  ZCNewDataCache.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "ZCNewDataCache.h"
#import "CHServerManager.h"
static ZCNewDataCache *cach = nil;
@interface ZCNewDataCache ()

@property (nonatomic, copy)NSString *path;

@property (nonatomic, copy)NSString *cachPath;
@end

@implementation ZCNewDataCache

+ (ZCNewDataCache *)shareSingleton{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (cach == nil) {
            cach = [[ZCNewDataCache alloc] init];
        }
    });
    return cach;
}

- (BOOL)judgeCachePathTheData:(NSString *)path{
    
    self.path = path;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[self createTheCorrespondingFolder:self.path] withIntermediateDirectories:YES attributes:nil error:nil];
    //获取文件的路径
   self.cachPath = [self accessToTheTargetDataFolder:[self createTheCorrespondingFolder:self.path]];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:self.cachPath];
}

- (NSString *)createTheCorrespondingFolder:(NSString *)pathUrl{
    
    return [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/default/%@", [pathUrl stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",CH_Server_Main]  withString:@"ZCGameStrategy"]];
}

- (NSString *)accessToTheTargetDataFolder:(NSString *)pathurl{
    
    return [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/default/%@/%@", [self.path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",CH_Server_Main]  withString:@"ZCGameStrategy"],[pathurl lastPathComponent]];
    
}

- (void)cacheData:(NSData *)dataSource{
    
    [dataSource writeToFile:self.cachPath atomically:YES];
}

- (NSData *)getTheCachedData{
    
    return [NSData dataWithContentsOfFile:self.cachPath];
}
@end
