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
/// This method is called when material load successful
- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd {
    [self.connector adapter_splashAdDidLoad:self.adapter];
}

/// This method is called when material load failed
- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error {
    [self.connector adapter_splashAdFailToPresent:self.adapter withError:error];
}

/// This method is called when splash view render successful
- (void)splashAdRenderSuccess:(BUSplashAd *)splashAd {
    
}

/// This method is called when splash view render failed
- (void)splashAdRenderFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error {
    
}

/// This method is called when splash view will show
- (void)splashAdWillShow:(BUSplashAd *)splashAd {
    
}

/// This method is called when splash view did show
- (void)splashAdDidShow:(BUSplashAd *)splashAd {
    [self.connector adapter_splashAdSuccessPresentScreen:self.adapter];
    [self.connector adapter_splashAdExposured:self.adapter];
}

/// This method is called when splash view is clicked.
- (void)splashAdDidClick:(BUSplashAd *)splashAd {
    [self.connector adapter_splashAdClicked:self.adapter];
}

/// This method is called when splash view is closed.
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType {
    [self.adapter performSelector:@selector(removeAllSubviews)];
    [self.connector adapter_splashAdClosed:self.adapter];
}

/// This method is called when splash viewControllr is closed.
- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd {
    
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashDidCloseOtherController:(BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType {
    
}

/// This method is called when when video ad play completed or an error occurred.
- (void)splashVideoAdDidPlayFinish:(BUSplashAd *)splashAd didFailWithError:(NSError *)error {
    
}

@end
