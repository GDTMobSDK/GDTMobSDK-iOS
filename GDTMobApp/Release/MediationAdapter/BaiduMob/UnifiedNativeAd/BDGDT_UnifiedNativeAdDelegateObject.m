//
//  BDGDT_UnifiedNativeAdDelegateObject.m
//  GDTMobApp
//
//  Created by Nancy on 2021/4/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_UnifiedNativeAdDelegateObject.h"
#import "BDGDT_UnifiedNativeDataObjectAdapter.h"

@implementation BDGDT_UnifiedNativeAdDelegateObject

#pragma mark -BaiduMobAdNativeAdDelegate

/**
 * 广告请求成功
 * 请求成功的BaiduMobAdNativeAdObject数组，如果只成功返回一条原生广告，数组大小为1
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds nativeAd:(BaiduMobAdNative *)nativeAd {
    NSMutableArray *adArray = [NSMutableArray array];
    for (BaiduMobAdNativeAdObject *adObject in nativeAds) {
        if (adObject.materialType != HTML && ![adObject isExpired]) {
            BDGDT_UnifiedNativeDataObjectAdapter *dataObjectAdapter = [[BDGDT_UnifiedNativeDataObjectAdapter alloc] initWithBaiduMobAdNativeAdObject:adObject];
            [adArray addObject:dataObjectAdapter];
        }
    }
    [self.connector adapter:self.adapter unifiedNativeAdLoaded:adArray error:nil];
}

/**
 *  广告请求失败
 *  失败的类型 BaiduMobFailReason
 */

- (void)nativeAdsFailLoadCode:(NSString *)errCode message:(NSString *)message nativeAd:(BaiduMobAdNative *)nativeAd {
    [self.connector adapter:self.adapter unifiedNativeAdLoaded:nil error:[NSError errorWithDomain:@"baidumob" code:[errCode integerValue] userInfo:@{@"error":message?:@""}]];
}
/**
 *  广告曝光成功
 */
- (void)nativeAdExposure:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BDGDT_UnifiedNativeAdExposed" object:object];
}

/**
 *  广告曝光失败
 */
- (void)nativeAdExposureFail:(UIView *)nativeAdView
          nativeAdDataObject:(BaiduMobAdNativeAdObject *)object
                  failReason:(int)reason {
    
}

/**
 *  广告点击
 */
- (void)nativeAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BDGDT_UnifiedNativeAdClicked" object:object];
}

/**
 *  广告详情页关闭
 */
- (void)didDismissLandingPage:(UIView *)nativeAdView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BDGDT_didDismissLandingPage" object:nativeAdView];
}

/**
 * BaiduMobAdExpressNativeView组件渲染成功
 */
- (void)nativeAdExpressSuccessRender:(BaiduMobAdExpressNativeView *)express nativeAd:(BaiduMobAdNative *)nativeAd {
    
}




@end
