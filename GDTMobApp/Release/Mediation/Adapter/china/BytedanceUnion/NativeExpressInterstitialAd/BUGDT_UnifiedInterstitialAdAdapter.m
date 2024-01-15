//
//  BUGDT_UnifiedInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2022/3/11.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedInterstitialAdAdapter.h"
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import <BUAdSDK/BUAdSDK.h>

static CGSize const dislikeSize = {15, 15};
static CGSize const logoSize = {20, 20};
static BOOL s_sdkInitializationSuccess = NO;

#define leftEdge 20
#define titleHeight 40

@interface BUGDT_UnifiedInterstitialAdAdapter ()<BUFullscreenVideoAdDelegate>
@property (nonatomic, strong) BUFullscreenVideoAd *fullscreenVideoAd;
@property (nonatomic, weak) id<GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *slotID;

@end

@implementation BUGDT_UnifiedInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (BUAdSDKManager.appID.length == 0) {
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        configuration.appID = appId;
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                s_sdkInitializationSuccess = success;
            });
        }];
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
    if (self.shouldLoadFullscreenAd) {
        self.fullscreenVideoAd = [[BUFullscreenVideoAd alloc] initWithSlotID:self.slotID];
        self.fullscreenVideoAd.delegate = self;
        [self.fullscreenVideoAd loadAdData];
        return;
    }
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    if (self.shouldShowFullscreenAd) {
        [self.fullscreenVideoAd showAdFromRootViewController:rootViewController];
        return;
    }
}


- (BOOL)isAdValid {
    return YES;
}

- (NSInteger)eCPM {
    if (self.shouldLoadFullscreenAd) {
        if ([self.fullscreenVideoAd.mediaExt objectForKey:@"price"]) {
            return [[self.fullscreenVideoAd.mediaExt objectForKey:@"price"] integerValue];
        }
        return -1;
    }
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if (self.shouldLoadFullscreenAd) {
        if ([self.fullscreenVideoAd.mediaExt objectForKey:@"request_id"]) {
            [res setObject:[self.fullscreenVideoAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
        }
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    if (self.shouldLoadFullscreenAd) {
        [self.fullscreenVideoAd win:@(price)];
        return;
    }
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    if (self.shouldLoadFullscreenAd) {
        [self.fullscreenVideoAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
        return;
    }
}

#pragma mark - BUFullscreenVideoAdDelegate
- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self];
}

- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self error:error];
}

- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {}

- (void)fullscreenVideoAdWillVisible:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialWillExposure:self];
    [self.connector adapter_unifiedInterstitialWillPresentScreen:self];
}

- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidPresentScreen:self];
}

- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialClicked:self];
}

- (void)fullscreenVideoAdWillClose:(BUFullscreenVideoAd *)fullscreenVideoAd {}

- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
}

- (void)fullscreenVideoAdDidPlayFinish:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    if (error) {
        [self.connector adapter_unifiedInterstitialAd:self playerStatusChanged:GDTMediaPlayerStatusError];
    } else {
        [self.connector adapter_unifiedInterstitialAd:self playerStatusChanged:GDTMediaPlayerStatusStoped];
    }
}

- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd {}

- (void)fullscreenVideoAdCallback:(BUFullscreenVideoAd *)fullscreenVideoAd withType:(BUFullScreenVideoAdType)fullscreenVideoAdType {}

@end
