/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+YCWebCache.h"
#import "objc/runtime.h"
#import "UIView+YCWebCacheOperation.h"

static char imageURLStorageKey;

@implementation UIButton (YCWebCache)

- (NSURL *)sd_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (NSURL *)sd_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options completed:(YCSDWebImageCompletionBlock)completedBlock {

    [self setImage:placeholder forState:state];
    [self sd_cancelImageLoadForState:state];
    
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:YCSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, YCSDImageCacheTypeNone, url);
            }
        });
        
        return;
    }
    
    self.imageURLStorage[@(state)] = url;

    __weak __typeof(self)wself = self;
    id <YCSDWebImageOperation> operation = [YCSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image) {
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType, url);
            }
        });
    }];
    [self sd_setImageLoadOperation:operation forState:state];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_cancelImageLoadForState:state];

    [self setBackgroundImage:placeholder forState:state];

    if (url) {
        __weak __typeof(self)wself = self;
        id <YCSDWebImageOperation> operation = [YCSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image) {
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setBackgroundImageLoadOperation:operation forState:state];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:YCSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, YCSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_setImageLoadOperation:(id<YCSDWebImageOperation>)operation forState:(UIControlState)state {
    [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)sd_cancelImageLoadForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)sd_setBackgroundImageLoadOperation:(id<YCSDWebImageOperation>)operation forState:(UIControlState)state {
    [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)sd_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (NSMutableDictionary *)imageURLStorage {
    NSMutableDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage)
    {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end


@implementation UIButton (WebCacheDeprecated)

- (NSURL *)currentImageURL {
    return [self sd_currentImageURL];
}

- (NSURL *)imageURLForState:(UIControlState)state {
    return [self sd_imageURLForState:state];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(YCSDWebImageOptions)options completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentImageLoad {
    // in a backwards compatible manner, cancel for current state
    [self sd_cancelImageLoadForState:self.state];
}

- (void)cancelBackgroundImageLoadForState:(UIControlState)state {
    [self sd_cancelBackgroundImageLoadForState:state];
}

@end
