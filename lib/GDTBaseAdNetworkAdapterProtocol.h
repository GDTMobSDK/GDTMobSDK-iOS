//
//  GDTBaseAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTAdProtocol.h"
#import "GDTServerBiddingResult.h"
#import "GDTPrivacyConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GDTBaseAdNetworkAdapterProtocol <GDTAdProtocol>

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr;

+ (void)updatePrivacyConfig:(GDTPrivacyConfiguration *)privacyConfig;

- (nullable instancetype)initWithAdNetworkConnector:(id)connector
                                     posId:(NSString *)posId;

- (NSString *)bidderToken;

//SDK是否初始化成功
- (BOOL)sdkInitializationSuccess;

- (NSInteger)eCPM;

- (NSString *)adnSDKVersion;

@optional

- (NSString *)eCPMLevel;
- (BOOL)isContractAd;

- (void)setServerBiddingResponse:(GDTServerBiddingResult *)result;

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price;

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *__nullable)adnId;

//触发了展示回调后发送可计费通知
- (void)sendExposeNotification:(NSInteger)auctionPrice;

//设置实际结算价
- (void)setBidECPM:(NSInteger)price;

@end

@protocol GDTBaseAdNetworkConnectorProtocol <NSObject>

@optional
- (void)adapter_adComplainSuccess:(id)adapter;

@end

NS_ASSUME_NONNULL_END
