//
//  ClassifiedSectionModel.h
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifiedSectionModel : NSObject


@property (nonatomic, strong)NSMutableArray *dataArray;//返回的dataSource

+ (ClassifiedSectionModel *)shareSingleton;

- (void)classifiedSectionData:(void(^)(NSArray *array))dataArray;//请求新的数据

- (void)classifiedSectionCachData:(void(^)(NSArray *array))dataArray;



@end
