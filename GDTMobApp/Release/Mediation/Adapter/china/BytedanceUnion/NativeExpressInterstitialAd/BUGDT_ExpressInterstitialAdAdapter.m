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

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_ExpressInterstitialAdAdapter () <BUNativeExpressFullscreenVideoAdDelegate>
@property (nonatomic, weak) id<GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *slotID;
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullScreenVideoAd;
@end

@implementation BUGDT_ExpressInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (BUAdSDKManager.appID.length == 0) {
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        configuration.appID = appId;
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            s_sdkInitializationSuccess = success;
        }];
    } else {
        s_sdkInitializationSuccess = YES;
    }
}

- (BOOL)sdkInitializationSuccess {
    return s_sdkInitializationSuccess;
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
    self.fullScreenVideoAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:self.slotID];
    self.fullScreenVideoAd.delegate = self;
    [self.fullScreenVideoAd loadAdData];
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    [self.fullScreenVideoAd showAdFromRootViewController:rootViewController];
}

- (BOOL)isAdValid {
    return YES;
}

- (NSInteger)eCPM {
    if ([self.fullScreenVideoAd.mediaExt objectForKey:@"price"]) {
        return [[self.fullScreenVideoAd.mediaExt objectForKey:@"price"] integerValue];
    }
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.fullScreenVideoAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.fullScreenVideoAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.fullScreenVideoAd win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.fullScreenVideoAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
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

@end
