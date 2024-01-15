//
//  BDGDT_UnifiedNativeDataObjectAdapter.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkAdapterProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdNative.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeAdObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_UnifiedNativeDataObjectAdapter : NSObject <GDTUnifiedNativeAdDataObjectAdapterProtocol, GDTMediaViewAdapterProtocol>

- (instancetype)initWithBaiduMobAdNativeAdObject:(BaiduMobAdNativeAdObject *)nativeAdObject;

@end

NS_ASSUME_NONNULL_END
