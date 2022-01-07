//
//  BUGDT_NativeExpressAdViewAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressAdViewAdapter.h"
#import "GDTAdProtocol.h"

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

- (BOOL)isAdValid {
    return YES;
}

- (NSInteger)eCPM {
    if ([self.buAdView.mediaExt objectForKey:@"price"]) {
        return [[self.buAdView.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.buAdView.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.buAdView.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

@end
