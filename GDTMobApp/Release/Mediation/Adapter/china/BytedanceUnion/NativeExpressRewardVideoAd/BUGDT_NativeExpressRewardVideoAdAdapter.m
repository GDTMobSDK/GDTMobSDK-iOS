//
//  BUGDT_NativeExpressRewardVideoAdAdapter.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/4/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressRewardVideoAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "MediationAdapterUtil.h"
#import "BUGDT_NativeExpressRewardVideoAdDelegateObject.h"
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_NativeExpressRewardVideoAdAdapter ()

@property (nonatomic, weak) id<GDTRewardVideoAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) BUGDT_NativeExpressRewardVideoAdDelegateObject *delegateObject;

@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *rewardAd;

@end

@implementation BUGDT_NativeExpressRewardVideoAdAdapter

@synthesize videoMuted;

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

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId {
    if (!connector || ![connector conformsToProtocol:@protocol(GDTRewardVideoAdNetworkConnectorProtocol)]) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (BOOL)isAdValid {
    return self.delegateObject.isAdValid;
}

- (NSInteger)expiredTimestamp {
    return self.delegateObject.loadedTime + 1800;
}

- (void)loadAd {
    BUNativeExpressRewardedVideoAd *ad = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:self.posId rewardedVideoModel:[BURewardedVideoModel new]];
    BUGDT_NativeExpressRewardVideoAdDelegateObject *delegateObject = [BUGDT_NativeExpressRewardVideoAdDelegateObject new];
    delegateObject.connector = self.connector;
    delegateObject.adapter = self;
    
    ad.delegate = delegateObject;
    [ad loadAdData];
    
    self.rewardAd = ad;
    self.delegateObject = delegateObject;
}

- (BOOL)showAdFromRootViewController:(nonnull UIViewController *)rootViewController {
    if (self.delegateObject.isAdValid) {
        return [self.rewardAd showAdFromRootViewController:rootViewController];
    } else {
        [self.connector adapter_rewardVideoAd:self didFailWithError:nil];
        return NO;
    }
}

- (NSInteger)eCPM {
    if ([self.rewardAd.mediaExt objectForKey:@"price"]) {
        return [[self.rewardAd.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.rewardAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.rewardAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.rewardAd win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.rewardAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
}

@end
