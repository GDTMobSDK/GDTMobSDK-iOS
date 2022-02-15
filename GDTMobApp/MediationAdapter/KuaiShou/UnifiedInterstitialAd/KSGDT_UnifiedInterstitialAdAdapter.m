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

@interface KSGDT_UnifiedInterstitialAdAdapter ()
@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, strong) KSFullscreenVideoAd *fullscreenAd;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, assign) BOOL fullscreenAdDidLoad;
@property (nonatomic, strong) KSGDT_UnifiedInterstitialAdDelegateObject *delegateObject;
@end

@implementation KSGDT_UnifiedInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

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
    if (self.shouldLoadFullscreenAd) {
        self.delegateObject = [[KSGDT_UnifiedInterstitialAdDelegateObject alloc] init];
        self.delegateObject.adapter = self;
        self.delegateObject.connector = self.connector;
        
        self.fullscreenAd = [[KSFullscreenVideoAd alloc] initWithPosId:self.posId];
        self.fullscreenAd.delegate = self.delegateObject;
        [self.fullscreenAd loadAdData];
    }
    else {
        NSLog(@"快手SDK不支持插屏半屏");
    }
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    if ([self.fullscreenAd isValid]) {
        [self.fullscreenAd showAdFromRootViewController:rootViewController];
    }
    else {
        NSLog(@"资源未准备好，请稍后再试");
    }
}

- (BOOL)isAdValid {
    return self.fullscreenAd.isValid;
}

- (BOOL)isVideoAd {
    return YES;
}

- (BOOL)videoMuted {
    return self.fullscreenAd.shouldMuted;
}

- (NSInteger)eCPM {
    return self.fullscreenAd.ecpm;
}

//设置实际结算价
- (void)setBidECPM:(NSInteger)price {
    [self.fullscreenAd setBidEcpm:price];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.fullscreenAd reportAdExposureFailed:0 reportParam:nil];
}

@end
