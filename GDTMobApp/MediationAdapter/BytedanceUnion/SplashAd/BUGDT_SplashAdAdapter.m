//
//  BUGDT_SplashAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BUGDT_SplashAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "GDTSplashAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "BUGDT_SplashAdDelegateObject.h"

@interface BUGDT_SplashAdAdapter() <GDTSplashAdNetworkConnectorProtocol>

@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BUSplashAdView *splashAdView;
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) BUGDT_SplashAdDelegateObject *delegateObject;

@end

@implementation BUGDT_SplashAdAdapter

@synthesize backgroundColor;
@synthesize backgroundImage;
@synthesize fetchDelay;
@synthesize skipButtonCenter;
@synthesize needZoomOut;
@synthesize shouldLoadFullscreenAd;

#pragma mark - GDTSplashAdNetworkConnectorProtocol

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (BUAdSDKManager.appID.length == 0) {
        if ([appId length] > 0) {
            [BUAdSDKManager setAppID:appId];
        }
        else {
            NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
            [BUAdSDKManager setAppID:params[@"appid"]];
        }
    }
}

- (instancetype)initWithAdNetworkConnector:(id<GDTSplashAdNetworkConnectorProtocol>)connector
                                     posId:(NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAd {
    self.delegateObject = [[BUGDT_SplashAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    
    self.splashAdView = [[BUSplashAdView alloc] initWithSlotID:self.posId frame:[UIApplication sharedApplication].keyWindow.bounds];
    self.splashAdView.tolerateTimeout = self.fetchDelay;
    self.splashAdView.delegate = self.delegateObject;
    [self.splashAdView loadAdData];
}

- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView {
    self.window = window;
    //由于在下面调整splashAdView的frame不生效，故此处不设置bottomView，使之全屏展示，若想支持BottonView，需要在BUSplashAdView创建时设置frame
    bottomView = nil;
    self.bottomView = bottomView;
    CGRect bottomRect = CGRectMake(0,
                                   window.bounds.size.height - bottomView.bounds.size.height,
                                   window.bounds.size.width,
                                   bottomView.bounds.size.height);
    CGRect splashRect = CGRectMake(0,
                                   0,
                                   window.bounds.size.width,
                                   window.bounds.size.height - bottomRect.size.height);
    self.bottomView.frame = bottomRect;
    self.splashAdView.frame = splashRect;
    if ([skipView isKindOfClass:[UIButton class]]) {
        self.skipButton = (UIButton *)skipView;
        [self.skipButton addTarget:self action:@selector(clickSkip) forControlEvents:UIControlEventTouchUpInside];
        self.splashAdView.hideSkipButton = YES;
    }
    
    [self.window.rootViewController.view addSubview:self.splashAdView];
    [self.window.rootViewController.view addSubview:self.bottomView];
    [self.window.rootViewController.view addSubview:self.skipButton];
    self.splashAdView.rootViewController = self.window.rootViewController;
}

- (NSInteger)eCPM {
    if ([self.splashAdView.mediaExt objectForKey:@"price"]) {
        return [[self.splashAdView.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (BOOL)isAdValid {
    return self.splashAdView.adValid;
}

- (GDTSplashZoomOutView *)splashZoomOutView {
    return nil;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.splashAdView.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.splashAdView.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

#pragma mark - private
- (void)clickSkip
{
    [self.connector adapter_splashAdWillClosed:self];
    [self removeAllSubviews];
    [self.connector adapter_splashAdClosed:self];
}

- (void)removeAllSubviews
{
    [self.skipButton removeFromSuperview];
    [self.bottomView removeFromSuperview];
    [self.splashAdView removeFromSuperview];
}

@end
