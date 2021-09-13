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

- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self.adapter];
}

/**
  *  广告预加载失败
  */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self.adapter error:nil];
    interstitial.delegate = nil;
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialWillPresentScreen:self.adapter];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialWillExposure:self.adapter];
    [self.connector adapter_unifiedInterstitialDidPresentScreen:self.adapter];
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason {
    [self.connector adapter_unifiedInterstitialFailToPresentAd:self.adapter error:[NSError errorWithDomain:@"baidumob" code:reason userInfo:nil]];
}

/**
 *  广告展示被用户点击时的回调
 */
- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialClicked:self.adapter];
}

/**
 *  广告展示结束
 *  调用展示的时候, 如果与请求时的横竖屏方向不同的话, 不会展示广告并直接调用该方法.
 *  展示出来以后屏幕旋转, 广告会自动关闭并直接调用该方法.
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial{
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self.adapter];
}

/**
 *  广告详情页被关闭
 */
- (void)interstitialDidDismissLandingPage:(BaiduMobAdInterstitial *)interstitial {
    [self.connector adapter_unifiedInterstitialAdDidDismissFullScreenModal:self.adapter];
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
