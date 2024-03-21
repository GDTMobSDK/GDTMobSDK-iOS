//
//  BDGDT_RewardVideoAdAdapter.m
//  GDTMobSDK
//
//  Created by Nancy on 2019/6/21.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BDGDT_RewardVideoAdAdapter.h"
#import "BaiduMobAdSDK/BaiduMobAdRewardVideo.h"
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "BDGDT_RewardVideoAdDelegateObject.h"

static NSString *s_appId = nil;

@interface BDGDT_RewardVideoAdAdapter () 

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BaiduMobAdRewardVideo *rewardVideoAd;
@property (nonatomic, strong) BDGDT_RewardVideoAdDelegateObject *delegateObject;
@property (nonatomic, copy) NSString *posId;
@end

@implementation BDGDT_RewardVideoAdAdapter
@synthesize serverSideVerificationOptions = _serverSideVerificationOptions;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (nullable instancetype)initWithAdNetworkConnector:(id<GDTRewardVideoAdNetworkConnectorProtocol>)connector
                                              posId:(nonnull NSString *)posId
                                           {
    if (!connector) {
        return nil;
    }
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAd {
    self.delegateObject = [[BDGDT_RewardVideoAdDelegateObject alloc] init];
    self.delegateObject.connector = self.connector;
    self.delegateObject.adapter = self;
    
    self.rewardVideoAd = [[BaiduMobAdRewardVideo alloc] init];
    self.rewardVideoAd.AdUnitTag = self.posId;
    self.rewardVideoAd.publisherId = s_appId;
    self.rewardVideoAd.enableLocation = NO;
    self.rewardVideoAd.delegate = self.delegateObject;
    self.rewardVideoAd.userID = self.serverSideVerificationOptions.userIdentifier;
    [self.rewardVideoAd load];
}

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController {
    if ([self.rewardVideoAd isReady]) {
        [self.rewardVideoAd showFromViewController:viewController];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isAdValid {
    return [self.rewardVideoAd isReady];
}

- (NSInteger)expiredTimestamp {
    return [[NSDate date] timeIntervalSince1970] + 1800;;
}

- (NSInteger)eCPM {
    return [self.rewardVideoAd getECPMLevel].integerValue;
}

- (void)sendWinNotification:(NSInteger)price {
    [self.rewardVideoAd biddingSuccess:[NSString stringWithFormat:@"%ld", price]];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.rewardVideoAd biddingFail:[NSString stringWithFormat:@"%ld", reason]];
}

@end
