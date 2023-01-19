//
//  BUGDT_SplashAdAdapter.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSplashAdNetworkAdapterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BUGDT_SplashAdAdapter : NSObject  <GDTSplashAdNetworkAdapterProtocol>
- (void)removeAllSubviews;

@end

NS_ASSUME_NONNULL_END
