//
//  ClassifiedSectionModel.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "ClassifiedSectionModel.h"

#import "CHServerManager.h"
#import "ZCNewsRequest.h"
#import "ZCNewDataCache.h"
#import "ZCNewClassifiedDataSourceModel.h"
static ClassifiedSectionModel *model = nil;
@implementation ClassifiedSectionModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
+ (ClassifiedSectionModel *)shareSingleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (model == nil) {
            model = [[ClassifiedSectionModel alloc] init];
        }
    });
    return model;
}

- (void)classifiedSectionData:(void(^)(NSArray *))dataArray{
    
    [ZCNewsRequest getRequestWithUrl:CH_Server(@"/entries?app=assistant") parameters:nil finishBlock:^(NSData *data, NSHTTPURLResponse *httpResponseCode) {
        
      [[ZCNewDataCache shareSingleton] cacheData:data];
        
        [self analyticalData:data];
        dataArray(self.dataArray);
        
    } failedErrorBlock:^(NSHTTPURLResponse *httpResponseCode, NSError *error) {
        
        
        
    }];
  
}
- (void)analyticalData:(NSData *)data{
    
    [self.dataArray removeAllObjects];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *array = dic[@"entries"];
    
    for (NSDictionary *cid in array) {
        
        ZCNewClassifiedDataSourceModel *model = [ZCNewClassifiedDataSourceModel classifiedSection:cid];
        [self.dataArray addObject:model];
        
    }
    
    
}

- (void)classifiedSectionCachData:(void(^)(NSArray *array))dataArray{
    
    ZCNewDataCache *dataCache = [ZCNewDataCache shareSingleton];
    
    if ([dataCache judgeCachePathTheData:CH_Server(@"/entries?app=assistant")]) {
    
         [self analyticalData:[dataCache getTheCachedData]];
    
          dataArray(self.dataArray);
    }
    
}
@end
