//
//  BUGDT_RewardVideoAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/6/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BUGDT_RewardVideoAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "BUGDT_RewardVideoAdDelegateObject.h"

@interface BUGDT_RewardVideoAdAdapter()

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>rewardVideoAdConnector;
@property (nonatomic, strong) BURewardedVideoAd *rewardVideoAd;
@property (nonatomic, strong) BUGDT_RewardVideoAdDelegateObject *delegateObject;
@property (nonatomic, copy) NSString *podId;

@end

@implementation BUGDT_RewardVideoAdAdapter
@synthesize serverSideVerificationOptions = _serverSideVerificationOptions;

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

- (nullable instancetype)initWithAdNetworkConnector:(nonnull id<GDTRewardVideoAdNetworkConnectorProtocol>)connector
                                              posId:(nonnull NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.rewardVideoAdConnector = connector;
        self.podId = posId;
    }
    
    return self;
}

- (void)loadAd {
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = self.serverSideVerificationOptions.userIdentifier;
    
    self.rewardVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:self.podId rewardedVideoModel:model];
    
    self.delegateObject = [[BUGDT_RewardVideoAdDelegateObject alloc] init];
    self.delegateObject.rewardVideoAdConnector = self.rewardVideoAdConnector;
    self.delegateObject.adapter = self;
    self.rewardVideoAd.delegate = self.delegateObject;
    
    [self.rewardVideoAd loadAdData];
}

- (BOOL)showAdFromRootViewController:(nonnull UIViewController *)viewController {
    if (self.delegateObject.adDidLoaded) {
        return [self.rewardVideoAd showAdFromRootViewController:viewController];
    } else {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:[NSError new]];
        return NO;
    }
}

- (BOOL)isAdValid {
    return self.delegateObject.adDidLoaded;
}

- (NSInteger)expiredTimestamp {
    return self.delegateObject.loadedTime + 1800;
}

- (NSInteger)eCPM {
    if ([self.rewardVideoAd.mediaExt objectForKey:@"price"]) {
        return [[self.rewardVideoAd.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.rewardVideoAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.rewardVideoAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

@end
