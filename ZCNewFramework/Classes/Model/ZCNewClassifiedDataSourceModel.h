//
//  ZCNewClassifiedDataSourceModel.h
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCNewClassifiedDataSourceModel : NSObject

@property (nonatomic, copy) NSString *name_en;
@property (nonatomic, copy) NSString *name_zc;
@property (nonatomic, copy) NSString *app;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *refresh;
@property (nonatomic, copy) NSString *more;

+ (instancetype)classifiedSection:(NSDictionary *)dic;
- (instancetype)initWithClassifiedSection:(NSDictionary *)dic;
@end
