//
//  BUGDT_NativeExpressInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/4/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressInterstitialAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "BUGDT_NativeExpressInterstitialAdDelegateObject.h"

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_NativeExpressInterstitialAdAdapter ()

@property (nonatomic, weak) id<GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullscreenAd;
@property (nonatomic, copy) NSString *slotID;
@property (nonatomic, strong) BUGDT_NativeExpressInterstitialAdDelegateObject *delegateObject;

@end

@implementation BUGDT_NativeExpressInterstitialAdAdapter

@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (BUAdSDKManager.appID.length == 0) {
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        configuration.appID = appId;
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            s_sdkInitializationSuccess = success;
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
    self.delegateObject = [[BUGDT_NativeExpressInterstitialAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    
    self.fullscreenAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:self.slotID];
    self.fullscreenAd.delegate = self.delegateObject;
    [self.fullscreenAd loadAdData];
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    [self.fullscreenAd showAdFromRootViewController:rootViewController];
}

- (BOOL)isAdValid {
    return self.delegateObject.fullscreenAdDidLoad;
}

- (NSInteger)eCPM {
    if ([self.fullscreenAd.mediaExt objectForKey:@"price"]) {
        return [[self.fullscreenAd.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.fullscreenAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.fullscreenAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.fullscreenAd win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.fullscreenAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
}


@end
