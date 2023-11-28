//
//  GDTUnifiedNativeAdView.h
//  GDTMobSDK
//
//  Created by nimomeng on 2018/10/10.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTLogoView.h"
#import "GDTMediaView.h"
#import "GDTUnifiedNativeAdDataObject.h"
#import "GDTSDKDefines.h"
#import "GDTVideoAdReporter.h"

@class GDTUnifiedNativeAdView;

//视频广告时长Key
extern NSString* const kGDTUnifiedNativeAdKeyVideoDuration;

@protocol GDTUnifiedNativeAdViewDelegate <GDTAdDelegate
>

@optional
/**
 广告曝光回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 广告点击回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 广告详情页关闭回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 当点击应用下载或者广告调用系统程序打开时调用
 
 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 广告详情页面即将展示回调

 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView;


/**
 视频广告播放状态更改回调

 @param nativeExpressAdView GDTUnifiedNativeAdView 实例
 @param status 视频广告播放状态
 @param userInfo 视频广告信息
 */
- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo;

@end

@interface GDTUnifiedNativeAdView : UIView

/**
 绑定的数据对象
 */
@property (nonatomic, strong, readonly) GDTUnifiedNativeAdDataObject *dataObject;

/**
 视频广告的媒体View，绑定数据对象后自动生成，可自定义布局
 */
@property (nonatomic, strong, readonly) GDTMediaView *mediaView;

/**
 腾讯广告 LogoView，自动生成，可自定义布局
 */
@property (nonatomic, strong, readonly) GDTLogoView *logoView;

/**
 广告 View 时间回调对象
 */
@property (nonatomic, weak) id<GDTUnifiedNativeAdViewDelegate> delegate;

/**
 *  viewControllerForPresentingModalView
 *  详解：开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *viewController;


/**
 * 自定义视频播放器视频播放状态上报器，不能与GDTMediaView同时使用
 */
@property (nonatomic, strong, readonly, nullable) id<GDTVideoAdReporter> videoAdReporter;

/**
 * 当使用自定义播放器进行播放时，设置广告的容器，此时将不再以GDTUnifiedNativeAdView当作广告容器，
 * 当不能使用自定义播放器时，设置此属性无效
 */
@property (nonatomic, weak) UIView * _Nullable customPlayerContainer;

/**
 自渲染2.0视图注册方法
 
 @warning 调用方法之前请先判断[dataObject isAdValid]是否为YES，当为NO时调用不生效
 @warning 需要注意的是 -[GDTUnifiedNativeAdView registerDataObject:clickableViews:]方法需要避免重复多次调用的情况
 @warning 当广告不需要展示并且销毁的时候，需要调用 -[GDTUnifiedNativeAdView unregisterDataObject]方法，即registerDataObject方法需要与unregisterDataObject方法成对调用
 
 @param dataObject 数据对象，必传字段
 @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
 */
- (void)registerDataObject:(GDTUnifiedNativeAdDataObject *_Nonnull)dataObject
            clickableViews:(NSArray<UIView *> *_Nonnull)clickableViews;


/**
 自渲染2.0视图注册方法
 
 @warning 调用方法之前请先判断[dataObject isAdValid]是否为YES，当为NO时调用不生效
 @warning 需要注意的是 -[GDTUnifiedNativeAdView registerDataObject:clickableViews:customClickableViews:]方法需要避免重复多次调用的情况
 @warning 当广告不需要展示并且销毁的时候，需要调用 -[GDTUnifiedNativeAdView unregisterDataObject]方法，即registerDataObject方法需要与unregisterDataObject方法成对调用
 
 @param dataObject 数据对象，必传字段
 @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
 @param customClickableViews 可点击的视图数组，与clickableViews的区别是：在视频广告中当dataObject中的videoConfig的detailPageEnable为YES时，点击后直接进落地页而非视频详情页，除此条件外点击行为与clickableViews保持一致
 */
- (void)registerDataObject:(GDTUnifiedNativeAdDataObject *_Nonnull)dataObject
            clickableViews:(NSArray<UIView *> *_Nonnull)clickableViews customClickableViews:(NSArray <UIView *> *_Nullable)customClickableViews;

/**
 注册可点击的callToAction视图的方法
 建议开发者使用GDTUnifiedNativeAdDataObject中的callToAction字段来创建视图，并取代自定义的下载或打开等button,
 调用此方法之前必须先调用registerDataObject:clickableViews
 @param callToActionView CTA视图, 系统自动处理点击事件
 */
- (void)registerClickableCallToActionView:(UIView *_Nonnull)callToActionView;

/**
 注销数据对象，在 tableView、collectionView 等场景需要复用 GDTUnifiedNativeAdView 时，
 需要在合适的时机，例如 cell 的 prepareForReuse 方法内执行 unregisterDataObject 方法，
 将广告对象与 GDTUnifiedNativeAdView 解绑，具体可参考示例 demo 的 UnifiedNativeAdBaseTableViewCell 类
 */
- (void)unregisterDataObject;

@end



