//
//  GDTNativeExpressAdViewAdapterProtocol.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/16.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef GDTNativeExpressAdViewAdapterProtocol_h
#define GDTNativeExpressAdViewAdapterProtocol_h
@class GDTNativeExpressAdView;
@protocol GDTAdProtocol;

@protocol GDTNativeExpressAdViewAdapterProtocol <GDTAdProtocol>

@property (nonatomic, weak) GDTNativeExpressAdView *gdtExpressAdView;

@property (nonatomic, assign, readonly) BOOL isReady;
@property (nonatomic, assign, readonly) BOOL isVideoAd;
@property (nonatomic, weak) UIViewController *controller;

- (void)resize;

- (BOOL)isAdValid;
- (UIView *)adView;

- (void)render;
- (CGFloat)videoDuration;
- (CGFloat)videoPlayTime;
- (NSInteger)eCPM;
- (NSString *)eCPMLevel;

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price;

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId;

//设置实际结算价
- (void)setBidECPM:(NSInteger)price;

@end

#endif /* GDTNativeExpressAdViewAdapterProtocol_h */
