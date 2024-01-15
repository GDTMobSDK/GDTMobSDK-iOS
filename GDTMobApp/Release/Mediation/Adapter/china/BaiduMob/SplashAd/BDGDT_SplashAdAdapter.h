//
//  BDGDT_SplashAdAdapter.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTSplashAdNetworkAdapterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDGDT_SplashAdAdapter : NSObject <GDTSplashAdNetworkAdapterProtocol>

- (void)removeSplash;

@end

NS_ASSUME_NONNULL_END
