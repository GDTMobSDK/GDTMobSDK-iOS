//
//  BDGDT_SplashAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/4/26.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_SplashAdDelegateObject.h"
#import "BDGDT_SplashAdAdapter.h"

@implementation BDGDT_SplashAdDelegateObject

#pragma mark - BaiduMobAdSplashDelegate

- (NSString *)publisherId {
    return self.appId;
}

/**
 *  广告曝光成功
 */
- (void)splashDidExposure:(BaiduMobAdSplash *)splash {
    [self.connector adapter_splashAdExposured:self.adapter];
}

/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
    [self.connector adapter_splashAdSuccessPresentScreen:self.adapter];
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason {
    [(BDGDT_SplashAdAdapter *)self.adapter removeSplash];
    [self.connector adapter_splashAdFailToPresent:self.adapter withError:[NSError errorWithDomain:@"baidumob" code:reason userInfo:nil]];
}

/**
 *  广告被点击
 */
- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    [self.connector adapter_splashAdClicked:self.adapter];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    [(BDGDT_SplashAdAdapter *)self.adapter removeSplash];
    [self.connector adapter_splashAdClosed:self.adapter];
}

/**
 *  广告详情页消失
 */
- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    [self.connector adapter_splashAdDidDismissFullScreenModal:self.adapter];
}

/**
 *  广告加载完成
 *  adType:广告类型 BaiduMobMaterialType
 *  videoDuration:视频时长，仅广告为视频时出现。非视频类广告默认0。 单位ms
 */
- (void)splashDidReady:(BaiduMobAdSplash *)splash
             AndAdType:(NSString *)adType
         VideoDuration:(NSInteger)videoDuration {
    self.adValid = YES;
}

/**
 * 开屏广告请求成功
 *
 * @param splash 开屏广告对象
 */
- (void)splashAdLoadSuccess:(BaiduMobAdSplash *)splash {
    [self.connector adapter_splashAdDidLoad:self.adapter];
}

/**
 * 开屏广告请求失败
 *
 * @param errCode 错误码
 * @param message 错误信息
 * @param splash 开屏广告对象
 */
- (void)splashAdLoadFailCode:(NSString *)errCode message:(NSString *)message splashAd:(BaiduMobAdSplash *)nativeAd {
    [self.connector adapter_splashAdFailToPresent:self.adapter withError:[NSError errorWithDomain:@"baidumob" code:[errCode integerValue] userInfo:@{
        @"message":message
    }]];
    nativeAd.delegate = nil;
}

@end
