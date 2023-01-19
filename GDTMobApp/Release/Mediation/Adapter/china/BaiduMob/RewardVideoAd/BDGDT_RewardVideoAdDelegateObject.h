//
//  BDGDT_RewardVideoAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/4/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdSDK/BaiduMobAdRewardVideo.h"
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_RewardVideoAdDelegateObject : NSObject <BaiduMobAdRewardVideoDelegate>
@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>connector;
@property (nonatomic, weak) id <GDTRewardVideoAdNetworkAdapterProtocol>adapter;
@end

NS_ASSUME_NONNULL_END
