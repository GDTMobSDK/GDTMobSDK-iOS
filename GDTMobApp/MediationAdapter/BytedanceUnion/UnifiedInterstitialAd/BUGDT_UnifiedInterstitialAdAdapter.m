//
//  BUGDT_UnifiedInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/8/10.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedInterstitialAdAdapter.h"
#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import "BUGDT_UnifiedInterstitialAdDelegateObject.h"

@interface BUGDT_UnifiedInterstitialAdAdapter () 

@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) BUFullscreenVideoAd *fullscreenAd;
@property (nonatomic, copy) NSString *slotID;
@property (nonatomic, strong) BUGDT_UnifiedInterstitialAdDelegateObject *delegateObject;

@end

@implementation BUGDT_UnifiedInterstitialAdAdapter
@synthesize shouldLoadFullscreenAd;
@synthesize shouldShowFullscreenAd;

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

- (nullable instancetype)initWithAdNetworkConnector:(nonnull id<GDTUnifiedInterstitialAdNetworkConnectorProtocol>)connector
                                              posId:(nonnull NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.connector = connector;
        self.slotID = posId;
    }
    
    return self;
}

- (void)loadAd {
    self.delegateObject = [[BUGDT_UnifiedInterstitialAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    
    self.fullscreenAd = [[BUFullscreenVideoAd alloc] initWithSlotID:self.slotID];
    self.fullscreenAd.delegate = self.delegateObject;
    [self.fullscreenAd loadAdData];
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    [self.fullscreenAd showAdFromRootViewController:rootViewController];
}

- (BOOL)isAdValid {
    return self.delegateObject.fullscreenAdDidLoad;
}

- (NSInteger)eCPM {
    if ([self.fullscreenAd.mediaExt objectForKey:@"price"]) {
        return [[self.fullscreenAd.mediaExt objectForKey:@"price"] integerValue];
    }
    
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if ([self.fullscreenAd.mediaExt objectForKey:@"request_id"]) {
        [res setObject:[self.fullscreenAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
    }
    return [res copy];
}

@end
