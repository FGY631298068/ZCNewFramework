//
//  CHClassificationBar.h
//  ZCNewFramework
//
//  Created by 范国义 on 16/5/17.
//  Copyright © 2016年 范国义. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHClassificationBarDelegate <NSObject>
//当点击Item的时候调用这个方法
- (void)clickOnIndexItem:(NSInteger)indexItem andWhichIndexItemUrl:(NSString *)url;

@end

@interface CHClassificationBar : UIView

@property (nonatomic, weak)id <CHClassificationBarDelegate>delegate;
/**
 *  创建Item
 *
 *  @param itemArray 每个Item的数据
 */
- (void)cratClassifiedItme:(NSArray *)itemArray;
/**
 *  改变Item的选中状态
 *
 *  @param indexPage 显示的第几个界面
 */
- (void)currentPageItemBecomeselected:(NSInteger)indexPage;

/**
 *  让item所在的scrollView也滚动
 */
- (void)letTheScrollViewTheItemIsAlsoRolling:(NSInteger)indexItem andIsLeftOrRigthBool:(BOOL)isLeftOrRight;

@end
