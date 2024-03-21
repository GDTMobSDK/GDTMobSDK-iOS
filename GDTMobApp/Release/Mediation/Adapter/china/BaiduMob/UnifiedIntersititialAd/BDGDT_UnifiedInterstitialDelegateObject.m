//
//  BDGDT_UnifiedInterstitialDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/4/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_UnifiedInterstitialDelegateObject.h"

@implementation BDGDT_UnifiedInterstitialDelegateObject

#pragma mark - BaiduMobAdInterstitialDelegate

- (NSString *)publisherId {
    return self.appId;
}

- (BOOL)enableLocation {
    return NO;
}

/**
 * 广告请求成功
 */
- (void)interstitialAdLoaded:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self.adapter];
}

/**
 * 广告请求失败
 */
- (void)interstitialAdLoadFailCode:(NSString *)errCode
                           message:(NSString *)message
                    interstitialAd:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self.adapter error:nil];
    interstitial.delegate = nil;
}

/**
 *  广告曝光成功
 */
- (void)interstitialAdExposure:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialWillExposure:self.adapter];
}

/**
 *  广告展现失败
 */
- (void)interstitialAdExposureFail:(BaiduMobAdExpressInterstitial *)interstitial withError:(int)reason {
    [self.connector adapter_unifiedInterstitialFailToPresentAd:self.adapter error:[NSError errorWithDomain:@"baidumob" code:reason userInfo:nil]];
}


/**
 *  广告被关闭
 */
- (void)interstitialAdDidClose:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self.adapter];
}

/**
 *  广告被点击
 */
- (void)interstitialAdDidClick:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialClicked:self.adapter];
}

/**
 *  广告落地页关闭
 */
- (void)interstitialAdDidLPClose:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialAdDidDismissFullScreenModal:self.adapter];
}

/**
 * 广告反馈点击
 */
- (void)interstitialAdDislikeClick:(BaiduMobAdExpressInterstitial *)interstitial {
    [self.connector adapter_adComplainSuccess:self.adapter];
}

#pragma mark - expressFullVideoDelegate

- (void)fullScreenVideoAdLoaded:(BaiduMobAdExpressFullScreenVideo *)video {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self.adapter];
}

- (void)fullScreenVideoAdLoadFailed:(BaiduMobAdExpressFullScreenVideo *)video withError:(BaiduMobFailReason)reason {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self.adapter error:[NSError errorWithDomain:@"baidumob" code:reason userInfo:nil]];
}

- (void)fullScreenVideoAdShowFailed:(BaiduMobAdExpressFullScreenVideo *)video withError:(BaiduMobFailReason)reason {
    [self.connector adapter_unifiedInterstitialFailToPresentAd:self.adapter error:[NSError errorWithDomain:@"baidumob" code:reason userInfo:nil]];
}

- (void)fullScreenVideoAdDidStarted:(BaiduMobAdExpressFullScreenVideo *)video {
    [self.connector adapter_unifiedInterstitialWillExposure:self.adapter];
    [self.connector adapter_unifiedInterstitialAd:self.adapter playerStatusChanged:GDTMediaPlayerStatusStarted];
}

- (void)fullScreenVideoAdDidPlayFinish:(BaiduMobAdExpressFullScreenVideo *)video {
    [self.connector adapter_unifiedInterstitialAd:self.adapter playerStatusChanged:GDTMediaPlayerStatusStoped];
}

- (void)fullScreenVideoAdDidClick:(BaiduMobAdExpressFullScreenVideo *)video withPlayingProgress:(CGFloat)progress {
    [self.connector adapter_unifiedInterstitialClicked:self.adapter];
}

- (void)fullScreenVideoAdDidClose:(BaiduMobAdExpressFullScreenVideo *)video withPlayingProgress:(CGFloat)progress {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self.adapter];
}

- (void)fullScreenVideoAdDidSkip:(BaiduMobAdExpressFullScreenVideo *)video withPlayingProgress:(CGFloat)progress{
    

}


@end
