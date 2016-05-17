//
//  CHMainViewController.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "CHMainViewController.h"
#import "ClassifiedSectionModel.h"
@interface CHMainViewController ()

@property (nonatomic, strong) NSArray *array;
@end


@implementation CHMainViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
   ClassifiedSectionModel * classFied = [[ClassifiedSectionModel alloc] init];
 
    [classFied classifiedSectionCachData:^(NSArray *array) {
        
        self.array = array;
        
    }];
    
    
     [classFied classifiedSectionData:^(NSArray *array) {
         
         self.array =array;
         
     }];
 
    UIButton *bu7tto = [UIButton buttonWithType:UIButtonTypeCustom];
    bu7tto.center = self.view.center;
    bu7tto.bounds = CGRectMake(0, 0, 100, 25);
    
    [bu7tto setTitle:@"下一页" forState:UIControlStateNormal];
    bu7tto.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bu7tto];
    
}
@end
