//
//  KSGDT_NativeExpressAdViewAdapter.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/12.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAdViewAdapterProtocol.h"
#import <KSAdSDK/KSFeedAd.h>
#import "GDTNativeExpressAdNetworkConnectorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_NativeExpressAdViewAdapter : NSObject <GDTNativeExpressAdViewAdapterProtocol>

@property (nonatomic, weak) id<GDTNativeExpressAdNetworkConnectorProtocol> connector;

- (instancetype)initWithFeedAd:(KSFeedAd *)feedAd;

@end

NS_ASSUME_NONNULL_END
