//
//  KSGDT_RewardVideoAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSAdSDK/KSAdSDK.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_RewardVideoAdDelegateObject : NSObject <KSRewardedVideoAdDelegate>

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>rewardVideoAdConnector;
@property (nonatomic, weak) id <GDTRewardVideoAdNetworkAdapterProtocol>adapter;
@property (nonatomic, assign) NSInteger loadedTime;

@end

NS_ASSUME_NONNULL_END
