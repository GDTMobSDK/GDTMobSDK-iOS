//
//  BUGDT_UnifiedNativeAdAdapter.m
//  GDTMobSDK
//
//  Created by Nancy on 2019/6/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedNativeAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import "BUGDT_UnifiedNativeDataObjectAdapter.h"
#import "MediationAdapterUtil.h"
#import "BUGDT_UnifiedNativeAdDelegateObject.h"

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_UnifiedNativeAdAdapter ()
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BUNativeAdsManager *adManager;
@property (nonatomic, strong) BUGDT_UnifiedNativeAdDelegateObject *delegateObject;
@property (nonatomic, copy) NSString *posId;

@end
@implementation BUGDT_UnifiedNativeAdAdapter
@dynamic maxVideoDuration;
@dynamic minVideoDuration;

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

- (instancetype)initWithAdNetworkConnector:(id<GDTUnifiedNativeAdNetworkConnectorProtocol>)connector
                                     posId:(nonnull NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAdWithCount:(NSInteger)count {
    if (count == 0) {
        return;
    }
        
    BUAdSlot *slot1 = [[BUAdSlot alloc] init];
    BUSize *imgSize1 = [[BUSize alloc] init];
    imgSize1.width = 1920;
    imgSize1.height = 1080;
    slot1.ID = self.posId;
    slot1.AdType = BUAdSlotAdTypeFeed;
    slot1.position = BUAdSlotPositionFeed;
    slot1.imgSize = imgSize1;
    
    self.delegateObject = [[BUGDT_UnifiedNativeAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    
    BUNativeAdsManager *adsManager = [[BUNativeAdsManager alloc] initWithSlot:slot1];
    adsManager.delegate = self.delegateObject;
    self.adManager = adsManager;
        
    [self.adManager loadAdDataWithCount:count];
}

- (NSInteger)eCPM {
    BUGDT_UnifiedNativeDataObjectAdapter *firstAd = [self.delegateObject.adArray firstObject];
    if (firstAd && [firstAd respondsToSelector:@selector(eCPM)]) {
        return [firstAd eCPM];
    }
    else {
        return -1;
    }
}

@end
