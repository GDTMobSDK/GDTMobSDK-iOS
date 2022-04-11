//
//  BDGDT_NativeExpressAdViewAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_NativeExpressAdViewAdapter.h"


@interface BDGDT_NativeExpressAdViewAdapter ()

@property (nonatomic, strong) BaiduMobAdSmartFeedView *feedView;

@end

@implementation BDGDT_NativeExpressAdViewAdapter
@synthesize controller = _controller;
@synthesize isReady = _isReady;
@synthesize isVideoAd = _isVideoAd;
@synthesize gdtExpressAdView = _gdtExpressAdView;

- (instancetype)initWithBDNativeAdView:(BaiduMobAdSmartFeedView *)feedView object:(BaiduMobAdNativeAdObject *)object
{
    self = [super init];
    if (self) {
        self.feedView = feedView;
        self.bdAdObject = object;
    }
    return self;
}

#pragma mark - GDTNativeExpressAdViewAdapterProtocol

- (UIView *)adView {
    return self.feedView;
}

- (NSInteger)eCPM {
    return -1;
}

- (nonnull NSString *)eCPMLevel {
    return self.bdAdObject.ECPMLevel;
}

- (void)render {
    [self.feedView render];
    [self.feedView trackImpression];
}

- (CGFloat)videoDuration {
    return -1;
}

- (CGFloat)videoPlayTime {
    return -1;
}

- (void)setController:(UIViewController *)controller {
    _controller = controller;
}

- (BOOL)isReady {
    return [self.feedView isReady];
}

- (BOOL)isVideoAd {
    return self.bdAdObject.videoURLString.length > 0;
}

- (BOOL)isAdValid {
    return !self.bdAdObject.isExpired;
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    
}

- (void)sendWinNotification:(NSInteger)price {
    
}

- (void)setBidECPM:(NSInteger)price {
    
}


@end
