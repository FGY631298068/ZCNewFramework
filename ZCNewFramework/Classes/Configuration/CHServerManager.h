//
//  CHServerPathManager.h
//  ZCGamesNews
//
//  Created by Summer on 16/1/29.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 获取主分类信息 */
#define CH_Server_Main [CHServerManager shareManager].serverURL

/** 拼接服务器地址和路径 */
#define CH_Server(path) [NSString stringWithFormat:@"%@%@",[CHServerManager shareManager].serverURL, (path)]

typedef enum {
    CHServerDevelopment  = 1, // 开发服务器
    CHServerDistribution = 2, // 生产服务器
}CHServer;

@interface CHServerManager : NSObject

/** 管理器单利 */
+ (instancetype)shareManager;

/** 服务器类型 */
@property (nonatomic, assign) CHServer serverType;

/** 服务器地址 */
@property (nonatomic, copy, readonly) NSString *serverURL;


@end
