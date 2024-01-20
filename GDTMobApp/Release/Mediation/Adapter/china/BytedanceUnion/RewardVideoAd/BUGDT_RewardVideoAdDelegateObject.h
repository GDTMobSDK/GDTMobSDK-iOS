//
//  BUGDT_RewardVideoAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/12.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_RewardVideoAdDelegateObject : NSObject <BURewardedVideoAdDelegate>
@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>rewardVideoAdConnector;
@property (nonatomic, assign) BOOL adDidLoaded;
@property (nonatomic, assign) NSInteger loadedTime;
@property (nonatomic, weak) id adapter;
@end

NS_ASSUME_NONNULL_END
