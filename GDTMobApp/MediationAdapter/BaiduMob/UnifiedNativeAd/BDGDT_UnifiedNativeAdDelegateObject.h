//
//  BDGDT_UnifiedNativeAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/4/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_UnifiedNativeAdDelegateObject : NSObject <BaiduMobAdNativeAdDelegate>
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol>connector;
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkAdapterProtocol> adapter;
@end

NS_ASSUME_NONNULL_END
