//
//  KSGDT_NativeExpressAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_NativeExpressAdAdapter.h"
#import "GDTNativeExpressAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSFeedAdsManager.h>
#import "KSGDT_NativeExpressAdViewAdapter.h"
#import "MediationAdapterUtil.h"
#import <KSAdSDK/KSAdSDKManager.h>

static NSString *s_addId = nil;

@interface KSGDT_NativeExpressAdAdapter () <KSFeedAdsManagerDelegate>

@property (nonatomic, weak) id<GDTNativeExpressAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) KSFeedAdsManager *feedAdsManager;
@property (nonatomic, strong) NSArray <KSGDT_NativeExpressAdViewAdapter *> *viewAdapters;


@end

@implementation KSGDT_NativeExpressAdAdapter
@synthesize adSize = _adSize;

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {
    if (KSAdSDKManager.appId.length == 0) {
        if ([appId length] > 0) {
            [KSAdSDKManager setAppId:appId];
        }
        else {
            NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
            [KSAdSDKManager setAppId:params[@"appid"]];
        }
    }
}

- (BOOL)sdkInitializationSuccess {
    return YES;
}

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.connector = connector;
        self.posId = posId;
    }
    return self;
}

- (void)loadAdWithCount:(NSInteger)count {
    self.feedAdsManager = [[KSFeedAdsManager alloc] initWithPosId:self.posId size:self.adSize];
    self.feedAdsManager.delegate = self;
    [self.feedAdsManager loadAdDataWithCount:count];
}

- (NSInteger)eCPM {
    KSGDT_NativeExpressAdViewAdapter *firstAd = [self.viewAdapters firstObject];
    if (firstAd && [firstAd respondsToSelector:@selector(eCPM)]) {
        return [firstAd eCPM];
    }
    else {
        return -1;
    }
}

#pragma mark - KSNativeAdsManagerDelegate

- (void)feedAdsManagerSuccessToLoad:(KSFeedAdsManager *)adsManager nativeAds:(NSArray<KSFeedAd *> *_Nullable)feedAdDataArray {
    NSMutableArray<KSGDT_NativeExpressAdViewAdapter *> *viewAdapters = [NSMutableArray array];
    for (KSFeedAd *feedAd in feedAdDataArray) {
        KSGDT_NativeExpressAdViewAdapter *adapter = [[KSGDT_NativeExpressAdViewAdapter alloc] initWithFeedAd:feedAd];
        adapter.connector = self.connector;
        [viewAdapters addObject:adapter];
    }
    
    self.viewAdapters = viewAdapters;
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdSuccessToLoad:viewAdapters:)]) {
        [self.connector adapter_nativeExpressAdSuccessToLoad:self viewAdapters:[viewAdapters copy]];
    }
}

- (void)feedAdsManager:(KSFeedAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdFailToLoad:error:)]) {
        [self.connector adapter_nativeExpressAdFailToLoad:self error:error];
    }
}

@end
