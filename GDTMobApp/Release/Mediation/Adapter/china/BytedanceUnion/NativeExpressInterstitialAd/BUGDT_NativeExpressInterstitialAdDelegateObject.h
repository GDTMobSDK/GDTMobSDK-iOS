//
//  BUGDT_NativeExpressInterstitialAdDelegateObject.h
//  GDTMobApp
//
//  Created by zhangzilong on 2021/4/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_NativeExpressInterstitialAdDelegateObject : NSObject <BUNativeExpressFullscreenVideoAdDelegate>

@property (nonatomic, weak) id<GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id<GDTUnifiedinterstitialAdNetworkAdapterProtocol> adapter;
@property (nonatomic, assign) BOOL fullscreenAdDidLoad;

@end

NS_ASSUME_NONNULL_END
