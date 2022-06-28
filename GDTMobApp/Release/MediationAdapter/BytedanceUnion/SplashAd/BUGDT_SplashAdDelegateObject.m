//
//  BUGDT_SplashAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_SplashAdDelegateObject.h"

@implementation BUGDT_SplashAdDelegateObject

#pragma mark - BUSplashAdDelegate
/**
 This method is called when splash ad material loaded successfully.
 */
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd
{
    [self.connector adapter_splashAdDidLoad:self.adapter];
}

/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 */
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError * _Nullable)error
{
    [self.connector adapter_splashAdFailToPresent:self.adapter withError:error];
}

/**
 This method is called when splash ad slot will be showing.
 */
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd
{
    [self.connector adapter_splashAdSuccessPresentScreen:self.adapter];
    [self.connector adapter_splashAdExposured:self.adapter];
}

/**
 This method is called when splash ad is clicked.
 */
- (void)splashAdDidClick:(BUSplashAdView *)splashAd
{
    [self.connector adapter_splashAdClicked:self.adapter];
}

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(BUSplashAdView *)splashAd
{
    [self.adapter performSelector:@selector(removeAllSubviews)];
    [self.connector adapter_splashAdClosed:self.adapter];
}

/**
 This method is called when splash ad is about to close.
 */
- (void)splashAdWillClose:(BUSplashAdView *)splashAd
{
    [self.connector adapter_splashAdWillClosed:self.adapter];
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType
{
    [self.connector adapter_splashAdWillDismissFullScreenModal:self.adapter];
}

@end
