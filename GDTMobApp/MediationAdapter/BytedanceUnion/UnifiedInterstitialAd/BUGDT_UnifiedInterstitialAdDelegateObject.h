//
//  BUGDT_UnifiedInterstitialAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_UnifiedInterstitialAdDelegateObject : NSObject <BUNativeExpresInterstitialAdDelegate, BUFullscreenVideoAdDelegate>
@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol>connector;
@property (nonatomic, assign) BOOL fullscreenAdDidLoad;
@property (nonatomic, weak) id <GDTUnifiedinterstitialAdNetworkAdapterProtocol>adapter;

@end

NS_ASSUME_NONNULL_END
