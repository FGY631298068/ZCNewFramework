/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+YCHighlightedWebCache.h"
#import "UIView+YCWebCacheOperation.h"

#define UIImageViewHighlightedWebCacheOperationKey @"highlightedImage"

@implementation UIImageView (YCHighlightedWebCache)

- (void)sd_setHighlightedImageWithURL:(NSURL *)url {
    [self sd_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)sd_setHighlightedImageWithURL:(NSURL *)url options:(YCSDWebImageOptions)options {
    [self sd_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)sd_setHighlightedImageWithURL:(NSURL *)url completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)sd_setHighlightedImageWithURL:(NSURL *)url options:(YCSDWebImageOptions)options completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)sd_setHighlightedImageWithURL:(NSURL *)url options:(YCSDWebImageOptions)options progress:(YCSDWebImageDownloaderProgressBlock)progressBlock completed:(YCSDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak __typeof(self)wself = self;
        id<YCSDWebImageOperation> operation = [YCSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self sd_setImageLoadOperation:operation forKey:UIImageViewHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:YCSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, YCSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_cancelCurrentHighlightedImageLoad {
    [self sd_cancelImageLoadOperationWithKey:UIImageViewHighlightedWebCacheOperationKey];
}

@end


@implementation UIImageView (HighlightedWebCacheDeprecated)

- (void)setHighlightedImageWithURL:(NSURL *)url {
    [self sd_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(YCSDWebImageOptions)options {
    [self sd_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setHighlightedImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(YCSDWebImageOptions)options completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setHighlightedImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(YCSDWebImageOptions)options progress:(YCSDWebImageDownloaderProgressBlock)progressBlock completed:(YCSDWebImageCompletedBlock)completedBlock {
    [self sd_setHighlightedImageWithURL:url options:0 progress:progressBlock completed:^(UIImage *image, NSError *error, YCSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentHighlightedImageLoad {
    [self sd_cancelCurrentHighlightedImageLoad];
}

@end
