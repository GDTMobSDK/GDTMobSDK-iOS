//
//  BUGDT_ExpressInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2022/3/9.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "BUGDT_ExpressInterstitialAdAdapter.h"
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import <BUAdSDK/BUAdSDK.h>
#import "MediationAdapterUtil.h"

#define Ad_Width 600
#define Ad_Height 900

@interface BUGDT_ExpressInterstitialAdAdapter () <BUNativeExpressFullscreenVideoAdDelegate, BUNativeExpresInterstitialAdDelegate>
@property (nonatomic, weak) id<GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *slotID;
@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullScreenVideoAd;
@end

@implementation BUGDT_ExpressInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (BUAdSDKManager.appID.length == 0) {
        if ([appId length] > 0) {
            [BUAdSDKManager setAppID:appId];
        }
        else {
            NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
            [BUAdSDKManager setAppID:params[@"appid"]];
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
        self.slotID = posId;
    }
    
    return self;
}

- (void)loadAd {
    if (self.shouldLoadFullscreenAd) {
        self.fullScreenVideoAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:self.slotID];
        self.fullScreenVideoAd.delegate = self;
        [self.fullScreenVideoAd loadAdData];
        return;
    }
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
    CGFloat height = width/Ad_Width*Ad_Height;
    self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:self.slotID adSize:CGSizeMake(width, height)];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdData];
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    if (self.shouldShowFullscreenAd) {
        [self.fullScreenVideoAd showAdFromRootViewController:rootViewController];
        return;
    }
    [self.interstitialAd showAdFromRootViewController:rootViewController];
}

- (BOOL)isAdValid {
    if (self.shouldLoadFullscreenAd) {
        return YES;
    }
    return [self.interstitialAd isAdValid];
}

- (NSInteger)eCPM {
    if (self.shouldLoadFullscreenAd) {
        if ([self.fullScreenVideoAd.mediaExt objectForKey:@"price"]) {
            return [[self.fullScreenVideoAd.mediaExt objectForKey:@"price"] integerValue];
        }
        return -1;
    }
    if ([self.interstitialAd.mediaExt objectForKey:@"price"]) {
        return [[self.interstitialAd.mediaExt objectForKey:@"price"] integerValue];
    }
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if (self.shouldLoadFullscreenAd) {
        if ([self.fullScreenVideoAd.mediaExt objectForKey:@"request_id"]) {
            [res setObject:[self.fullScreenVideoAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
        }
    }
    if ([self.interstitialAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.interstitialAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    if (self.shouldLoadFullscreenAd) {
        [self.fullScreenVideoAd win:@(price)];
        return;
    }
    [self.interstitialAd win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    if (self.shouldLoadFullscreenAd) {
        [self.fullScreenVideoAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
        return;
    }
    [self.interstitialAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
}

//设置实际结算价
- (void)setBidECPM:(NSInteger)price {
    if (self.shouldLoadFullscreenAd) {
        [self.fullScreenVideoAd setPrice:@(price)];
        return;
    }
    [self.interstitialAd setPrice:@(price)];
}

#pragma mark - BUNativeExpressFullscreenVideoAdDelegate
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self];
}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self error:error];
}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialWillExposure:self];
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialClicked:self];
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {}

- (void)nativeExpressFullscreenVideoAdCallback:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd withType:(BUNativeExpressFullScreenAdType) nativeExpressVideoAdType {}

- (void)nativeExpressFullscreenVideoAdDidCloseOtherController:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd interactionType:(BUInteractionType)interactionType {}

#pragma mark - BUNativeExpresInterstitialAdDelegate
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self];
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError * __nullable)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self error:error];
}

- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError * __nullable)error {}

- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.connector adapter_unifiedInterstitialWillExposure:self];
}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.connector adapter_unifiedInterstitialClicked:self];
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
}

- (void)nativeExpresInterstitialAdDidCloseOtherController:(BUNativeExpressInterstitialAd *)interstitialAd interactionType:(BUInteractionType)interactionType {}

@end
