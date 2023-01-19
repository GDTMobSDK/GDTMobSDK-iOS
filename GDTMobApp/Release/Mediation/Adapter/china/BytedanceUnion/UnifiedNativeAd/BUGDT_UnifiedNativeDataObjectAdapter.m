//
//  BUGDT_UnifiedNativeDataObjectAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/11.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedNativeDataObjectAdapter.h"
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"

@interface BUGDT_UnifiedNativeDataObjectAdapter() <GDTVideoAdReporter>

@property (nonatomic, strong) BUNativeAd *nativeAd;
@property (nonatomic, strong) GDTVideoConfig *buVideoConfig;
@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;
@property (nonatomic, weak) id <GDTUnifiedNativeAdDataObjectConnectorProtocol> connector;
@property (nonatomic, weak) UIView <GDTMediaViewConnectorProtocol> *mediaView;
@property (nonatomic, assign) BOOL didExposed;

@end

@implementation BUGDT_UnifiedNativeDataObjectAdapter

- (instancetype)initWithBUNativeAd:(BUNativeAd *)nativeAd
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
    return self.nativeAd.data.AdTitle;
}

- (NSString *)desc
{
    return self.nativeAd.data.AdDescription;
}

- (NSString *)imageUrl
{
    return [(BUImage *)[self.nativeAd.data.imageAry firstObject] imageURL];
}

- (NSString *)iconUrl
{
    return self.nativeAd.data.icon.imageURL;
}

- (NSString *)buttonText
{
    return self.nativeAd.data.buttonText;
}

- (BOOL)isVideoAd
{
    return (self.nativeAd.data.imageMode == BUFeedVideoAdModeImage);
}

- (NSArray *)mediaUrlList
{
    NSMutableArray *container = [NSMutableArray array];
    for (BUImage *image in self.nativeAd.data.imageAry) {
        if (image.imageURL) {
            [container addObject:image.imageURL];
        }
    }
    return [NSArray arrayWithArray:container];
}

- (CGFloat)appRating
{
    return self.nativeAd.data.score;
}

- (NSNumber *)appPrice
{
    return @(0);
}

- (BOOL)isAppAd
{
    return (self.nativeAd.data.interactionType == BUInteractionTypeDownload);
}

- (BOOL)isThreeImgsAd
{
    return [self.nativeAd.data.imageAry count] == 3;
}

- (NSInteger)imageWidth
{
    BUImage *firstImage = [self.nativeAd.data.imageAry firstObject];
    return firstImage.width;
}

- (NSInteger)imageHeight
{
    BUImage *firstImage = [self.nativeAd.data.imageAry firstObject];
    return firstImage.height;
}

- (CGFloat)duration {
    if (self.isVideoAd) {
        return self.nativeAd.data.videoDuration;
    }
    else {
        return 0.0;
    }
}

- (NSInteger)eCPM {
    if ([self.nativeAd.data.mediaExt objectForKey:@"price"]) {
        return [[self.nativeAd.data.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (BOOL)allowCustomVideoPlayer {
    return self.nativeAd.data.allowCustomVideoPlayer;
}

- (NSString *)videoUrl {
    return self.nativeAd.data.videoUrl;
}

- (id <GDTVideoAdReporter>)videoAdReporter {
    return self;
}

- (BOOL)equalsAdData:(nonnull id<GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject {
    return NO;
}

- (GDTVideoConfig *)videoConfig {
    return self.buVideoConfig;
}

- (void)setVideoConfig:(GDTVideoConfig *)videoConfig
{
    _buVideoConfig = videoConfig;
}

- (void)registerConnector:(id<GDTUnifiedNativeAdDataObjectConnectorProtocol>)connector clickableViews:(NSArray *)clickableViews
{
    self.connector = connector;
    self.relatedView = [[BUNativeAdRelatedView alloc] init];
    if ([self isVideoAd]) {
        self.mediaView = self.connector.mediaView;
        [self.connector.mediaView addSubview:self.relatedView.videoAdView];
        self.relatedView.videoAdView.delegate = self;
        self.relatedView.videoAdView.frame = self.connector.mediaView.bounds;
        self.relatedView.videoAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.relatedView refreshData:self.nativeAd];
    }
    [self.nativeAd registerContainer:connector.unifiedNativeAdView withClickableViews:clickableViews];
    // 第三方平台广告标识设置
    self.connector.logoView.image = nil; // 清空原有标识
    [self.connector.logoView addSubview:self.relatedView.logoADImageView]; // 添加 subView，方便调用方统一调整 LogoView
    self.relatedView.logoADImageView.frame = self.connector.logoView.bounds;
    self.relatedView.logoADImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)unregisterView
{
    [self.relatedView.videoAdView removeFromSuperview];
    [self.relatedView.logoADImageView removeFromSuperview];
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

- (void)sendWinNotification:(NSInteger)price {
    [self.nativeAd win:@(price)];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.nativeAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", reason] winBidder:adnId];
}

#pragma mark - GDTMediaViewAdapterProtocol
/**
 * 视频广告时长，单位 ms
 */
- (CGFloat)videoDuration
{
    return [self duration];
}

/**
 * 视频广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime
{
    return self.relatedView.videoAdView.currentPlayTime * 1000;
}

/**
 播放视频
 */
- (void)play
{
    [self.relatedView.videoAdView play];
}

/**
 暂停视频，调用 pause 后，需要被暂停的视频广告对象，不会再自动播放，需要调用 play 才能恢复播放。
 */
- (void)pause
{
    [self.relatedView.videoAdView pause];
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
//    [self.relatedView.videoAdView setMute:flag];
}

/**
 自定义播放按钮
 
 @param image 自定义播放按钮图片，不设置为默认图
 @param size 自定义播放按钮大小，不设置为默认大小 44 * 44
 */
- (void)setPlayButtonImage:(UIImage *)image size:(CGSize)size
{
    [self.relatedView.videoAdView playerPlayIncon:image playInconSize:size];
}

#pragma mark - BUNativeAdDelegate
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd;
{
    NSLog(@"%s",__FUNCTION__);
}
/**
 nativeAd 广告已展示
 @param nativeAd 出现在可视区域的广告位
 */
- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd
{
    NSLog(@"%s",__FUNCTION__);
    if (!self.didExposed) {
        self.didExposed = YES;
        [self.connector adapter_unifiedNativeAdViewWillExpose:self];
    }
}

/**
 nativeAd 被点击
 
 @param nativeAd 被点击的 广告位
 @param view 被点击的视图
 */
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view
{
    [self.connector adapter_unifiedNativeAdViewDidClick:self];
}

/**
 用户点击 dislike功能
 @param nativeAd 被点击的 广告位
 @param filterWords 不喜欢的原因， 可能为空
 */
- (void)nativeAd:(BUNativeAd *)nativeAd dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords
{
    NSLog(@"%s",__FUNCTION__);
}



#pragma mark - BUVideoAdViewDelegate
- (void)videoAdView:(BUVideoAdView *)videoAdView didLoadFailWithError:(NSError *_Nullable)error
{
    
}

- (void)videoAdView:(BUVideoAdView *)videoAdView stateDidChanged:(BUPlayerPlayState)playerState
{
    GDTMediaPlayerStatus status = GDTMediaPlayerStatusInitial;
    switch (playerState) {
        case BUPlayerStateFailed:
            status = GDTMediaPlayerStatusError;
            break;
        case BUPlayerStateBuffering:
            status = GDTMediaPlayerStatusLoading;
            break;
        case BUPlayerStatePlaying:
            status = GDTMediaPlayerStatusStarted;
            break;
        case BUPlayerStateStopped:
            status = GDTMediaPlayerStatusStoped;
            break;
        case BUPlayerStatePause:
            status = GDTMediaPlayerStatusPaused;
            break;
        case BUPlayerStateDefalt:
            status = GDTMediaPlayerStatusInitial;
            break;
        default:
            break;
    }
    [self.connector adapter_unifiedNativeAdView:self
                            playerStatusChanged:status
                                       userInfo:@{}];
}

- (void)playerDidPlayFinish:(BUVideoAdView *)videoAdView
{
    [self.mediaView adapter_mediaViewDidPlayFinished:self];
}

#pragma mark - GDTVideoAdRepoter

- (void)didStartPlayVideoWithVideoDuration:(NSTimeInterval)duration {
    [self.relatedView.videoAdReportor didStartPlayVideoWithVideoDuration:duration];
}

- (void)didFinishPlayingVideo {
    [self.relatedView.videoAdReportor didFinishVideo];
}

- (void)didPlayFailedWithError:(NSError *)error {
    [self.relatedView.videoAdReportor didPlayFailedWithError:error];
}

- (void)didPauseVideoWithCurrentDuration:(NSTimeInterval)duration {
    [self.relatedView.videoAdReportor didPauseVideoWithCurrentDuration:duration];
}

- (void)didResumeVideoWithCurrentDuration:(NSTimeInterval)duration {
    [self.relatedView.videoAdReportor didResumeVideoWithCurrentDuration:duration];
}

@end
