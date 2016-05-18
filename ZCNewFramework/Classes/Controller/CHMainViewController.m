//
//  CHMainViewController.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "CHMainViewController.h"
#import "ClassifiedSectionModel.h"
#import "CHClassificationBar.h"
#import "CoreStatus.h"
@interface CHMainViewController ()<CoreStatusProtocol,CHClassificationBarDelegate>
{
    CHClassificationBar *_bar;
}

@property (nonatomic, strong) NSArray *array;

@end


@implementation CHMainViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置item
    [self classificationBar];
    
    //请求数据
    [self requestData];
 
}
- (void)requestData{
    
    ClassifiedSectionModel * classFied = [[ClassifiedSectionModel alloc] init];
    //先取得缓存的数据
    [classFied classifiedSectionCachData:^(NSArray *array) {
        
        self.array = array;
        
    }];
    
    if ([CoreStatus currentNetWorkStatus] == CoreNetWorkStatusNone) {//如果没有网络就取缓存中的数据
        
        [_bar cratClassifiedItme:self.array];
        
    }else{
        //请求网络数据
        [classFied classifiedSectionData:^(NSArray *array) {
            
            self.array =array;
            
            [_bar cratClassifiedItme:self.array];
            
        }];
        
    }
    
}

- (void)classificationBar{
    
    _bar = [[CHClassificationBar alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 30)];
    
    _bar.delegate = self;
    
    [self.navigationController.navigationBar addSubview:_bar];
}

- (void)clickOnIndexItem:(NSInteger)indexItem andWhichIndexItemUrl:(NSString *)url{
    
}
@end
