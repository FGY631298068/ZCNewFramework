//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define MJRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define MJRefreshLog(...)
#endif

// 过期提醒
#define YCMJRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define YCMJRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define YCMJRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define YCMJRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define YCMJRefreshLabelTextColor YCMJRefreshColor(90, 90, 90)

// 字体大小
#define YCMJRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 图片路径
#define YCMJRefreshSrcName(file) [@"YCMJRefresh.bundle" stringByAppendingPathComponent:file]
#define YCMJRefreshFrameworkSrcName(file) [@"Frameworks/YCMJRefresh.framework/YCMJRefresh.bundle" stringByAppendingPathComponent:file]

// 常量
UIKIT_EXTERN const CGFloat YCMJRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat YCMJRefreshFooterHeight;
UIKIT_EXTERN const CGFloat YCMJRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat YCMJRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const YCMJRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const YCMJRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const YCMJRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const YCMJRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const YCMJRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const YCMJRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const YCMJRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const YCMJRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const YCMJRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const YCMJRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const YCMJRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const YCMJRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const YCMJRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const YCMJRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const YCMJRefreshBackFooterNoMoreDataText;

// 状态检查
#define YCMJRefreshCheckState \
YCMJRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
