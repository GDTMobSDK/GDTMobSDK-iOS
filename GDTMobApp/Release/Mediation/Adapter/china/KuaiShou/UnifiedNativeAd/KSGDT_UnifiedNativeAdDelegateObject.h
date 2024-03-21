//
//  KSGDT_UnifiedNativeAdDelegateObject.h
//  GDTMobApp
//
//  Created by Nancy on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSAdSDK.h>
#import "KSGDT_UnifiedNativeDataObjectAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSGDT_UnifiedNativeAdDelegateObject : NSObject <KSNativeAdsManagerDelegate>
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol> connector;
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkAdapterProtocol> adapter;
@property (nonatomic, strong) NSArray <KSGDT_UnifiedNativeDataObjectAdapter *> *nativeAdArray;
@end

NS_ASSUME_NONNULL_END
