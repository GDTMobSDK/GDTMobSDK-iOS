//
//  BUGDT_NativeExpressAdViewAdapter.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAdViewAdapterProtocol.h"
#import <BUAdSDK/BUNativeExpressAdView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_NativeExpressAdViewAdapter : NSObject <GDTNativeExpressAdViewAdapterProtocol>

- (instancetype)initWithBUNativeExpressAdView:(BUNativeExpressAdView *)buAdView;

@end

NS_ASSUME_NONNULL_END
