//
//  KSGDT_UnifiedNativeDataObjectAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/7.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_UnifiedNativeDataObjectAdapter.h"
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"

@interface KSGDT_UnifiedNativeDataObjectAdapter()

@property (nonatomic, strong) KSNativeAd *nativeAd;
@property (nonatomic, strong) GDTVideoConfig *ksVideoConfig;
@property (nonatomic, strong) KSNativeAdRelatedView *relatedView;
@property (nonatomic, weak) id <GDTUnifiedNativeAdDataObjectConnectorProtocol> connector;
@property (nonatomic, weak) UIView <GDTMediaViewConnectorProtocol> *mediaView;
@property (nonatomic, assign) BOOL didExposed;

@end


@implementation KSGDT_UnifiedNativeDataObjectAdapter

- (instancetype)initWithKSNativeAd:(KSNativeAd *)nativeAd
{
    self = [super init];
    if (self) {
        self.nativeAd = nativeAd;
    }
    return self;
}

#pragma mark - GDTUnifiedNativeAdDataObjectAdapterProtocol
- (NSString *)title
{
    return self.nativeAd.data.appName;
}

- (NSString *)desc
{
    return self.nativeAd.data.adDescription;
}

- (NSString *)imageUrl
{
    return [(KSAdImage *)[self.nativeAd.data.imageArray firstObject] imageURL];
}

- (NSString *)iconUrl
{
    return self.nativeAd.data.appIconImage.imageURL;
}

- (BOOL)isVideoAd
{
    return self.nativeAd.data.materialType == KSAdMaterialTypeVideo;
}

- (NSArray *)mediaUrlList
{
    NSMutableArray *container = [NSMutableArray array];
    for (KSAdImage *image in self.nativeAd.data.imageArray) {
        if (image.imageURL) {
            [container addObject:image.imageURL];
        }
    }
    return [NSArray arrayWithArray:container];
}

- (CGFloat)appRating
{
    return self.nativeAd.data.appScore;
}

- (NSNumber *)appPrice
{
    return @(0);
}

- (BOOL)isAppAd
{
    return (self.nativeAd.data.interactionType == KSAdInteractionType_App);
}

- (BOOL)isThreeImgsAd
{
    return [self.nativeAd.data.imageArray count] == 3;
}

- (NSInteger)imageWidth
{
    KSAdImage *firstImage = [self.nativeAd.data.imageArray firstObject];
    return firstImage.width;
}

- (NSInteger)imageHeight
{
    KSAdImage *firstImage = [self.nativeAd.data.imageArray firstObject];
    return firstImage.height;
}

- (NSInteger)eCPM
{
    return self.nativeAd.ecpm;
}

- (NSString *)callToAction {
    return self.nativeAd.data.actionDescription;
}

- (BOOL)allowCustomVideoPlayer {
    return NO;
}

- (id <GDTVideoAdReporter>)videoAdReporter {
    return nil;
}

- (NSString *)videoUrl {
    return self.nativeAd.data.videoUrl;
}

- (BOOL)equalsAdData:(nonnull id<GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject {
    return NO;
}

- (GDTVideoConfig *)videoConfig {
    return self.ksVideoConfig;
}

- (void)setVideoConfig:(GDTVideoConfig *)videoConfig
{
    _ksVideoConfig = videoConfig;
}

- (void)registerConnector:(id<GDTUnifiedNativeAdDataObjectConnectorProtocol>)connector clickableViews:(NSArray *)clickableViews
{
    self.connector = connector;
    self.relatedView = [[KSNativeAdRelatedView alloc] init];
    self.relatedView.videoAdView.backgroundColor = [UIColor redColor];
    if ([self isVideoAd]) {
        self.mediaView = self.connector.mediaView;
        self.relatedView.videoAdView.videoSoundEnable = !self.videoConfig.videoMuted;
        [self.connector.mediaView addSubview:self.relatedView.videoAdView];
        self.relatedView.videoAdView.frame = self.connector.mediaView.bounds;
        self.relatedView.videoAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.relatedView refreshData:self.nativeAd];
    }
    self.nativeAd.delegate = self;
    [self.nativeAd registerContainer:connector.unifiedNativeAdView withClickableViews:clickableViews];
    // 第三方平台广告标识设置
    self.connector.logoView.image = nil; // 清空原有标识
    self.connector.logoView.backgroundColor = [UIColor yellowColor];
    [self.connector.logoView addSubview:self.relatedView.adLabel]; // 添加 subView，方便调用方统一调整 LogoView
    self.relatedView.adLabel.frame = self.connector.logoView.bounds;
    self.relatedView.adLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.relatedView.adLabel.backgroundColor = [UIColor redColor];
}

- (void)unregisterView
{
    [self.relatedView.videoAdView removeFromSuperview];
    [self.relatedView.adLabel removeFromSuperview];
    self.relatedView = nil;
    self.mediaView = nil;
    self.connector = nil;
    [self.nativeAd unregisterView];
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    self.nativeAd.rootViewController = rootViewController;
}

- (UIViewController *)rootViewController
{
    return self.nativeAd.rootViewController;
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.nativeAd reportAdExposureFailed:0 reportParam:nil];
}

- (void)sendWinNotification:(NSInteger)price {
    [self.nativeAd setBidEcpm:price];
}

#pragma mark - GDTMediaViewAdapterProtocol
/**
 * 视频广告时长，单位 ms
 */
- (CGFloat)duration
{
    return (CGFloat)self.nativeAd.data.videoDuration;
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

}

/**
 暂停视频，调用 pause 后，需要被暂停的视频广告对象，不会再自动播放，需要调用 play 才能恢复播放。
 */
- (void)pause
{

}

/**
 停止播放，并展示第一帧
 */
- (void)stop
{
    
}

/**
 播放静音开关
 @param flag 是否静音
 */
- (void)muteEnable:(BOOL)flag
{
    self.relatedView.videoAdView.videoSoundEnable = !flag;
}

- (CGFloat)videoDuration {
    return [self duration];
}
/**
 自定义播放按钮
 
 @param image 自定义播放按钮图片，不设置为默认图
 @param size 自定义播放按钮大小，不设置为默认大小 44 * 44
 */
- (void)setPlayButtonImage:(UIImage *)image size:(CGSize)size
{
    //[self.relatedView.videoAdView playerPlayIncon:image playInconSize:size];
}

#pragma mark - KSNativeAdDelegate

- (void)nativeAdDidBecomeVisible:(KSNativeAd *)nativeAd {
    if (!self.didExposed || [self isVideoAd]) {
        self.didExposed = YES;
        [self.connector adapter_unifiedNativeAdViewWillExpose:self];
    }
}

- (void)nativeAdDidClick:(KSNativeAd *)nativeAd withView:(UIView *)view {
    [self.connector adapter_unifiedNativeAdViewDidClick:self];
}

- (void)nativeAdDidShowOtherController:(KSNativeAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    if (interactionType == KSAdInteractionType_App || interactionType == KSAdInteractionType_Web) {
        [self.connector adapter_unifiedNativeAdDetailViewWillPresentScreen:self];
    }
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeAdDidCloseOtherController:(KSNativeAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {

}

@end
