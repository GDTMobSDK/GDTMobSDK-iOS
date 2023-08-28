//
//  BDGDT_UnifiedNativeDataObjectAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BDGDT_UnifiedNativeDataObjectAdapter.h"
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdVideoView.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeAdView.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeVideoView.h>

@interface BDGDT_UnifiedNativeDataObjectAdapter() <BaiduMobAdNativeInterationDelegate>

@property (nonatomic, strong) BaiduMobAdNativeAdObject *nativeAdObject;
@property (nonatomic, strong) BaiduMobAdNativeVideoView *videoView;
@property (nonatomic, strong) GDTVideoConfig *buVideoConfig;
@property (nonatomic, strong) BaiduMobAdNativeAdView *nativeAdView;
@property (nonatomic, weak) id <GDTUnifiedNativeAdDataObjectConnectorProtocol> connector;

@end

@implementation BDGDT_UnifiedNativeDataObjectAdapter
@synthesize duration;

- (instancetype)initWithBaiduMobAdNativeAdObject:(BaiduMobAdNativeAdObject *)nativeAdObject
{
    self = [super init];
    if (self) {
        self.nativeAdObject = nativeAdObject;
        self.nativeAdObject.interationDelegate = self;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - GDTUnifiedNativeAdDataObjectAdapterProtocol
- (NSString *)title
{
    return self.nativeAdObject.text;
}

- (NSString *)desc
{
    return self.nativeAdObject.title;
}

- (NSString *)imageUrl
{
    return self.nativeAdObject.mainImageURLString;
}

- (NSString *)iconUrl
{
    return self.nativeAdObject.iconImageURLString;
}

- (NSString *)buttonText
{
    return self.nativeAdObject.actButtonString;
}

- (BOOL)isVideoAd
{
    return (self.nativeAdObject.materialType == VIDEO);
}

- (NSArray *)mediaUrlList
{
    return self.nativeAdObject.morepics;
}

- (CGFloat)appRating
{
    return 0;
}

- (NSNumber *)appPrice
{
    return @(0);
}

- (BOOL)isAppAd
{
    return (self.nativeAdObject.actType == BaiduMobNativeAdActionTypeDL);
}

- (BOOL)isThreeImgsAd
{
    return self.nativeAdObject.morepics > 0;
}

- (NSInteger)imageWidth
{
    return [self.nativeAdObject.w integerValue];
}

- (NSInteger)imageHeight
{
    return [self.nativeAdObject.h integerValue];
}

- (NSInteger)eCPM
{
    return -1;
}

- (BOOL)allowCustomVideoPlayer {
    return NO;
}

- (NSString *)videoUrl {
    return self.nativeAdObject.videoURLString;
}

- (id <GDTVideoAdReporter>)videoAdReporter {
    return nil;
}

- (BOOL)equalsAdData:(nonnull id<GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject {
    return NO;
}

//百度无视频播放配置
- (GDTVideoConfig *)videoConfig {
    return nil;
}

- (void)setVideoConfig:(GDTVideoConfig *)videoConfig
{
    
}

- (void)registerConnector:(id<GDTUnifiedNativeAdDataObjectConnectorProtocol>)connector clickableViews:(NSArray *)clickableViews
{
    self.connector = connector;
    if ([self isVideoAd]) {
        //在大图上添加播放按钮引导用户点击视频
        if (!self.videoView) {
            BaiduMobAdNativeVideoView *videoView = [[BaiduMobAdNativeVideoView alloc] initWithFrame:self.connector.mediaView.bounds andObject:self.nativeAdObject];
            videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.videoView = videoView;
        }
        
        if (!self.nativeAdView) {
            BaiduMobAdNativeAdView *nativeAdView = [[BaiduMobAdNativeAdView alloc] initWithFrame:connector.unifiedNativeAdView.bounds
                                                                                       brandName:nil
                                                                                           title:nil
                                                                                            text:nil
                                                                                            icon:nil
                                                                                       mainImage:nil
                                                                                       videoView:self.videoView];
            nativeAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.nativeAdView = nativeAdView;
            [self.nativeAdView loadAndDisplayNativeAdWithObject:self.nativeAdObject completion:^(NSArray *errors) {
            }];
        }
        
        if (self.nativeAdView.superview != self.connector.unifiedNativeAdView) {
            [self.nativeAdView removeFromSuperview];
        }
        
        [self.connector.unifiedNativeAdView addSubview:self.nativeAdView];
        
        if (self.videoView.superview != self.connector.mediaView) {
            [self.videoView removeFromSuperview];
        }
        [self.connector.mediaView addSubview:self.videoView];
        
    } else if (self.nativeAdObject.materialType == NORMAL) {
        if (!self.nativeAdView) {
            BaiduMobAdNativeAdView *nativeAdView = nil;
            if ([self.nativeAdObject.morepics count] > 0) {
                nativeAdView = [[BaiduMobAdNativeAdView alloc] initWithFrame:connector.unifiedNativeAdView.bounds
                                                                                           brandName:nil
                                                                                               title:nil
                                                                                                text:nil
                                                                                                icon:nil
                                                                                           mainImage:nil
                                                                                             morepics:nil];
            }
            else {
                nativeAdView = [[BaiduMobAdNativeAdView alloc] initWithFrame:connector.unifiedNativeAdView.bounds
                                                                                           brandName:nil
                                                                                               title:nil
                                                                                                text:nil
                                                                                                icon:nil
                                                                   mainImage:nil];
            }
            self.nativeAdView = nativeAdView;
            [self.nativeAdView loadAndDisplayNativeAdWithObject:self.nativeAdObject completion:^(NSArray *errors) {
                
            }];
            self.nativeAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
        
        if (self.nativeAdView.superview && self.nativeAdView.superview != self.connector.unifiedNativeAdView) {
            [self.nativeAdView removeFromSuperview];
        }
        [self.connector.unifiedNativeAdView addSubview:self.nativeAdView];
        
    } else if (self.nativeAdObject.materialType == HTML) {
        // 模板类型无法兼容
    }
}

- (void)unregisterView
{
    [self.videoView removeFromSuperview];
    [self.nativeAdView removeFromSuperview];
    
    self.connector = nil;
}

- (void)didRecordImpression {
    [self.nativeAdView trackImpression];
}

- (BOOL)needsToDetectExposure {
    return YES;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    /*此处注掉的原因是BaiduMobAdNativeAdView强引用了presentAdViewController，会导致rootViewController在页面退出时无法释放，因而GDTUnifiedNativeAdView也无法释放，
        如果想打开，需要在rootViewController的viewWillDisappear方法里强制调用GDTUnifiedNativeAdView的unregisterDataObject方法
     */
    //self.nativeAdView.presentAdViewController = rootViewController;
}

- (UIViewController *)rootViewController
{
    return self.nativeAdView.presentAdViewController;
}

- (void)sendWinNotification:(NSInteger)price {
    [self.nativeAdObject biddingSuccess:[NSString stringWithFormat:@"%ld", price]];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.nativeAdObject biddingFail:[NSString stringWithFormat:@"%ld", reason]];
}

#pragma mark - GDTMediaViewAdapterProtocol
/**
 * 视频广告时长，单位 ms
 */
- (CGFloat)videoDuration
{
    return 0;
}

/**
 * 视频广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime
{
    return 0;
}

/**
 播放视频
 */
- (void)play
{
    [self.videoView play];
}

/**
 暂停视频，调用 pause 后，需要被暂停的视频广告对象，不会再自动播放，需要调用 play 才能恢复播放。
 */
- (void)pause
{
    [self.videoView pause];
}

/**
 停止播放，并展示第一帧
 */
- (void)stop
{
    [self.videoView stop];
}

/**
 播放静音开关
 @param flag 是否静音
 */
- (void)muteEnable:(BOOL)flag
{
    [self.videoView setVideoMute:flag];
}

/**
 自定义播放按钮
 
 @param image 自定义播放按钮图片，不设置为默认图
 @param size 自定义播放按钮大小，不设置为默认大小 44 * 44
 */
- (void)setPlayButtonImage:(UIImage *)image size:(CGSize)size
{

}

#pragma mark - BaiduMobAdNativeInterationDelegate
/**
 *  广告曝光成功
 */
- (void)nativeAdExposure:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewWillExpose:)]) {
        [self.connector adapter_unifiedNativeAdViewWillExpose:self];
    }
}

/**
 *  广告曝光失败
 */
- (void)nativeAdExposureFail:(UIView *)nativeAdView
          nativeAdDataObject:(BaiduMobAdNativeAdObject *)object
                  failReason:(int)reason {
    
}

/**
 *  广告点击
 */
- (void)nativeAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewDidClick:)]) {
        [self.connector adapter_unifiedNativeAdViewDidClick:self];
    }
}

/**
 *  广告详情页关闭
 */
- (void)didDismissLandingPage:(UIView *)nativeAdView {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdDetailViewClosed:)]) {
        [self.connector adapter_unifiedNativeAdDetailViewClosed:self];
    }
}

/**
 *  联盟官网点击跳转
 */
- (void)unionAdClicked:(UIView *)nativeAdView nativeAdDataObject:(BaiduMobAdNativeAdObject *)object {
    
}

/**
 *  反馈弹窗展示
 *  @param adView 当前的广告视图
 */
- (void)nativeAdDislikeShow:(UIView *)adView {
    
}

/**
 *  反馈弹窗点击
 *  @param adView 当前的广告视图
 *  @param reason 反馈原因
 */
- (void)nativeAdDislikeClick:(UIView *)adView reason:(BaiduMobAdDislikeReasonType)reason {
    if ([self.connector respondsToSelector:@selector(adapter_adComplainSuccess:)]) {
        [self.connector adapter_adComplainSuccess:self];
    }
}

/**
 *  反馈弹窗关闭
 *  @param adView 当前的广告视图
 */
- (void)nativeAdDislikeClose:(UIView *)adView {
    
}

/**
 *  视频缓存成功
 */
- (void)nativeVideoAdCacheSuccess:(BaiduMobAdNative *)nativeAd {
    
}

/**
 *  视频缓存失败
 */
- (void)nativeVideoAdCacheFail:(BaiduMobAdNative *)nativeAd withError:(BaiduMobFailReason)reason {
    
}

/**
 * BaiduMobAdExpressNativeView组件渲染成功
 */
- (void)nativeAdExpressSuccessRender:(BaiduMobAdExpressNativeView *)express
                            nativeAd:(BaiduMobAdNative *)nativeAd {
    
}

@end
