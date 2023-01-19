//
//  UnifiedNativeCustomVideoPlayerViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeCustomVideoPlayerViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "UnifiedNativeAdCustomView.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomPlayerVideoView.h"

@interface UnifiedNativeCustomVideoPlayerViewController () <GDTUnifiedNativeAdDelegate, GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property (nonatomic, strong) UnifiedNativeAdCustomView *nativeAdCustomView;
@property (nonatomic, strong) GDTUnifiedNativeAdDataObject *dataObject;
@property (nonatomic, strong) CustomPlayerVideoView *videoView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation UnifiedNativeCustomVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.useToken) {
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId token:self.token];
    } else {
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId];
    }
    self.unifiedNativeAd.delegate = self;
    self.unifiedNativeAd.minVideoDuration = self.minVideoDuration;
    self.unifiedNativeAd.maxVideoDuration = self.maxVideoDuration;

    [self.unifiedNativeAd loadAdWithAdCount:1];
    
    [self.view addSubview:self.tipsLabel];
    
    // 播放器容器
    [self.view addSubview:self.videoContainerView];
    self.videoContainerView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9/16.0 + 40.0);
    self.videoContainerView.center = CGPointMake(self.view.bounds.size.width / 2.0, (self.view.bounds.size.height - self.videoContainerView.bounds.size.height) / 2.0);
    
    //广告icon
    [self.videoContainerView addSubview:self.nativeAdCustomView.iconImageView];
    self.nativeAdCustomView.iconImageView.frame = CGRectMake(0, 0, 40.0, 40.0);
    
    //广告标题
    [self.videoContainerView addSubview:self.nativeAdCustomView.titleLabel];
    self.nativeAdCustomView.titleLabel.frame = CGRectMake(50, 0.0, self.videoContainerView.bounds.size.width- 70.0, 40.0);
    
    //clickButton
    [self.videoContainerView addSubview:self.nativeAdCustomView.clickButton];
    self.nativeAdCustomView.clickButton.frame = CGRectMake(CGRectGetWidth(self.videoContainerView.frame) - 80.0, 0.0, 80.0, 40.0);
    [self.videoContainerView addSubview:self.nativeAdCustomView.clickButton];
    self.nativeAdCustomView.CTAButton.frame = self.nativeAdCustomView.clickButton.frame;
    
    //videoView
    [self addVideoView];
    
    //logo view
    [self.videoContainerView addSubview:self.nativeAdCustomView.logoView];
    self.nativeAdCustomView.logoView.frame = CGRectMake(self.videoContainerView.bounds.size.width - self.nativeAdCustomView.logoView.bounds.size.width, self.videoContainerView.bounds.size.height - self.nativeAdCustomView.logoView.bounds.size.height, self.nativeAdCustomView.logoView.bounds.size.width, self.nativeAdCustomView.logoView.bounds.size.height);
     
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)addVideoView {
    //使用自定义播放器容器时，就不能将GDTMediaView加到视图树中了
    self.videoView = [[CustomPlayerVideoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxX(self.nativeAdCustomView.iconImageView.frame), self.videoContainerView.bounds.size.width, self.videoContainerView.bounds.size.height - CGRectGetHeight(self.nativeAdCustomView.iconImageView.bounds))];
    [self.videoContainerView addSubview:self.videoView];
    [self.videoView addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)showAd
{
    if (!self.dataObject.allowCustomVideoPlayer) {
        NSLog(@"自定义播放器功能未开启");
        self.tipsLabel.text = @"自定义播放器功能未开启";
        return;
    }
    
    //自定义播放器设置videoConfig无效
    //self.dataObject.videoConfig = self.videoConfig;
    [self.nativeAdCustomView setupWithUnifiedNativeAdObject:self.dataObject];
    self.nativeAdCustomView.viewController = self;
    //自定义播放器设置视频容器
    self.nativeAdCustomView.customPlayerContainer = self.videoContainerView;
    
    if ([self.dataObject isAdValid]) {
        [self.nativeAdCustomView registerDataObject:self.dataObject clickableViews:@[self.nativeAdCustomView.clickButton, self.nativeAdCustomView.titleLabel, self.nativeAdCustomView.iconImageView, self.videoView]];
        [self.nativeAdCustomView registerClickableCallToActionView:self.nativeAdCustomView.CTAButton];
    }
    
    [self.videoView loadURL:[NSURL URLWithString:self.dataObject.videoUrl]];
    [self.videoView play];
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult {
    //这里只是示例，请根据真实的比价结果来上报每个广告的竞胜竞败信息
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [self.dataObject setBidECPM:100];
    }
    else {
        NSInteger fakeWinPrice = 200;
        NSInteger fakeHighestPrice = 100;
        GDTAdBiddingLossReason fakeLossReason = GDTAdBiddingLossReasonLowPrice;
        NSString *fakeAdnId = @"WinAdnId";
        NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_setting_bidding_report"];
        NSInteger reportFlag = flag ? [flag integerValue] : 1;
        if (reportFlag == 1) {
            [self.dataObject sendWinNotificationWithInfo:@{GDT_M_W_E_COST_PRICE: @(fakeWinPrice), GDT_M_W_H_LOSS_PRICE: @(fakeHighestPrice)}];
        } else if (reportFlag == 2) {
            [self.dataObject sendLossNotificationWithInfo:@{GDT_M_L_WIN_PRICE: @(fakeWinPrice), GDT_M_L_LOSS_REASON:@(fakeLossReason), GDT_M_ADNID: fakeAdnId}];
        }
    }
}

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (!error && unifiedNativeAdDataObjects.count > 0) {
        NSLog(@"广告请求成功");
        self.tipsLabel.text = @"广告请求成功";
        for (GDTUnifiedNativeAdDataObject *obj in unifiedNativeAdDataObjects) {
            NSLog(@"extraInfo: %@", obj.extraInfo);
        }
        self.dataObject = unifiedNativeAdDataObjects[0];
        NSLog(@"eCPM:%ld eCPMLevel:%@", [self.dataObject eCPM], [self.dataObject eCPMLevel]);
        // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
        [self reportBiddingResult];
        
        if (self.dataObject.isVideoAd) {
            [self showAd];
        }
        else {
            self.tipsLabel.text = @"图文广告不支持自定义播放器";
        }
        
        return;
    }
    
    self.tipsLabel.text = error.description;
    if (error.code == 5004) {
        NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    } else if (error.code == 5005) {
        NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    } else if (error.code == 5009) {
        NSLog(@"流量控制导致没有广告，超过小时限额");
    } else if (error.code == 5006) {
        NSLog(@"包名错误");
    } else if (error.code == 5010) {
        NSLog(@"广告样式校验失败");
    } else if (error.code == 3001) {
        NSLog(@"网络错误");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    // observer the status change of video player, reporting infos
    BOOL isVideoStatusChanged = object == self.videoView && [keyPath isEqualToString:@"status"];
    if (!isVideoStatusChanged) return;

    GDTVideoPlayStatus status = (GDTVideoPlayStatus)[change[NSKeyValueChangeNewKey] integerValue];
    [self reportWithStatus:status];
    self.tipsLabel.text = [NSString stringWithFormat:@"播放器状态改变为:%ld", status];
    NSLog(@"%@", self.tipsLabel.text);
}

#pragma mark - Report

- (void)reportWithStatus:(GDTVideoPlayStatus)status {
    id <GDTVideoAdReporter> reportor = self.nativeAdCustomView.videoAdReporter;
    CustomPlayerVideoView *view = self.videoView;
    switch (status) {
        case GDTVideoPlayStatusPlaying: {
            [reportor didStartPlayVideoWithVideoDuration:self.videoView.videoDuration];
        }
            break;
        case GDTVideoPlayStatusPaused: {
            [reportor didPauseVideoWithCurrentDuration:self.videoView.videoPlayTime];
        }
            break;
        case GDTVideoPlayStatusStopped: {
            [reportor didFinishPlayingVideo];
        }
            break;
        case GDTVideoPlayStatusResumed: {
            [reportor didResumeVideoWithCurrentDuration:self.videoView.videoPlayTime];
        }
            break;
        case GDTVideoPlayStatusError: {
            [reportor didPlayFailedWithError:view.playError];
        }
            break;
        default:
            break;
    }
}
#pragma mark - GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@ 广告被点击", unifiedNativeAdView.dataObject);
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告被曝光");
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告详情页已关闭");
    
    if (self.videoView.status == GDTVideoPlayStatusPaused) {
        [self.videoView resume];
    }
}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告进入后台");
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告详情页面即将打开");
    if (self.videoView.status == GDTVideoPlayStatusPlaying || self.videoView.status == GDTVideoPlayStatusResumed) {
        [self.videoView pause];
    }
}

- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}


#pragma mark - property getter
- (UnifiedNativeAdCustomView *)nativeAdCustomView
{
    if (!_nativeAdCustomView) {
        _nativeAdCustomView = [[UnifiedNativeAdCustomView alloc] init];
        _nativeAdCustomView.delegate = self;
        _nativeAdCustomView.accessibilityIdentifier = @"nativeAdCustomView_id";
    }
    return _nativeAdCustomView;
}

- (UIView *)videoContainerView
{
    if (!_videoContainerView) {
        _videoContainerView = [[UIView alloc] init];
        _videoContainerView.accessibilityIdentifier = @"videoContainerView_id";
    }
    return _videoContainerView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, self.view.bounds.size.width-20, 40.0)];
        _tipsLabel.font = [UIFont systemFontOfSize:14.0];
        _tipsLabel.numberOfLines = 2;
    }
    
    return _tipsLabel;
}

@end
