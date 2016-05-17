//
//  CHServerPathManager.m
//  ZCGamesNews
//
//  Created by Summer on 16/1/29.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import "CHServerManager.h"


static NSString * const serverDevelopmentURL  = @"http://192.168.1.15:9311";


static NSString * const serverDistributionURL = @"http://news.zcgames.cn";// http://news.zcgames.cn/    // @"http://113.31.129.10:9311"


@implementation CHServerManager

#pragma mark - - 单利
+ (instancetype)shareManager
{
    static CHServerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CHServerManager alloc] init];
    });
    return manager;
}

#pragma mark - - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setServerType:CHServerDevelopment];
        
    }
    return self;
}

#pragma mark - - 设置服务器地址
- (void)setServerType:(CHServer)serverType
{
    _serverType = serverType;
    
    switch (serverType) {
        case CHServerDevelopment:
            _serverURL = serverDevelopmentURL;
            break;
        case CHServerDistribution:
            _serverURL = serverDistributionURL;
            break;
    }
}

@end
