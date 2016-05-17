//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

extern const float YCNJKInitialProgressValue;
extern const float YCNJKInteractiveProgressValue;
extern const float YCNJKFinalProgressValue;

typedef void (^YCWebViewProgressBlock)(float progress);
@protocol YCNJKWebViewProgressDelegate;
@interface FGYWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<YCNJKWebViewProgressDelegate>ycprogressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>ycwebViewProxyDelegate;
@property (nonatomic, copy) YCWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol YCNJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(FGYWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

