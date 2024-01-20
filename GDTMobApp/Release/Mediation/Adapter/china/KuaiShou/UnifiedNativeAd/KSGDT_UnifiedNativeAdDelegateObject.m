//
//  KSGDT_UnifiedNativeAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_UnifiedNativeAdDelegateObject.h"

@implementation KSGDT_UnifiedNativeAdDelegateObject

#pragma mark - KSNativeAdsManagerDelegate

- (void)nativeAdsManagerSuccessToLoad:(KSNativeAdsManager *)adsManager nativeAds:(NSArray<KSNativeAd *> *_Nullable)nativeAdDataArray {
    NSMutableArray *adArray = [NSMutableArray array];
    for (KSNativeAd *nativeAd in nativeAdDataArray) {
        KSGDT_UnifiedNativeDataObjectAdapter *dataObjectAdapter = [[KSGDT_UnifiedNativeDataObjectAdapter alloc] initWithKSNativeAd:nativeAd];
        nativeAd.delegate = dataObjectAdapter;
        [adArray addObject:dataObjectAdapter];
    }
    
    self.nativeAdArray = adArray;
    [self.connector adapter:self.adapter unifiedNativeAdLoaded:adArray error:nil];
}

- (void)nativeAdsManager:(KSNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    [self.connector adapter:self.adapter unifiedNativeAdLoaded:nil error:error];
}


@end
