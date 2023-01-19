//
//  GDTAdProtocol.h
//  GDTMobApp
//
//  Created by rowanzhang on 2021/12/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef GDTAdProtocol_h
#define GDTAdProtocol_h

#define GDT_REQ_ID_KEY @"request_id"
#define GDT_M_W_E_COST_PRICE @"expectCostPrice"
#define GDT_M_W_H_LOSS_PRICE @"highestLossPrice"
#define GDT_M_L_WIN_PRICE @"winPrice"
#define GDT_M_L_LOSS_REASON @"lossReason"
#define GDT_M_ADNID  @"adnId"


@protocol GDTAdProtocol <NSObject>

@optional
- (NSDictionary *)extraInfo;

/**
 *  竞胜之后调用, 需要在调用广告 show 之前调用，旧的- (void)sendWinNotificationWithPrice:(NSInteger)price已废弃
 *
 *  @param winInfo，竞胜信息 字典类型，支持的key为以下，注：key是个宏，在GDTAdProtocol.h中有定义，可以参考demo中的使用方法

 *  GDT_M_W_E_COST_PRICE：竞胜价格 (单位: 分)，值类型为NSNumber *
 *  GDT_M_W_H_LOSS_PRICE：最高失败出价，值类型为NSNumber  *
 *
 */
- (void)sendWinNotificationWithInfo:(NSDictionary *)winInfo;

/**
 *  竞败之后或未参竞调用，旧的- (void)sendLossNotificationWithWinnerPrice:(NSInteger)price lossReason:(GDTAdBiddingLossReason)reason winnerAdnID:(NSString *)adnID已废弃
 *
 *  @pararm lossInfo 竞败信息，字典类型，注：key是个宏，在GDTAdProtocol.h中有定义，可以参考demo中的使用方法
 *  GDT_M_L_WIN_PRICE ：竞胜价格 (单位: 分)，值类型为NSNumber *，选填
 *  GDT_M_L_LOSS_REASON ：优量汇广告竞败原因，竞败原因参考枚举GDTAdBiddingLossReason中的定义，值类型为NSNumber *，必填
 *  GDT_M_ADNID  ：竞胜方渠道ID，值类型为NSString *，必填
 */
- (void)sendLossNotificationWithInfo:(NSDictionary *)lossInfo;

@end

@protocol GDTAdDelegate <NSObject>

@optional
/**
  投诉成功回调
  @params ad 广告对象实例
 */
- (void)gdtAdComplainSuccess:(id)ad;

@end
#endif /* GDTAdProtocol_h */
