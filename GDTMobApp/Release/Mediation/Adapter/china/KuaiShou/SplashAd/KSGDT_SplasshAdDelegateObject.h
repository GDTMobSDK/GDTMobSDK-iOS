//
//  KSGDT_SplasshAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSplashAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_SplasshAdDelegateObject : NSObject <KSSplashAdViewDelegate>
@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id <GDTSplashAdNetworkAdapterProtocol> adapter;
@property (nonatomic, assign) BOOL splashAdContentLoaded;
@end

NS_ASSUME_NONNULL_END
