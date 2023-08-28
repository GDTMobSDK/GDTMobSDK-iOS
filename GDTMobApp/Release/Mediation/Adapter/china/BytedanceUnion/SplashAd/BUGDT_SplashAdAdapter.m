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

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_SplashAdAdapter() <GDTSplashAdNetworkConnectorProtocol>

@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BUSplashAd *splashAd;
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
@synthesize shouldLoadFullscreenAd;

#pragma mark - GDTSplashAdNetworkConnectorProtocol

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (BUAdSDKManager.appID.length == 0) {
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        configuration.appID = appId;
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                s_sdkInitializationSuccess = success;
            });
        }];
    }
}

- (BOOL)sdkInitializationSuccess {
    return s_sdkInitializationSuccess;
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
    
    self.splashAd = [[BUSplashAd alloc] initWithSlotID:self.posId adSize:[UIApplication sharedApplication].keyWindow.bounds.size];
    self.splashAd.tolerateTimeout = self.fetchDelay;
    self.splashAd.delegate = self.delegateObject;
    [self.splashAd loadAdData];
}

- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView {
    [self.splashAd showSplashViewInRootViewController:window.rootViewController];
}

- (NSInteger)eCPM {
    if ([self.splashAd.mediaExt objectForKey:@"price"]) {
        return [[self.splashAd.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (BOOL)isAdValid {
    return YES;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.splashAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.splashAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.splashAd win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.splashAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
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
    [self.splashAd removeSplashView];
}

@end
