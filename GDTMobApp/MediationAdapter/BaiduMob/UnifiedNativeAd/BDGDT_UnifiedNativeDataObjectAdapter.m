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

@interface BDGDT_UnifiedNativeDataObjectAdapter()

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
    
    if (self.nativeAdObject.materialType == NORMAL || self.nativeAdObject.materialType == VIDEO) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nativeAdClicked:) name:@"BDGDT_UnifiedNativeAdClicked" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissLandingPage:) name:@"BDGDT_didDismissLandingPage" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nativeAdExposed:) name:@"BDGDT_UnifiedNativeAdExposed" object:nil];
    }
}

- (void)unregisterView
{
    [self.videoView removeFromSuperview];
    [self.nativeAdView removeFromSuperview];
    
    self.connector = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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

}

/**
 自定义播放按钮
 
 @param image 自定义播放按钮图片，不设置为默认图
 @param size 自定义播放按钮大小，不设置为默认大小 44 * 44
 */
- (void)setPlayButtonImage:(UIImage *)image size:(CGSize)size
{

}

- (void)nativeAdClicked:(NSNotification *)notification {
    if ((notification.object == self.nativeAdObject) && [self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewDidClick:)]) {
        [self.connector adapter_unifiedNativeAdViewDidClick:self];
    }
}

- (void)didDismissLandingPage:(NSNotification *)notification {
    if ((notification.object == self.nativeAdView) && [self.connector respondsToSelector:@selector(adapter_unifiedNativeAdDetailViewClosed:)]) {
        [self.connector adapter_unifiedNativeAdDetailViewClosed:self];
    }
}

- (void)nativeAdExposed:(NSNotification *)notification {
    if ((notification.object == self.nativeAdObject) && [self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewWillExpose:)]) {
        [self.connector adapter_unifiedNativeAdViewWillExpose:self];
    }
}

@end
