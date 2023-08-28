//
//  BUGDT_UnifiedBannerAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/7/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedBannerAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "MediationAdapterUtil.h"
#import "GDTUnifiedBannerAdNetworkConnectorProtocol.h"

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_UnifiedBannerAdAdapter () <BUNativeExpressBannerViewDelegate>

@property (nonatomic, weak) id <GDTUnifiedBannerAdNetworkConnectorProtocol>connector;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, weak) GDTUnifiedBannerView *gdtBannerView;
@property (nonatomic, strong) BUNativeExpressBannerView *buBannerView;


@end

@implementation BUGDT_UnifiedBannerAdAdapter

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

- (instancetype)initWithAdNetworkConnector:(id<GDTUnifiedBannerAdNetworkConnectorProtocol>)connector posId:(NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAdOnBannerView:(GDTUnifiedBannerView *)banner currentViewController:(UIViewController *)viewController {
    self.gdtBannerView = banner;
    self.buBannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.posId rootViewController:viewController adSize:banner.frame.size];
    
    self.buBannerView.frame = banner.bounds;
    self.buBannerView.delegate = self;
    [self.buBannerView loadAdData];
}

- (void)showBannerAd {
    if (self.gdtBannerView.subviews.count > 0) {
        for (UIView *itemView in self.gdtBannerView.subviews) {
            [itemView removeFromSuperview];
        }
    }
    [self.gdtBannerView addSubview:self.buBannerView];
}

- (NSInteger)eCPM {
    if ([self.buBannerView.mediaExt objectForKey:@"price"]) {
        return [[self.buBannerView.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.buBannerView win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.buBannerView loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
}

#pragma mark - BUNativeExpressBannerViewDelegate

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewDidLoad:)]) {
        [self.connector adapter_unifiedBannerViewDidLoad:self];        
    }
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewFailedToLoad:error:)]) {
        [self.connector adapter_unifiedBannerViewFailedToLoad:self error:error];
    }
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    // 无对应回调
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError * __nullable)error {
    // 无对应回调
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewWillExpose:)]) {
        [self.connector adapter_unifiedBannerViewWillExpose:self];
    }
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewClicked:)]) {
        [self.connector adapter_unifiedBannerViewClicked:self];
    }
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords {
    // 无对应回调
}

- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewDidDismissFullScreenModal:)]) {
        [self.connector adapter_unifiedBannerViewDidDismissFullScreenModal:self];
    }
}

- (void)nativeExpressBannerAdViewDidRemoved:(BUNativeExpressBannerView *)bannerAdView {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedBannerViewWillClose:)]) {
        [self.connector adapter_unifiedBannerViewWillClose:self];
    }
    [self.gdtBannerView removeFromSuperview];
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.buBannerView.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.buBannerView.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}


@end
