//
//  BDGDT_NativeExpressAdViewAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_NativeExpressAdViewAdapter.h"
#import <BaiduMobAdSDK/BaiduMobAdNativeInterationDelegate.h>
#import <BaiduMobAdSDK/BaiduMobAdExpressNativeView.h>

@interface BDGDT_NativeExpressAdViewAdapter () <BaiduMobAdNativeInterationDelegate>

@property (nonatomic, strong) BaiduMobAdSmartFeedView *feedView;
@property (nonatomic, assign) BOOL exposed;

@end

@implementation BDGDT_NativeExpressAdViewAdapter
@synthesize controller = _controller;
@synthesize isReady = _isReady;
@synthesize isVideoAd = _isVideoAd;
@synthesize gdtExpressAdView = _gdtExpressAdView;

- (instancetype)initWithBDNativeAdView:(BaiduMobAdSmartFeedView *)feedView object:(BaiduMobAdNativeAdObject *)object
{
    self = [super init];
    if (self) {
        object.interationDelegate = self;
        self.feedView = feedView;
        self.bdAdObject = object;
    }
    return self;
}

- (void)resize {
    CGRect origin = ((UIView *)self.gdtExpressAdView).frame;
    CGRect target = CGRectMake(origin.origin.x, origin.origin.y, CGRectGetWidth(self.feedView.frame), CGRectGetHeight(self.feedView.frame));
    ((UIView *)self.gdtExpressAdView).frame = target;
}

#pragma mark - GDTNativeExpressAdViewAdapterProtocol

- (UIView *)adView {
    return self.feedView;
}

- (NSInteger)eCPM {
    return -1;
}

- (nonnull NSString *)eCPMLevel {
    return self.bdAdObject.ECPMLevel;
}

- (void)render {
    [self.feedView render];
    [self.feedView trackImpression];
}

- (CGFloat)videoDuration {
    return -1;
}

- (CGFloat)videoPlayTime {
    return -1;
}

- (void)setController:(UIViewController *)controller {
    _controller = controller;
}

- (BOOL)isReady {
    return [self.feedView isReady];
}

- (BOOL)isVideoAd {
    return self.bdAdObject.videoURLString.length > 0;
}

- (BOOL)isAdValid {
    return !self.bdAdObject.isExpired;
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    
}

- (void)sendWinNotification:(NSInteger)price {
    
}

#pragma mark - BaiduMobAdNativeInterationDelegate
/**
 *  广告曝光成功
 */
- (void)nativeAdExposure:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    if (!self.exposed) {
        self.exposed = YES;
        if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterExposure:)]) {
            [self.connector adapter_nativeExpressAdViewAdapterExposure:self];
        }
    }
}

/**
 *  广告曝光失败
 */
- (void)nativeAdExposureFail:(UIView *)nativeAdView
          nativeAdDataObject:(BaiduMobAdNativeAdObject *)object
                  failReason:(int)reason{}

/**
 *  广告点击
 */
- (void)nativeAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClicked:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClicked:self];
    }
}

/**
 *  广告详情页关闭
 */
- (void)didDismissLandingPage:(UIView *)nativeAdView {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterDidDissmissScreen:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterDidDissmissScreen:self];
    }
}

/**
 *  联盟官网点击跳转
 */
- (void)unionAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {}

/**
 *  反馈弹窗展示
 *  @param adView 当前的广告视图
 */
- (void)nativeAdDislikeShow:(UIView *)adView {}

/**
 *  反馈弹窗点击
 *  @param adView 当前的广告视图
 *  @param reason 反馈原因
 */
- (void)nativeAdDislikeClick:(UIView *)adView reason:(BaiduMobAdDislikeReasonType)reason {
    if ([self.connector respondsToSelector:@selector(adapter_adComplainSuccess:)]) {
        [self.connector adapter_adComplainSuccess:self];
    }
}

/**
 *  反馈弹窗关闭
 *  @param adView 当前的广告视图
 */
- (void)nativeAdDislikeClose:(UIView *)adView {}

/**
 *  视频缓存成功
 */
- (void)nativeVideoAdCacheSuccess:(BaiduMobAdNative *)nativeAd {}

/**
 *  视频缓存失败
 */
- (void)nativeVideoAdCacheFail:(BaiduMobAdNative *)nativeAd withError:(BaiduMobFailReason)reason {}

/**
 * BaiduMobAdExpressNativeView组件渲染成功
 */
- (void)nativeAdExpressSuccessRender:(BaiduMobAdExpressNativeView *)express
                            nativeAd:(BaiduMobAdNative *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterRenderSuccess:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterRenderSuccess:self];
    }
}

@end
