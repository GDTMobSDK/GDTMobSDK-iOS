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
@property (nonatomic, copy) NSArray<BaiduMobAdNativeAdObject *> *bdNativeAds;

@end

@implementation BDGDT_NativeExpressAdAdapter
@synthesize adSize = _adSize;
@synthesize videoMuted = _videoMuted;

#pragma mark - base func

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (BOOL)sdkInitializationSuccess {
    return YES;
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
    self.native.adDelegate = self;
    self.native.publisherId = s_appId;
    self.native.adUnitTag = self.posId;
    self.native.presentAdViewController = nil;
    [self.native requestNativeAds];
}

#pragma mark - BaiduMobAdNativeAdDelegate

- (BOOL)enableLocation {
    return NO;
}

- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds nativeAd:(BaiduMobAdNative *)nativeAd {
    self.bdNativeAds = nativeAds;
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
        adapter.connector = self.connector;
        [viewAdapters addObject:adapter];
    }
    if (viewAdapters.count <= 0) {
        if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdFailToLoad:error:)]) {
            [self.connector adapter_nativeExpressAdFailToLoad:self error:nil];
        }
    }
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdSuccessToLoad:viewAdapters:)]) {
        [self.connector adapter_nativeExpressAdSuccessToLoad:self viewAdapters:[viewAdapters copy]];
    }
}

- (void)nativeAdsFailLoadCode:(NSString *)errCode message:(NSString *)message nativeAd:(BaiduMobAdNative *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdFailToLoad:error:)]) {
        [self.connector adapter_nativeExpressAdFailToLoad:self error:[NSError errorWithDomain:@"baidumob" code:errCode.intValue userInfo:@{
            @"error":message?:@""
        }]];
    }
}

- (NSInteger)eCPM {
    return [self.bdNativeAds.firstObject getECPMLevel].integerValue;
}

- (void)sendWinNotification:(NSInteger)price {
    [self.bdNativeAds.firstObject biddingSuccess:[NSString stringWithFormat:@"%ld", price]];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.bdNativeAds.firstObject biddingFail:[NSString stringWithFormat:@"%ld", reason]];
}

@end
