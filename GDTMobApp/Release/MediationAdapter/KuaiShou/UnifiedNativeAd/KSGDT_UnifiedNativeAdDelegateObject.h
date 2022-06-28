//
//  KSGDT_UnifiedNativeAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_UnifiedNativeAdDelegateObject : NSObject <KSNativeAdsManagerDelegate>
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkAdapterProtocol> adapter;
@end

NS_ASSUME_NONNULL_END
