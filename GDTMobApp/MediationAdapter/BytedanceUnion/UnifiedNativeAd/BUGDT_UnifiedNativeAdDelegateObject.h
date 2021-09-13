//
//  BUGDT_UnifiedNativeAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_UnifiedNativeAdDelegateObject : NSObject <BUNativeAdsManagerDelegate>
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol>connector;
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkAdapterProtocol> adapter;
@end

NS_ASSUME_NONNULL_END
