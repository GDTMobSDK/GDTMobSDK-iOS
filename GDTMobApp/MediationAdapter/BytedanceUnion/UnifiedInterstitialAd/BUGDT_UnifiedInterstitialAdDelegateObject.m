//
//  BUGDT_UnifiedInterstitialAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedInterstitialAdDelegateObject.h"

@implementation BUGDT_UnifiedInterstitialAdDelegateObject

#pragma mark BUFullscreenVideoAdDelegate

- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    self.fullscreenAdDidLoad = YES;
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self.adapter];
}

- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self.adapter error:error];
}

- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialClicked:self.adapter];
}

- (void)fullscreenVideoAdWillClose:(BUFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self.adapter];
}

- (void)fullscreenVideoAdDidPlayFinish:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    
}

- (void)fullscreenVideoAdWillVisible:(BUFullscreenVideoAd *)fullscreenVideoAd{
    [self.connector adapter_unifiedInterstitialWillExposure:self.adapter];
}

- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd{
    
}

- (void)fullscreenVideoAdCallback:(BUFullscreenVideoAd *)fullscreenVideoAd withType:(BUFullScreenVideoAdType)fullscreenVideoAdType{
    
}

@end
