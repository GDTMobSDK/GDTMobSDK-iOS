//
//  KSGDT_UnifiedNativeDataObjectAdapter.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/7.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkAdapterProtocol.h"
#import <KSAdSDK/KSAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_UnifiedNativeDataObjectAdapter : NSObject <GDTUnifiedNativeAdDataObjectAdapterProtocol, GDTMediaViewAdapterProtocol,KSNativeAdDelegate>

- (instancetype)initWithKSNativeAd:(KSNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
