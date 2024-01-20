//
//  BUGDT_SplashAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import "GDTSplashAdNetworkConnectorProtocol.h"
#import "BUGDT_SplashAdAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_SplashAdDelegateObject : NSObject <BUSplashAdDelegate>
@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id <GDTSplashAdNetworkAdapterProtocol> adapter;

@end

NS_ASSUME_NONNULL_END
