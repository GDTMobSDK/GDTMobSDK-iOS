//
//  KSGDT_SplasshAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_SplasshAdDelegateObject.h"

@implementation KSGDT_SplasshAdDelegateObject

#pragma mark - KSSplashAdViewDelegate
/**
 * splash ad request done
 */
- (void)ksad_splashAdDidLoad:(KSSplashAdView *)splashAdView {
    [self.connector adapter_splashAdDidLoad:self.adapter];
}

/**
 * splash ad material load, ready to display
 */
- (void)ksad_splashAdContentDidLoad:(KSSplashAdView *)splashAdView {
    self.splashAdContentLoaded = YES;
}
/**
 * splash ad (material) failed to load
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didFailWithError:(NSError *)error {
    if (error.code != 40004) {
        [self.connector adapter_splashAdFailToPresent:self.adapter withError:error];
    }
}
/**
 * splash ad did visible
 */
- (void)ksad_splashAdDidVisible:(KSSplashAdView *)splashAdView {
    [self.connector adapter_splashAdExposured:self.adapter];
}

/**
 * splash ad clicked
 * @param inMiniWindow whether click in mini window
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didClick:(BOOL)inMiniWindow {
    [self.connector adapter_splashAdClicked:self.adapter];
}

@end
