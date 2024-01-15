//
//  KSGDT_UnifiedInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/2.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_UnifiedInterstitialAdAdapter.h"
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import "KSGDT_UnifiedInterstitialAdDelegateObject.h"
#import <KSAdSDK/KSAdSDK.h>
#import "MediationAdapterUtil.h"

@interface KSGDT_UnifiedInterstitialAdAdapter () <KSInterstitialAdDelegate>
@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, strong) KSFullscreenVideoAd *fullscreenAd;
@property (nonatomic, strong) KSInterstitialAd *interstitialAd;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, assign) BOOL fullscreenAdDidLoad;
@property (nonatomic, strong) KSGDT_UnifiedInterstitialAdDelegateObject *delegateObject;
@end

@implementation KSGDT_UnifiedInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;
@synthesize videoMuted = _videoMuted;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (KSAdSDKManager.appId.length == 0) {
        if ([appId length] > 0) {
            [KSAdSDKManager setAppId:appId];
        }
        else {
            NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
            [KSAdSDKManager setAppId:params[@"appid"]];
        }
    }
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (nullable instancetype)initWithAdNetworkConnector:(nonnull id<GDTUnifiedInterstitialAdNetworkConnectorProtocol>)connector
                                              posId:(nonnull NSString *)posId {
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

- (void)loadAd {
    self.delegateObject = [[KSGDT_UnifiedInterstitialAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    if (self.shouldLoadFullscreenAd) {
        self.fullscreenAd = [[KSFullscreenVideoAd alloc] initWithPosId:self.posId];
        self.fullscreenAd.delegate = self.delegateObject;
        self.fullscreenAd.shouldMuted = self.videoMuted;
        [self.fullscreenAd loadAdData];
    } else {
        self.interstitialAd = [[KSInterstitialAd alloc] initWithPosId:self.posId];
        self.interstitialAd.delegate = self.delegateObject;
        self.interstitialAd.videoSoundEnabled = !self.videoMuted;
        [self.interstitialAd loadAdData];
    }
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    if (self.shouldShowFullscreenAd) {
        [self.fullscreenAd showAdFromRootViewController:rootViewController];
    } else {
        UIViewController *vc = rootViewController;
        if (vc.navigationController) {
            vc = vc.navigationController;
        } else if (vc.parentViewController) {
            vc = vc.parentViewController;
        }
        [self.interstitialAd showFromViewController:vc];
    }
}

- (BOOL)isAdValid {
    if (self.shouldLoadFullscreenAd) {
        return self.fullscreenAd.isValid;
    }
    return self.interstitialAd.isValid;
}

- (BOOL)isVideoAd {
    return YES;
}

- (NSInteger)eCPM {
    return self.fullscreenAd.ecpm;
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.fullscreenAd reportAdExposureFailed:0 reportParam:nil];
}

- (void)sendWinNotification:(NSInteger)price {
    [self.fullscreenAd setBidEcpm:price];
}

@end
