//
//  KSGDT_RewardVideoAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/10/31.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "KSGDT_RewardVideoAdAdapter.h"
#import <KSAdSDK/KSAdSDK.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "KSGDT_RewardVideoAdDelegateObject.h"

@interface KSGDT_RewardVideoAdAdapter()

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>rewardVideoAdConnector;
@property (nonatomic, strong) KSRewardedVideoAd *rewardVideoAd;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) KSGDT_RewardVideoAdDelegateObject *delegateObject;

@end

@implementation KSGDT_RewardVideoAdAdapter
@synthesize serverSideVerificationOptions = _serverSideVerificationOptions;

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

- (instancetype)initWithAdNetworkConnector:(id<GDTRewardVideoAdNetworkConnectorProtocol>)connector
                                     posId:(NSString *)posId
{
    if (!connector) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.rewardVideoAdConnector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAd
{
    self.delegateObject = [[KSGDT_RewardVideoAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.rewardVideoAdConnector = self.rewardVideoAdConnector;
    
    KSRewardedVideoModel *model = [[KSRewardedVideoModel alloc] init];
    model.userId = self.serverSideVerificationOptions.userIdentifier;
    model.extra = self.serverSideVerificationOptions.customRewardString;
    self.rewardVideoAd = [[KSRewardedVideoAd alloc] initWithPosId:self.posId rewardedVideoModel:model];
    self.rewardVideoAd.delegate = self.delegateObject;
    [self.rewardVideoAd loadAdData];
}

- (BOOL)showAdFromRootViewController:(nonnull UIViewController *)viewController {
    if ([self.rewardVideoAd isValid]) {
        return [self.rewardVideoAd showAdFromRootViewController:viewController];
    } else {
        NSLog(@"资源未准备好，请稍后再试");
        return NO;
    }
}

- (BOOL)isAdValid {
    return self.rewardVideoAd.isValid;
}

- (NSInteger)expiredTimestamp {
    return self.delegateObject.loadedTime + 1800;
}

- (NSInteger)eCPM {
    return self.rewardVideoAd.ecpm;
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.rewardVideoAd reportAdExposureFailed:0 reportParam:nil];
}

- (void)sendWinNotification:(NSInteger)price {
    [self.rewardVideoAd setBidEcpm:price];
}

@end
