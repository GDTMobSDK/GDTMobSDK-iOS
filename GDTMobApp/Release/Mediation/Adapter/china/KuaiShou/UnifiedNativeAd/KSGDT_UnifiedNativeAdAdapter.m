//
//  KSGDT_UnifiedNativeAdAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/2.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_UnifiedNativeAdAdapter.h"
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSAdSDK.h>
#import "MediationAdapterUtil.h"
#import "KSGDT_UnifiedNativeDataObjectAdapter.h"
#import "KSGDT_UnifiedNativeAdDelegateObject.h"

@interface KSGDT_UnifiedNativeAdAdapter () 
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol> connector;
@property (nonatomic, strong) KSNativeAdsManager *nativeAdsManager;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) KSGDT_UnifiedNativeAdDelegateObject *delegateObject;

@end

@implementation KSGDT_UnifiedNativeAdAdapter
@synthesize minVideoDuration;
@synthesize maxVideoDuration;

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

- (instancetype)initWithAdNetworkConnector:(id<GDTUnifiedNativeAdNetworkConnectorProtocol>)connector
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

- (void)loadAdWithCount:(NSInteger)count {
    self.delegateObject = [[KSGDT_UnifiedNativeAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    
    self.nativeAdsManager = [[KSNativeAdsManager alloc] initWithPosId:self.posId];
    self.nativeAdsManager.delegate = self.delegateObject;
    [self.nativeAdsManager loadAdDataWithCount:count];
}

- (NSInteger)eCPM {
    if ([self.delegateObject.nativeAdArray count] > 0) {
        return [[self.delegateObject.nativeAdArray firstObject] eCPM];
    }
    else {
        return -1;
    }
}

@end
