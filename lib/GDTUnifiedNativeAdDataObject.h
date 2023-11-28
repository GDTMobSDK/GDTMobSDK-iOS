//
//  GDTUnifiedNativeAdDataObject.h
//  GDTMobSDK
//
//  Created by nimomeng on 2018/10/10.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDTVideoConfig.h"
#import "GDTSDKDefines.h"
#import "GDTAdProtocol.h"

typedef NS_ENUM(NSInteger, GDTVastAdEventType) {
    GDTVastAdEventTypeUnknow,
    GDTVastAdEventTypeLoaded,
    GDTVastAdEventTypeStarted,
    GDTVastAdEventTypeFirstQuartile,
    GDTVastAdEventTypeMidPoint,
    GDTVastAdEventTypeThirdQuartile,
    GDTVastAdEventTypeComplete,
    GDTVastAdEventTypeAllAdsComplete,
    GDTVastAdEventTypeExposed,
    GDTVastAdEventTypeClicked,
};


@interface GDTUnifiedNativeAdDataObject : NSObject <GDTAdProtocol>

/**
 广告标题
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 广告描述
 */
@property (nonatomic, copy, readonly) NSString *desc;

/**
 素材宽度，单图广告代表大图 imageUrl 宽度、多图广告代表小图 mediaUrlList 宽度
 */
@property (nonatomic, readonly) NSInteger imageWidth;

/**
 素材高度，单图广告代表大图 imageUrl 高度、多图广告代表小图 mediaUrlList 高度
 */
@property (nonatomic, readonly) NSInteger imageHeight;

/**
 应用类广告App 图标Url
 */
@property (nonatomic, copy, readonly) NSString *iconUrl;

/**
 广告大图Url, 建议使用 bindImageViews:placeholder: 方法替代
 */
@property (nonatomic, copy, readonly) NSString *imageUrl;

/**
 三小图广告的图片Url集合, 建议使用 bindImageViews:placeholder: 方法替代
 */
@property (nonatomic, copy, readonly) NSArray *mediaUrlList;

/**
 应用类广告的星级（5星制度）
 */
@property (nonatomic, readonly) CGFloat appRating;

/**
 应用类广告的价格
 */
@property (nonatomic, strong, readonly) NSNumber *appPrice;

/**
 是否为应用类广告
 */
@property (nonatomic, readonly) BOOL isAppAd;

/**
 是否为视频广告
 */
@property (nonatomic, readonly) BOOL isVideoAd;

/**
 是否为三小图广告
 */
@property (nonatomic, readonly) BOOL isThreeImgsAd;

/**
 是否为微信原生页广告 (可针对此广告类型来控制按钮展示文案为"去微信看看")
 */
@property (nonatomic, readonly) BOOL isWechatCanvasAd;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
@property (nonatomic, readonly) NSInteger eCPM;

/**
 返回广告的eCPM等级
 
 @return 成功返回一个包含数字的string，@""或nil表示无权限或后台异常
 */
@property (nonatomic, readonly) NSString *eCPMLevel;

/**
 广告对应的按钮展示文案
 此字段可能为空
 */
@property (nonatomic, readonly) NSString *buttonText;

/**
 广告对应的CTA文案，自定义CTA视图时建议使用此字段
 广告对应的callToAction文案，比如“立即预约”或“电话咨询”, 自定义callToAction视图时建议使用此字段

 该字段在部分广告类型中可能为空
 */
@property (nonatomic, readonly) NSString *callToAction;

/**
返回广告是否可以跳过，用于做前贴片场景

@return YES 表示可跳过、NO 表示不可跳过
*/
@property (nonatomic, readonly) BOOL skippable;

/**
 视频广告播放配置
 */
@property (nonatomic, strong) GDTVideoConfig *videoConfig;

/**
 * 视频广告时长，单位 ms
 */
@property (nonatomic, readonly) CGFloat duration;

/**
 *  VAST Tag Url，可能为空。
 */
@property (nonatomic, copy, readonly) NSString *vastTagUrl;

/**
 * VAST Content，可能为空。
 */
@property (nonatomic, copy, readonly) NSString *vastContent;

/**
 * 是否为 VAST 广告
 */
@property (nonatomic, assign, readonly) BOOL isVastAd;

/**
 *  广告是否有效，以下情况会返回NO，建议在展示广告之前判断，否则会影响计费或展示失败
 *  a.广告过期
 */
@property (nonatomic, readonly) BOOL isAdValid;

/**
 判断两个自渲染2.0广告数据是否相等

 @param dataObject 需要对比的自渲染2.0广告数据对象
 @return YES or NO
 */
- (BOOL)equalsAdData:(GDTUnifiedNativeAdDataObject *)dataObject;

/**
 * 绑定展示的图片视图
 *
 * @param imageViews     进行渲染的 imageView
 * @param placeholder     图片加载过程中的占位图
 */
- (void)bindImageViews:(NSArray<UIImageView *> *)imageViews placeholder:(UIImage *)placeholder;

/**
 *  竞胜之后调用, 需要在调用广告 show 之前调用
 *
 *  @param winInfo 字典类型，支持的key为以下，注：key是个宏定义，在GDTAdProtocol.h中有定义，可以参考demo中的使用方法
 *  GDT_M_W_E_COST_PRICE：竞胜价格 (单位: 分)，值类型为NSNumber *
 *  GDT_M_W_H_LOSS_PRICE：最高失败出价，值类型为NSNumber  *
 *
 */
- (void)sendWinNotificationWithInfo:(NSDictionary *)winInfo;

/**
 *  竞败之后调用
 *
 *  @pararm lossInfo 竞败信息，字典类型，支持的key有
 *  GDT_M_L_WIN_PRICE ：竞胜价格 (单位: 分)，值类型为NSNumber *
 *  GDT_M_L_LOSS_REASON ：优量汇广告竞败原因，竞败原因参考枚举GDTAdBiddingLossReason中的定义，值类型为NSNumber *
 *  GDT_M_ADNID  ：竞胜方渠道ID，值类型为NSString *
 */
- (void)sendLossNotificationWithInfo:(NSDictionary *)lossInfo;

/**
 *  S2S bidding 竞胜之后调用, 需要在调用广告 show 之前调用
 *  @param eCPM - 曝光扣费, 单位分，若优量汇竞胜，在广告曝光时回传，必传
 *  针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费，当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格.
 */
- (void)setBidECPM:(NSInteger)eCPM;

@end
