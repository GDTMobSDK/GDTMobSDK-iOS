//
//  BDGDT_UnifiedInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by 胡俊峰 on 2019/11/29.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BDGDT_UnifiedInterstitialAdAdapter.h"
#import <BaiduMobAdSDK/BaiduMobAdExpressInterstitial.h>
#import <BaiduMobAdSDK/BaiduMobAdExpressFullScreenVideo.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import "BDGDT_UnifiedInterstitialDelegateObject.h"

static NSString *s_appId = nil;

@interface BDGDT_UnifiedInterstitialAdAdapter ()

@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BaiduMobAdExpressInterstitial *interstitialAd;
@property (nonatomic, strong) BaiduMobAdExpressFullScreenVideo *fullVideo;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) BDGDT_UnifiedInterstitialDelegateObject *delegateObject;

@end

@implementation BDGDT_UnifiedInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAd{
    self.delegateObject = [[BDGDT_UnifiedInterstitialDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    self.delegateObject.appId = s_appId;
    
    if (self.shouldLoadFullscreenAd) {
        self.fullVideo = [[BaiduMobAdExpressFullScreenVideo alloc] init];
        self.fullVideo.delegate = self.delegateObject;
        self.fullVideo.AdUnitTag = self.posId;
        self.fullVideo.publisherId = s_appId;
        self.fullVideo.adType = BaiduMobAdTypeFullScreenVideo;
        [self.fullVideo load];
    }
    else {
        self.interstitialAd = [[BaiduMobAdExpressInterstitial alloc] init];
        self.interstitialAd.delegate = self.delegateObject;
        self.interstitialAd.adUnitTag = self.posId;
        self.interstitialAd.publisherId = s_appId;
        [self.interstitialAd load];
    }
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController {
    if (self.shouldShowFullscreenAd) {
        [self.fullVideo showFromViewController:rootViewController];
    }
    else {
        [self.interstitialAd showFromViewController:rootViewController];
    }
}

- (BOOL)isAdValid{
    if (self.fullVideo) {
        return [self.fullVideo isReady];
    }
    else {
        return self.interstitialAd.isReady;
    }
}

- (void)sendWinNotification:(NSInteger)price {
    if (self.shouldShowFullscreenAd) {
        [self.fullVideo biddingSuccess:[NSString stringWithFormat:@"%ld", price]];
    }
    else {
        [self.interstitialAd biddingSuccess:[NSString stringWithFormat:@"%ld", price]];
    }
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    if (self.shouldShowFullscreenAd) {
        [self.fullVideo biddingFail:[NSString stringWithFormat:@"%ld", reason]];
    }
    else {
        [self.interstitialAd biddingFail:[NSString stringWithFormat:@"%ld", reason]];
    }
}

- (NSInteger)eCPM {
    if (self.shouldLoadFullscreenAd) {
        return [self.fullVideo getECPMLevel].integerValue;
    } else {
        return [self.interstitialAd getECPMLevel].integerValue;
    }
}

@end
