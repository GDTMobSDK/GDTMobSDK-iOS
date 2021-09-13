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
#import "BDGDT_UnifiedNativeAdDelegateObject.h"

static NSString *s_appId = nil;

@interface BDGDT_UnifiedNativeAdAdapter ()
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BaiduMobAdNative *nativeAd;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) BDGDT_UnifiedNativeAdDelegateObject *delegateObject;

@end

@implementation BDGDT_UnifiedNativeAdAdapter
@dynamic maxVideoDuration;
@dynamic minVideoDuration;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
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
    self.delegateObject = [[BDGDT_UnifiedNativeAdDelegateObject alloc] init];
    self.delegateObject.connector = self.connector;
    self.delegateObject.adapter = self;
    
    self.nativeAd = [[BaiduMobAdNative alloc] init];
    self.nativeAd.publisherId = s_appId;
    self.nativeAd.adId = self.posId;
    
    /*
    //type = normal
#define ADID_NORMAL @"2058621" //信息流
    //type = video
#define ADID_VIDEO  @"2362914" //信息流-视频
    */
//        self.nativeAd.adId = @"2058621";
//        self.nativeAd.publisherId = @"ccb60059";
    self.nativeAd.delegate = self.delegateObject;
    [self.nativeAd requestNativeAds];
}

- (NSInteger)eCPM
{
    return -1;
}

@end
