//
//  BDGDT_SplashAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/4/26.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMobAdSDK/BaiduMobAdSplash.h>
#import "GDTSplashAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_SplashAdDelegateObject : NSObject <BaiduMobAdSplashDelegate>
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, assign, getter=isAdValid) BOOL adValid;
@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id <GDTSplashAdNetworkAdapterProtocol> adapter;

@end

NS_ASSUME_NONNULL_END
