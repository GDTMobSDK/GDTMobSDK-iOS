//
//  BDGDT_SplashAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BDGDT_SplashAdAdapter.h"
#import "GDTSplashAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "BDGDT_SplashAdDelegateObject.h"

static NSString *s_appId = nil;

@interface BDGDT_SplashAdAdapter() <GDTSplashAdNetworkConnectorProtocol>

@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BaiduMobAdSplash *splashAd;
@property (strong, nonatomic) UIView *splashView;
@property (nonatomic, strong) BDGDT_SplashAdDelegateObject *delegateObject;
@property (nonatomic, copy) NSString *posId;

@end

@implementation BDGDT_SplashAdAdapter

@synthesize backgroundColor;
@synthesize backgroundImage;
@synthesize fetchDelay;
@synthesize skipButtonCenter;
@synthesize shouldLoadFullscreenAd;

#pragma mark - GDTSplashAdNetworkConnectorProtocol

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (instancetype)initWithAdNetworkConnector:(id<GDTSplashAdNetworkConnectorProtocol>)connector
                                     posId:(NSString *)posId
{
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
    self.delegateObject = [[BDGDT_SplashAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    self.delegateObject.appId = s_appId;
    
    self.splashAd = [[BaiduMobAdSplash alloc] init];
    self.splashAd.delegate = self.delegateObject;
    self.splashAd.AdUnitTag = self.posId;
    self.splashAd.canSplashClick = YES;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.splashAd.adSize = CGSizeMake(window.frame.size.width, window.frame.size.height);
    
    [self.splashAd load];
}

- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView {
    //百青藤的load和show分开的方法只支持拉取全屏的广告，无法在show时修改广告容器大小
    self.splashView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:self.splashView];
    [self.splashAd showInContainerView:self.splashView];
}

- (NSInteger)eCPM
{
    return [self.splashAd getECPMLevel].integerValue;
}

- (BOOL)isAdValid {
    return self.delegateObject.isAdValid;
}

- (void)removeSplash {
    [self.splashView removeFromSuperview];
}

- (void)sendWinNotification:(NSInteger)price {
    [self.splashAd biddingSuccess:[NSString stringWithFormat:@"%ld", price]];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.splashAd biddingFail:[NSString stringWithFormat:@"%ld", reason]];
}

@end
