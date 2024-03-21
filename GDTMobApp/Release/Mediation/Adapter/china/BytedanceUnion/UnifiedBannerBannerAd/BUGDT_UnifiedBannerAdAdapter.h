//
//  BUGDT_UnifiedBannerAdAdapter.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/7/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedBannerAdNetworkAdapterProtocol.h"
#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedBannerView.h"

NS_ASSUME_NONNULL_BEGIN

// 推荐选择穿山甲平台640*100尺寸，与优量汇尺寸保持一致
@interface BUGDT_UnifiedBannerAdAdapter : NSObject<GDTUnifiedBannerAdNetworkAdapterProtocol>

@end

NS_ASSUME_NONNULL_END
