//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat YCMJRefreshHeaderHeight = 54.0;
const CGFloat YCMJRefreshFooterHeight = 44.0;
const CGFloat YCMJRefreshFastAnimationDuration = 0.25;
const CGFloat YCMJRefreshSlowAnimationDuration = 0.4;

NSString *const YCMJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const YCMJRefreshKeyPathContentInset = @"contentInset";
NSString *const YCMJRefreshKeyPathContentSize = @"contentSize";
NSString *const YCMJRefreshKeyPathPanState = @"state";

NSString *const YCMJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";

NSString *const YCMJRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const YCMJRefreshHeaderPullingText = @"松开立即刷新";
NSString *const YCMJRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const YCMJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const YCMJRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const YCMJRefreshAutoFooterNoMoreDataText = @"没有更多数据";

NSString *const YCMJRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const YCMJRefreshBackFooterPullingText = @"松开立即加载更多";
NSString *const YCMJRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const YCMJRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";