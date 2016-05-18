//
//  ZCNewClassifiedDataSourceModel.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "ZCNewClassifiedDataSourceModel.h"

@implementation ZCNewClassifiedDataSourceModel
+ (instancetype)classifiedSection:(NSDictionary *)dic{
    
    return [[self alloc] initWithClassifiedSection:dic];
}
- (instancetype)initWithClassifiedSection:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.name_en = dic[@"name_en"];
        self.name_zh = dic[@"name_zh"];
        self.app     = dic[@"app"];
        self.path    = dic[@"path"];
        self.rank    = [dic[@"rank"] integerValue];
        self.refresh = dic[@"refresh"];
        self.more    = dic[@"more"];
        
    }
    
    return self;
}
@end
