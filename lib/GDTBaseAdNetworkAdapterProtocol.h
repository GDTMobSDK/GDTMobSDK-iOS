//
//  GDTBaseAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTAdProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GDTBaseAdNetworkAdapterProtocol <GDTAdProtocol>

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr;

- (nullable instancetype)initWithAdNetworkConnector:(id)connector
                                     posId:(NSString *)posId;


@optional

- (NSInteger)eCPM;
- (NSString *)eCPMLevel;
- (BOOL)isContractAd;

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price;

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *__nullable)adnId;

//设置实际结算价
- (void)setBidECPM:(NSInteger)price;

@end

@protocol GDTBaseAdNetworkConnectorProtocol <NSObject>

@optional
- (void)adapter_adComplainSuccess:(id)adapter;

@end

NS_ASSUME_NONNULL_END
