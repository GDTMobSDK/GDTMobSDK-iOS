//
//  KSGDT_UnifiedInterstitialAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_UnifiedInterstitialAdDelegateObject : NSObject <KSFullscreenVideoAdDelegate, KSInterstitialAdDelegate>
@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id <GDTUnifiedinterstitialAdNetworkAdapterProtocol> adapter;
@end

NS_ASSUME_NONNULL_END
