//
//  BUGDT_NativeExpressInterstitialAdDelegateObject.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/4/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressInterstitialAdDelegateObject.h"

@implementation BUGDT_NativeExpressInterstitialAdDelegateObject

#pragma mark BUNativeExpresFullscreenVideoAdDelegate

- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    self.fullscreenAdDidLoad = YES;
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self.adapter];
}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self.adapter error:error];
}


- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialClicked:self.adapter];
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self.adapter];
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    [self.connector adapter_unifiedInterstitialWillExposure:self.adapter];
}

@end
