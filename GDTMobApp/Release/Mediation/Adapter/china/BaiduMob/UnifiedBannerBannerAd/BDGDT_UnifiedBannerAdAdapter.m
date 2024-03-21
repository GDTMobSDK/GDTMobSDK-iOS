//
//  BDGDT_UnifiedBannerAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/7/26.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BDGDT_UnifiedBannerAdAdapter.h"
#import <BaiduMobAdSDK/BaiduMobAdView.h>
#import "GDTUnifiedBannerAdNetworkConnectorProtocol.h"

static NSString *s_appId = nil;

@interface BDGDT_UnifiedBannerAdAdapter () <BaiduMobAdViewDelegate>

@property (nonatomic, weak) id<GDTUnifiedBannerAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, weak) GDTUnifiedBannerView *gdtBannerView;
@property (nonatomic, strong) BaiduMobAdView *bdBannerView;

@end

@implementation BDGDT_UnifiedBannerAdAdapter

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    s_appId = appId;
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (nullable instancetype)initWithAdNetworkConnector:(id<GDTUnifiedBannerAdNetworkConnectorProtocol>)connector
                                              posId:(nonnull NSString *)posId
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

- (NSInteger)eCPM {
    return -1;
}

#pragma mark - GDTUnifiedBannerAdNetworkAdapterProtocol

- (void)loadAdOnBannerView:(GDTUnifiedBannerView *)banner currentViewController:(UIViewController *)viewController {
    self.gdtBannerView = banner;
    //计算百青藤广告尺寸，百青藤广告不会占满优量汇广告尺寸
    CGFloat bdWidth = banner.frame.size.width;
    CGFloat bdHeight = bdWidth * 3.0/20.0;
    self.bdBannerView = [[BaiduMobAdView alloc] initWithFrame:CGRectMake(0, 0, bdWidth, bdHeight)];
    self.bdBannerView.AdUnitTag = self.posId;
    self.bdBannerView.presentAdViewController = viewController;
    self.bdBannerView.delegate = self;
    self.bdBannerView.AdType = BaiduMobAdViewTypeBanner;
    [self.bdBannerView start];
}

- (void)showBannerAd {
    if (self.gdtBannerView.subviews.count > 0) {
        for (UIView *itemView in self.gdtBannerView.subviews) {
            [itemView removeFromSuperview];
        }
    }
    [self.gdtBannerView addSubview:self.bdBannerView];
}
#pragma mark - BaiduMobAdViewDelegate

- (NSString *)publisherId {
    return s_appId;
}

- (void)willDisplayAd:(BaiduMobAdView *)adview {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewDidLoad:)]) {
        [self.connector adapter_unifiedBannerViewDidLoad:self];
    }
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewWillExpose:)]) {
        [self.connector adapter_unifiedBannerViewWillExpose:self];
    }
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewFailedToLoad:error:)]) {
        [self.connector adapter_unifiedBannerViewFailedToLoad:self error:[NSError errorWithDomain:@"kBaiduADNErrorDomain" code:reason userInfo:@{
            @"BaiduMobFailReason":@(reason)
        }]];
    }
}

- (void)didAdImpressed {
    // 无对应回调
}

- (void)didAdClicked {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewClicked:)]) {
        [self.connector adapter_unifiedBannerViewClicked:self];
    }
}

- (void)didDismissLandingPage {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewDidDismissFullScreenModal:)]) {
        [self.connector adapter_unifiedBannerViewDidDismissFullScreenModal:self];
    }
}

- (void)didAdClose {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewWillClose:)]) {
        [self.connector adapter_unifiedBannerViewWillClose:self];
    }
    [self.gdtBannerView removeFromSuperview];
}

@end
