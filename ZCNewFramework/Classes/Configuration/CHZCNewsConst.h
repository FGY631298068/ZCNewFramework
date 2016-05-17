//
//  CHZCNewsConst.h
//  ZCGamesNews
//
//  Created by Summer on 16/2/19.
//  Copyright © 2016年 Summer. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 新闻主题色 */
#define CHNewsThemeColor CH_HexRGB(0xfe3157)

/** 新闻标准字体 - 设置尺寸 */
#define CHNewsThemeBoldFontSize(a) [UIFont fontWithName:CHNewsTitleFontName size:(a)]        // 标题字体 - 粗体
#define CHNewsThemeSerifFontSize(a) [UIFont fontWithName:CHNewsDetailsFontName size:(a)]     // 正文字体 - 细体

UIKIT_EXTERN NSString *const CHNewsTitleFontName;    // 标题字体 - 粗体
UIKIT_EXTERN NSString *const CHNewsDetailsFontName;  // 子标题字体 - 细体


//-----------------------------------------------------机型屏幕------------------------------------------------------------------
#define IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size): NO)
#define IS_IPHONE_6PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size): NO)
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1336), [[UIScreen mainScreen] currentMode].size): NO)
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size): NO)


//----------------------------------------------------字体、图片缩放比例----------------------------------------------------------------
#define iphone6PlusFontScale 1.1                    // iPhone6Plus设备乘于这个比例
#define iphone6FontScale 1
#define iphone5beforeFontScale 1.17                 // iPhone5之前的设备除于这个比例
#define kNetworkingErrorPlaceholderHWScale 0.87f    // 无网占位图提示高宽比例





// ---------------------------------------------------新闻一级界面的设置配置--------------------------------------------------------

#define YC_assistantAppDownLineColor        CH_HexRGB(0xe1e1e1)  // cell底部线的颜色
#define YC_newsTitleLabelFontSize            15.0f  // 新闻标题字体大小
#define YC_newsDetailsLabelFontSize          13.0f  // 新闻描述详情字体大小
#define YC_classificationItemFontSize        17.0f  // 新闻分类Item的字体大小





// ---------------------------------------------------新闻二级界面的设置配置--------------------------------------------------------
// 字体大小
#define CH_GraphicTitleFontSize             24.0f // 标题字体大小
#define CH_GraphicSubTitleFontSize          14.0f // 副标题字体大小
#define CH_GraphicImageDiscriptionFontSize  13.0f // 图片描述大小
#define CH_GraphicParagraphTitleFontSize    19.5f // 段落标题字体大小
#define CH_GraphicParagraphContentFontSize  17.5f // 段落正文字体大小
#define CH_GraphicDateFontSize              13.0f // 日期字体大小
#define YC_assistantAppDownFontSize         10.0f // 跳转app下载文字大小
#define YC_assistantAppTitleFontSize        16.0f // 跳转app标题文字大小
#define YC_assistantAppDiscriptionFontSize  11.0f // 跳转app描述文字大小


// 字体颜色
#define CH_GraphicTitleFontColor            CH_HexRGB(0x000000)  // 标题颜色
#define CH_GraphicSubTitleFontColor         CH_HexRGB(0x000000)  // 副标题颜色
#define CH_GraphicImageDiscriptionFontColor CH_HexRGB(0x000000)  // 图片描述颜色
#define CH_GraphicParagraphTitleFontColor   CH_HexRGB(0x000000)  // 段落标题颜色
#define CH_GraphicParagraphContentFontColor CH_HexRGB(0x353535)  // 段落正文颜色
#define CH_GraphicDateFontColor             CH_HexRGB(0x000000)  // 日期字体颜色
#define YC_assistantAppDownFontColor        CH_HexRGB(0xb2b4b9)  // 跳转app下载文字颜色
#define YC_assistantAppDiscriptionFontColor CH_HexRGB(0x797e7f)  // 跳转app描述文字颜色
#define YC_assistantAppDownLineColor        CH_HexRGB(0xe1e1e1)  // 跳转app底部线的颜色
// 占位颜色
#define CH_GraphicImageViewPlaceholderColor  CH_HexRGB(0xdedfee) // 图片模块图像的占位颜色


// 固定距离
#define CH_GraphicDataBarH 25.0f // 时间栏的高度

// 增加高度
#define CH_AdditionalMainTitle_H         10.0f   // 主标题附加高度 30.0f
#define CH_AdditionalImageModule_H       0.0f   // 图片模块附加高度 10.0f
#define CH_AdditionalImageDiscription_H  20.0f   // 图片模块: 图像描述的附加高度 20.0f
#define CH_AdditionalParagraphModule_H   10.0f   // 段落模块: 自身的附加高度 20.0f
#define CH_AdditionalParagraphTitle_H    10.0f   // 段落模块: 段落标题的附加高度 36.0f
#define CH_AdditionalParagraphContent_H  10.0f   // 段落模块: 段落正文的附加高度
#define YC_AddtionalAssistantAppContent_H 0.0f  // 跳转app的附加高度


// ---------------------------------------------------新闻二级界面图文详情的设置配置----------------------------------------------------

// 通用
#define spacing 10.0f  // 通用间距

// 固定间距
#define CH_TitleView_H 25.0f // 标题的高度

// 字体大小
#define CH_TextContentView_TitleFontSize         18.0f // 图片介绍视图: 标题字体大小
#define CH_TextContentView_DescriptionFontSize   16.0f // 图片介绍视图: 详情字体大小
#define CH_TextContentView_PageFontSize          18.0f // 图片介绍视图: 页标字体大小

// 字体颜色
#define CH_TextContentView_TitleColor            CH_HexRGB(0xffffff) // 图片介绍视图: 标题字体颜色
#define CH_TextContentView_DescriptionColor      CH_HexRGB(0xffffff) // 图片介绍视图: 详情字体颜色
#define CH_TextContentView_PageColor             CH_HexRGB(0xffffff) // 图片介绍视图: 详情字体颜色



// ---------------------------------------------------新闻二级界面多图详情的设置配置----------------------------------------------------
UIKIT_EXTERN NSString *const YCMoreImageChangePageValue;
UIKIT_EXTERN NSString *const YCMoreImagePageValue;
