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
#import "ZCItemPageScrllview.h"

#define UISCREEN ([UIScreen mainScreen].bounds)

@interface CHMainViewController ()<CoreStatusProtocol,CHClassificationBarDelegate,UIScrollViewDelegate>
{
    CHClassificationBar *_bar;
    
    ZCItemPageScrllview *_itemPageScrollView;
}

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) CGFloat startContentOffsetX;

@property (nonatomic, assign) BOOL isLeftOrRight;

@end


@implementation CHMainViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置item
    [self classificationBar];
    //创建滚动的视图
    [self cratItemPageScrollView];
    
    //请求数据
    [self requestData];
 
}
- (void)requestData{
    
    ClassifiedSectionModel * classFied = [[ClassifiedSectionModel alloc] init];
   
    if ([CoreStatus currentNetWorkStatus] == CoreNetWorkStatusNone) {//如果没有网络就取缓存中的数据
        
        //先取得缓存的数据
        [classFied classifiedSectionCachData:^(NSArray *array) {
            
            self.array = array;
            
        }];
        
        [_bar cratClassifiedItme:self.array];
        
        [self setTheScrollViewScrollRange];//在没有网络下的设置滚动范围
        
    }else{
        //请求网络数据
        [classFied classifiedSectionData:^(NSArray *array) {
            
            self.array =array;
            
            [_bar cratClassifiedItme:self.array];
            
            [self setTheScrollViewScrollRange];//设置滚动范围
            
        }];
        
    }
    
}

- (void)setTheScrollViewScrollRange{
    
    _itemPageScrollView.contentSize = CGSizeMake(self.array.count * UISCREEN.size.width, UISCREEN.size.height - 64);
    
}
- (void)cratItemPageScrollView{
    
    _itemPageScrollView = [[ZCItemPageScrllview alloc] initWithFrame:CGRectMake(0, 64, UISCREEN.size.width, UISCREEN.size.height - 64)];
    
    _itemPageScrollView.pagingEnabled = YES;
    _itemPageScrollView.delegate = self;
    [self.view addSubview:_itemPageScrollView];
    
}
- (void)classificationBar{
    
    _bar = [[CHClassificationBar alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 30)];
    
    _bar.delegate = self;
    
    [self.navigationController.navigationBar addSubview:_bar];
    
}
/**
 *  点击item显示对应的页面
 *
 *  @param indexItem 点击的第几个item
 *  @param url       对应页面的的链接地址
 */
- (void)clickOnIndexItem:(NSInteger)indexItem andWhichIndexItemUrl:(NSString *)url{
    
    [_itemPageScrollView setContentOffset:CGPointMake((indexItem - 1) * UISCREEN.size.width, 0) animated:YES];
}

#pragma mark --UIScrollViewDelegate
/**
 *   滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
     NSLog(@"--------%d",(int)(scrollView.contentOffset.x/UISCREEN.size.width));
    
    if (scrollView.contentOffset.x > self.startContentOffsetX) {
        
        self.isLeftOrRight = YES;
    }else{
        self.isLeftOrRight = NO;
    }
    
    
    [_bar currentPageItemBecomeselected:(int)(scrollView.contentOffset.x/UISCREEN.size.width) + 1];
    [_bar letTheScrollViewTheItemIsAlsoRolling:(int)(scrollView.contentOffset.x/UISCREEN.size.width) + 1 andIsLeftOrRigthBool:self.isLeftOrRight];
    
   
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{    //拖动前的起始坐标
    
      self.startContentOffsetX = scrollView.contentOffset.x;
    
}

@end
