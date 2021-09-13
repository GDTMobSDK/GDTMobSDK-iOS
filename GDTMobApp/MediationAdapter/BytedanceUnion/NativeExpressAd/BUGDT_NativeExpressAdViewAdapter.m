//
//  BUGDT_NativeExpressAdViewAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressAdViewAdapter.h"

@interface BUGDT_NativeExpressAdViewAdapter()

@property (nonatomic, strong) BUNativeExpressAdView *buAdView;

@end

@implementation BUGDT_NativeExpressAdViewAdapter
@synthesize controller = _controller;
@synthesize isReady = _isReady;
@synthesize isVideoAd = _isVideoAd;
@synthesize gdtExpressAdView = _gdtExpressAdView;

- (instancetype)initWithBUNativeExpressAdView:(BUNativeExpressAdView *)buAdView {
    self = [super init];
    if (self) {
        self.buAdView = buAdView;
    }
    return self;
}

#pragma mark - GDTNativeExpressAdViewAdapterProtocol

- (UIView *)adView {
    return self.buAdView;
}

- (NSInteger)eCPM {
    return -1;
}

- (nonnull NSString *)eCPMLevel {
    return @"";
}

- (void)render {
    [self.buAdView render];
}

- (CGFloat)videoDuration {
    return self.buAdView.videoDuration;
}

- (CGFloat)videoPlayTime {
    return self.buAdView.currentPlayedTime;
}

- (BOOL)isReady {
    return self.buAdView.isReady;
}

- (void)setController:(UIViewController *)controller {
    _controller = controller;
    self.buAdView.rootViewController = controller;
}

@end
