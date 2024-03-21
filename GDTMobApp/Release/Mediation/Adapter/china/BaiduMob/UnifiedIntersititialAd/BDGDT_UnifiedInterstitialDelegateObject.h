//
//  BDGDT_UnifiedInterstitialDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/4/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMobAdSDK/BaiduMobAdExpressInterstitial.h>
#import <BaiduMobAdSDK/BaiduMobAdExpressFullScreenVideo.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_UnifiedInterstitialDelegateObject : NSObject <BaiduMobAdExpressIntDelegate, BaiduMobAdExpressFullScreenVideoDelegate>
@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol>connector;
@property (nonatomic, assign) BOOL fullscreenAdDidLoad;
@property (nonatomic, weak) id <GDTUnifiedinterstitialAdNetworkAdapterProtocol>adapter;
@property (nonatomic, copy) NSString *appId;
@end

NS_ASSUME_NONNULL_END
