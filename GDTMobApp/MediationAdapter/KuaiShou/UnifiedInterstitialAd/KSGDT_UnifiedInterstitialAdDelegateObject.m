//
//  KSGDT_UnifiedInterstitialAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_UnifiedInterstitialAdDelegateObject.h"

@implementation KSGDT_UnifiedInterstitialAdDelegateObject

#pragma mark - KSFullscreenVideoAdDelegate

- (void)fullscreenVideoAdDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)fullscreenVideoAd:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self.adapter error:error];
}

/**
 This method is called when cached successfully.
 */
- (void)fullscreenVideoAdVideoDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd {
    //todo 是否要添加videoDidLoad的回调
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self.adapter];
    });
}

/**
 This method is called when video ad slot will be showing.
 */
- (void)fullscreenVideoAdWillVisible:(KSFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialWillExposure:self.adapter];
}

/**
 This method is called when video ad slot has been shown.
 */
- (void)fullscreenVideoAdDidVisible:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}

/**
 This method is called when video ad is about to close.
 */
- (void)fullscreenVideoAdWillClose:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}

/**
 This method is called when video ad is closed.
 */
- (void)fullscreenVideoAdDidClose:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}

/**
 This method is called when video ad is clicked.
 */
- (void)fullscreenVideoAdDidClick:(KSFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialClicked:self.adapter];
}

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)fullscreenVideoAdDidPlayFinish:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    //todo 是否要加回调
}

/**
 This method is called when the video begin to play.
 */
- (void)fullscreenVideoAdStartPlay:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}

/**
 This method is called when the user clicked skip button.
 */
- (void)fullscreenVideoAdDidClickSkip:(KSFullscreenVideoAd *)fullscreenVideoAd {
    
}

@end
