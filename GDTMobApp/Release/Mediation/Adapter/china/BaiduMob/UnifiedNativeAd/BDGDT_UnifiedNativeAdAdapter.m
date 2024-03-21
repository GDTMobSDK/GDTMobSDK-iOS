//
//  BDGDT_UnifiedNativeAdAdapter.m
//  GDTMobSDK
//
//  Created by Nancy on 2019/6/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BDGDT_UnifiedNativeAdAdapter.h"
#import <BaiduMobAdSDK/BaiduMobAdNative.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeAdObject.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeAdView.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import "BDGDT_UnifiedNativeDataObjectAdapter.h"
#import "MediationAdapterUtil.h"

static NSString *s_appId = nil;

@interface BDGDT_UnifiedNativeAdAdapter () <BaiduMobAdNativeAdDelegate>
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BaiduMobAdNative *nativeAd;
@property (nonatomic, copy) NSString *posId;

@end

@implementation BDGDT_UnifiedNativeAdAdapter
@dynamic maxVideoDuration;
@dynamic minVideoDuration;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (instancetype)initWithAdNetworkConnector:(id<GDTUnifiedNativeAdNetworkConnectorProtocol>)connector
                                     posId:(nonnull NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAdWithCount:(NSInteger)count {
    self.nativeAd = [[BaiduMobAdNative alloc] init];
    self.nativeAd.publisherId = s_appId;
    self.nativeAd.adUnitTag = self.posId;
    
    /*
    //type = normal
#define ADID_NORMAL @"2058621" //信息流
    //type = video
#define ADID_VIDEO  @"2362914" //信息流-视频
    */
//        self.nativeAd.adId = @"2058621";
//        self.nativeAd.publisherId = @"ccb60059";
    self.nativeAd.adDelegate = self;
    [self.nativeAd requestNativeAds];
}

- (NSInteger)eCPM
{
    return -1;
}

#pragma mark - BaiduMobAdNativeAdDelegate
/**
 * 广告请求成功
 * 请求成功的数组，如果只成功返回一条原生广告，数组大小为1
 * 注意：如果是返回元素，nativeAds为BaiduMobAdNativeAdObject数组。如果是优选模板，nativeAds为BaiduMobAdExpressNativeView数组
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds nativeAd:(BaiduMobAdNative *)nativeAd {
    NSMutableArray *adArray = [NSMutableArray array];
    for (BaiduMobAdNativeAdObject *adObject in nativeAds) {
        if (adObject.materialType != HTML && ![adObject isExpired]) {
            BDGDT_UnifiedNativeDataObjectAdapter *dataObjectAdapter = [[BDGDT_UnifiedNativeDataObjectAdapter alloc] initWithBaiduMobAdNativeAdObject:adObject];
            [adArray addObject:dataObjectAdapter];
        }
    }
    [self.connector adapter:self unifiedNativeAdLoaded:adArray error:nil];
}

/**
 *  广告请求失败
 */
- (void)nativeAdsFailLoadCode:(NSString *)errCode
                      message:(NSString *)message
                     nativeAd:(BaiduMobAdNative *)nativeAd {
    [self.connector adapter:self unifiedNativeAdLoaded:nil error:[NSError errorWithDomain:@"baidumob" code:[errCode integerValue] userInfo:@{@"error":message?:@""}]];
}

@end
