//
//  BUGDT_UnifiedNativeAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedNativeAdDelegateObject.h"

@implementation BUGDT_UnifiedNativeAdDelegateObject

#pragma mark - BUNativeAdsManagerDelegate

- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *)nativeAdDataArray {
    NSMutableArray *adArray = [NSMutableArray array];
    for (BUNativeAd *nativeAd in nativeAdDataArray) {
        BUGDT_UnifiedNativeDataObjectAdapter *dataObjectAdapter = [[BUGDT_UnifiedNativeDataObjectAdapter alloc] initWithBUNativeAd:nativeAd];
        nativeAd.delegate = dataObjectAdapter;
        [adArray addObject:dataObjectAdapter];
    }
    
    self.adArray = adArray;
    [self.connector adapter:self.adapter unifiedNativeAdLoaded:adArray error:nil];
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    [self.connector adapter:self.adapter unifiedNativeAdLoaded:nil error:error];
}

@end
