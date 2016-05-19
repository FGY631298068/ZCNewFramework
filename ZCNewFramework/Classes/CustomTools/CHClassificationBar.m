//
//  CHClassificationBar.m
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import "CHClassificationBar.h"
#import "ZCNewClassifiedDataSourceModel.h"
#define UISCREEN ([UIScreen mainScreen].bounds)
@interface CHClassificationBar ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) UIButton *itemButton;

@end

@implementation CHClassificationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self cratUI];
        
    }
    return self;
}
- (void)cratUI{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.bounces = YES;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    
    [self addSubview:self.scrollView];
    
    
}
- (void)cratClassifiedItme:(NSArray *)itemArray{
    
    
    if (itemArray.count < 1) return;
    
    self.itemArray = itemArray;

    for (int i = 0; i < self.itemArray.count; i ++) {
        
        
        ZCNewClassifiedDataSourceModel *model = self.itemArray[i];
        
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _itemButton.frame = CGRectMake(10 +i *(80 + 10) , 0, 80, 30);
        
        [_itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _itemButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [_itemButton setTitle:model.name_zh forState:UIControlStateNormal];
        
        [_itemButton setBackgroundImage:[UIImage imageNamed:@"left_s"] forState:UIControlStateSelected];
        
        [_itemButton setBackgroundImage:[UIImage imageNamed:@"Login-image"] forState:UIControlStateNormal];
        
        _itemButton.tag = model.rank;
        
        [_itemButton addTarget:self action:@selector(clickIndexItme:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            
            _itemButton.selected = YES;
        }
        
        _itemButton.layer.cornerRadius = 15;
        
        _itemButton.layer.masksToBounds = YES;
        
        [self.scrollView addSubview:_itemButton];

    }

    if ((self.itemArray.count * (90) + 10) < [UIScreen mainScreen].bounds.size.width) {
     
        self.scrollView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.frame.size.height / 2);
        
        self.scrollView.bounds = CGRectMake(0, 0, self.itemArray.count * 90 + 10, self.frame.size.height);
        
    }

    self.scrollView.contentSize = CGSizeMake(self.itemArray.count * 90 + 10, self.frame.size.height);
    
}

- (void)clickIndexItme:(UIButton *)indexItem{
    
    //如果点击butt是选中状态，就直接接受
    if (indexItem.selected) return;
    
    [self changeTheStateOfItme];
    
    indexItem.selected = YES;
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickOnIndexItem:andWhichIndexItemUrl:)]) {
        
        ZCNewClassifiedDataSourceModel *model = self.itemArray[indexItem.tag -1];
        
        [self.delegate clickOnIndexItem:indexItem.tag andWhichIndexItemUrl:model.path];
    }
    
}

- (void)currentPageItemBecomeselected:(NSInteger)indexPage{
    
    [self changeTheStateOfItme];

    UIButton *buttong = (UIButton *)[self viewWithTag:indexPage];
    
    buttong.selected = YES;
    
}

//先把所有的itme的selecte = NO;
- (void)changeTheStateOfItme{
    
    for (ZCNewClassifiedDataSourceModel *model in self.itemArray) {
        
        UIButton *button = (UIButton *)[self viewWithTag:model.rank];
        
        button.selected = NO;
    }
}

- (void)letTheScrollViewTheItemIsAlsoRolling:(NSInteger)indexItem andIsLeftOrRigthBool:(BOOL)isLeftOrRight{
    
    NSLog(@"%f-----%f",_scrollView.contentSize.width,[UIScreen mainScreen].bounds.size.width);
    UIButton *button = (UIButton *)[self viewWithTag:indexItem];
    NSLog(@"%f======%f",button.frame.origin.x,_scrollView.contentOffset.x);
    
//    static int ITEM = 1;
//    if (ITEM <= 4) {
//        
//        ITEM ++;
//    }
//    if (isLeftOrRight) {
//        
//        if (ITEM== 4) {
//            
//        }
//    }
    if (([UIScreen mainScreen].bounds.size.width - button.frame.origin.x) < 90) {
      
   
     _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - UISCREEN.size.width,0);
        
    }
    
    
//    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}


@end
