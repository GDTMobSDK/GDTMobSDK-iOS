//
//  BUGDT_UnifiedNativeDataObjectAdapter.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkAdapterProtocol.h"
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_UnifiedNativeDataObjectAdapter : NSObject <GDTUnifiedNativeAdDataObjectAdapterProtocol, GDTMediaViewAdapterProtocol, BUVideoAdViewDelegate, BUNativeAdDelegate>

- (instancetype)initWithBUNativeAd:(BUNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
