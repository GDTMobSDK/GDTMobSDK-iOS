//
//  BUGDT_NativeExpressAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/7/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "BUGDT_NativeExpressAdAdapter.h"
#import "GDTNativeExpressAdNetworkConnectorProtocol.h"
#import <BUAdSDK/BUAdSDK.h>
#import "MediationAdapterUtil.h"
#import "BUGDT_NativeExpressAdViewAdapter.h"

static BOOL s_sdkInitializationSuccess = NO;

@interface BUGDT_NativeExpressAdAdapter () <BUNativeExpressAdViewDelegate>

@property (nonatomic, weak) id <GDTNativeExpressAdNetworkConnectorProtocol>connector;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) BUNativeExpressAdManager *nativeExpressAdManager;
@property (nonatomic, copy) NSDictionary *playerStatusMap;
@property (nonatomic, copy) NSArray<BUGDT_NativeExpressAdViewAdapter *> *viewAdapters;
@property (nonatomic, strong) NSMutableSet *exposuredSet;

@end

@implementation BUGDT_NativeExpressAdAdapter
@synthesize adSize = _adSize;

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

- (instancetype)initWithAdNetworkConnector:(id<GDTNativeExpressAdNetworkConnectorProtocol>)connector posId:(NSString *)posId {
    if (!connector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
        
        //typedef NS_ENUM(NSUInteger, GDTMediaPlayerStatus) {
        //    GDTMediaPlayerStatusInitial = 0,         // 初始状态
        //    GDTMediaPlayerStatusLoading = 1,         // 加载中
        //    GDTMediaPlayerStatusStarted = 2,         // 开始播放
        //    GDTMediaPlayerStatusPaused = 3,          // 用户行为导致暂停
        //    GDTMediaPlayerStatusError = 4,           // 播放出错
        //    GDTMediaPlayerStatusStoped = 5,          // 播放停止
        //};

        //typedef NS_ENUM(NSInteger, BUPlayerPlayState) {
        //    BUPlayerStateFailed    = 0,
        //    BUPlayerStateBuffering = 1,
        //    BUPlayerStatePlaying   = 2,
        //    BUPlayerStateStopped   = 3,
        //    BUPlayerStatePause     = 4,
        //    BUPlayerStateDefalt    = 5
        //};
        
        //穿山甲播放器状态到广点通播放器状态的映射
        self.playerStatusMap = @{
            @(BUPlayerStateFailed).stringValue: @(GDTMediaPlayerStatusError),
            @(BUPlayerStateBuffering).stringValue: @(GDTMediaPlayerStatusLoading),
            @(BUPlayerStatePlaying).stringValue: @(GDTMediaPlayerStatusStarted),
            @(BUPlayerStateStopped).stringValue: @(GDTMediaPlayerStatusStoped),
            @(BUPlayerStatePause).stringValue: @(GDTMediaPlayerStatusPaused),
            @(BUPlayerStateDefalt).stringValue: @(GDTMediaPlayerStatusInitial),
        };
    }
    
    return self;
}

- (GDTMediaPlayerStatus)gdtPlayerStatus:(BUPlayerPlayState)buState {
    return (GDTMediaPlayerStatus)[self.playerStatusMap[@(buState).stringValue] integerValue];
}

- (BUGDT_NativeExpressAdViewAdapter *)viewAdapter:(BUNativeExpressAdView *)buAdView {
    __block BUGDT_NativeExpressAdViewAdapter *adapter = nil;
    [self.viewAdapters enumerateObjectsUsingBlock:^(BUGDT_NativeExpressAdViewAdapter *_Nonnull obj, NSUInteger idx,
                                                    BOOL *_Nonnull stop) {
      if ([obj adView] == buAdView) {
          adapter = obj;
          *stop = YES;
      }
    }];
    return adapter;
}

- (NSDictionary *)extraInfo {
    BUGDT_NativeExpressAdViewAdapter *adapter = [self.viewAdapters firstObject];
    if (adapter) {
        return adapter.extraInfo;
    }
    return @{};
}

- (NSInteger)eCPM {
    BUGDT_NativeExpressAdViewAdapter *adapter = [self.viewAdapters firstObject];
    if (adapter) {
        return [adapter eCPM];
    }
    else {
        return -1;
    }
}

#pragma mark - GDTNativeExpressAdNetworkAdapterProtocol

- (void)loadAdWithCount:(NSInteger)count {
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = self.posId;
    slot.AdType = BUAdSlotAdTypeFeed;
    slot.position = BUAdSlotPositionFeed;
    slot.supportRenderControl = YES;
    slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    self.adSize = CGSizeMake(self.adSize.width, 0);
    self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot adSize:self.adSize];
    self.nativeExpressAdManager.delegate = self;
    [self.nativeExpressAdManager loadAdDataWithCount:count];
}

#pragma mark - BUNativeExpressAdViewDelegate

- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    NSMutableArray<BUGDT_NativeExpressAdViewAdapter *> *viewAdapters = [NSMutableArray array];
    for (BUNativeExpressAdView *buAdView in views) {
        BUGDT_NativeExpressAdViewAdapter *adapter = [[BUGDT_NativeExpressAdViewAdapter alloc] initWithBUNativeExpressAdView:buAdView];
        [viewAdapters addObject:adapter];
    }
    self.viewAdapters = viewAdapters;
    self.exposuredSet = [NSMutableSet set];
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdSuccessToLoad:viewAdapters:)]) {
        [self.connector adapter_nativeExpressAdSuccessToLoad:self viewAdapters:[viewAdapters copy]];
    }
}

- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *_Nullable)error {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdFailToLoad:error:)]) {
        [self.connector adapter_nativeExpressAdFailToLoad:self error:error];
    }
}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterRenderSuccess:)]) {
        id<GDTNativeExpressAdViewAdapterProtocol> adapter = [self viewAdapter:nativeExpressAdView];
        [adapter resize];
        [self.connector adapter_nativeExpressAdViewAdapterRenderSuccess:adapter];
    }
}

- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *_Nullable)error {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterRenderFail:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterRenderFail:[self viewAdapter:nativeExpressAdView]];
    }
}

- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView {
    if ([self.exposuredSet containsObject:nativeExpressAdView]) {
        return;
    }
    [self.exposuredSet addObject:nativeExpressAdView];
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterExposure:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterExposure:[self viewAdapter:nativeExpressAdView]];
    }
}

- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClicked:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClicked:[self viewAdapter:nativeExpressAdView]];
    }
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapter:playerStatusChanged:)]) {
        [self.connector adapter_nativeExpressAdViewAdapter:[self viewAdapter:nativeExpressAdView] playerStatusChanged:[self gdtPlayerStatus:playerState]];
    }
}

- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    // 与player状态变至BUPlayerStateStopped相同回调
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    // 无对应回调
}

- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterWillPresentScreen:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterWillPresentScreen:[self viewAdapter:nativeExpressAdView]];
    }
}

- (void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterDidDissmissScreen:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterDidDissmissScreen:[self viewAdapter:nativeExpressAdView]];
    }
}

- (void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClosed:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClosed:[self viewAdapter:nativeExpressAdView]];
    }
}


@end
