//
//  BDGDT_NativeExpressAdViewAdapter.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAdViewAdapterProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdNativeAdObject.h>
#import "GDTNativeExpressAdNetworkConnectorProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdSmartFeedView.h>


NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_NativeExpressAdViewAdapter : NSObject <GDTNativeExpressAdViewAdapterProtocol>

@property (nonatomic, strong) BaiduMobAdNativeAdObject *bdAdObject;

@property (nonatomic, weak) id<GDTNativeExpressAdNetworkConnectorProtocol> connector;

- (instancetype)initWithBDNativeAdView:(BaiduMobAdSmartFeedView *)bdAdView object:(BaiduMobAdNativeAdObject *)object;

@end

NS_ASSUME_NONNULL_END
