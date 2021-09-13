//
//  BDGDT_NativeExpressAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_NativeExpressAdAdapter.h"
#import <BaiduMobAdSDK/BaiduMobAdNative.h>
#import "GDTNativeExpressAdNetworkConnectorProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdNativeAdObject.h>
#import "BDGDT_NativeExpressAdViewAdapter.h"

static NSString *s_appId = nil;

@interface BDGDT_NativeExpressAdAdapter () <BaiduMobAdNativeAdDelegate>

@property (nonatomic, weak) id<GDTNativeExpressAdNetworkConnectorProtocol> connector;
@property (nonatomic, strong) BaiduMobAdNative *native;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, copy) NSArray<BDGDT_NativeExpressAdViewAdapter *> *viewAdapters;
@property (nonatomic, strong) NSMutableSet *exposuredSet;

@end

@implementation BDGDT_NativeExpressAdAdapter
@synthesize adSize = _adSize;
@synthesize videoMuted = _videoMuted;

#pragma mark - base func

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId {
    if (!connector) {
        return nil;
    }
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }

    return self;
}

- (void)loadAdWithCount:(NSInteger)count {
    self.native = [[BaiduMobAdNative alloc] init];
    self.native.delegate = self;
    self.native.publisherId = s_appId;
    self.native.adId = self.posId;
    self.native.presentAdViewController = nil;
    [self.native requestNativeAds];
}

- (BDGDT_NativeExpressAdViewAdapter *)viewAdapter:(UIView *)bdAdView {
    __block BDGDT_NativeExpressAdViewAdapter *adapter = nil;
    [self.viewAdapters enumerateObjectsUsingBlock:^(BDGDT_NativeExpressAdViewAdapter *_Nonnull obj, NSUInteger idx,
                                                    BOOL *_Nonnull stop) {
      if ([obj adView] == bdAdView) {
          adapter = obj;
          *stop = YES;
      }
    }];
    return adapter;
}

- (BDGDT_NativeExpressAdViewAdapter *)viewAdapterForAdObject:(BaiduMobAdNativeAdObject *)object {
    __block BDGDT_NativeExpressAdViewAdapter *adapter = nil;
    [self.viewAdapters enumerateObjectsUsingBlock:^(BDGDT_NativeExpressAdViewAdapter *_Nonnull obj, NSUInteger idx,
                                                    BOOL *_Nonnull stop) {
      if (obj.bdAdObject == object) {
          adapter = obj;
          *stop = YES;
      }
    }];
    return adapter;
}

#pragma mark - BaiduMobAdNativeAdDelegate

- (BOOL)enableLocation {
    return NO;
}

- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds nativeAd:(BaiduMobAdNative *)nativeAd {
    NSMutableArray<BDGDT_NativeExpressAdViewAdapter *> *viewAdapters = [NSMutableArray array];
    for (BaiduMobAdNativeAdObject *object in nativeAds) {
        if ([object isExpired]) {
            continue;
        }
        // 百青藤智能优选View start
        BaiduMobAdSmartFeedView *feedView = [[BaiduMobAdSmartFeedView alloc]initWithObject:object frame:CGRectMake(0, 0, self.adSize.width, self.adSize.height)];
        if (!feedView) {
            continue;
        }
        // 在此对view进行布局调整，在<BaiduMobAdSDK/BaiduMobAdSmartFeedView.h>查看可调参数
        // ...
        [feedView setVideoMute:self.videoMuted];
        [feedView reSize];
        // 百青藤智能优选View end
        BDGDT_NativeExpressAdViewAdapter *adapter = [[BDGDT_NativeExpressAdViewAdapter alloc] initWithBDNativeAdView:feedView object:object];
        [viewAdapters addObject:adapter];
    }
    if (viewAdapters.count <= 0) {
        if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdFailToLoad:error:)]) {
            [self.connector adapter_nativeExpressAdFailToLoad:self error:nil];
        }
    }
    self.viewAdapters = viewAdapters;
    self.exposuredSet = [NSMutableSet set];
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdSuccessToLoad:viewAdapters:)]) {
        [self.connector adapter_nativeExpressAdSuccessToLoad:self viewAdapters:[viewAdapters copy]];
    }
}

- (void)nativeAdsFailLoad:(BaiduMobFailReason)reason nativeAd:(BaiduMobAdNative *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdFailToLoad:error:)]) {
        [self.connector adapter_nativeExpressAdFailToLoad:self error:nil];
    }
}

- (void)nativeAdExposure:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    if ([self.exposuredSet containsObject:nativeAdView]) {
        return;
    }
    [self.exposuredSet addObject:nativeAdView];
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterExposure:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterExposure:[self viewAdapter:nativeAdView]];
    }
}

- (void)nativeAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClicked:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClicked:[self viewAdapter:nativeAdView]];
    }
}

- (void)didDismissLandingPage:(UIView *)nativeAdView {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterDidDissmissScreen:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterDidDissmissScreen:[self viewAdapter:nativeAdView]];
    }
}

- (void)smartFeedbackSelectedWithObject:(BaiduMobAdNativeAdObject *)object {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClosed:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClosed:[self viewAdapterForAdObject:object]];
    }
}

@end
