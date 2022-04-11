//
//  BUGDT_UnifiedInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2022/3/11.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "BUGDT_UnifiedInterstitialAdAdapter.h"
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"
#import <BUAdSDK/BUAdSDK.h>

static CGSize const dislikeSize = {15, 15};
static CGSize const logoSize = {20, 20};
#define leftEdge 20
#define titleHeight 40

@interface BUGDT_UnifiedInterstitialAdAdapter ()<BUNativeAdDelegate, BUFullscreenVideoAdDelegate>
@property (nonatomic, strong) BUNativeAd *nativeAd;
@property (nonatomic, strong) BUFullscreenVideoAd *fullscreenVideoAd;
@property (nonatomic, weak) id<GDTUnifiedInterstitialAdNetworkConnectorProtocol> connector;
@property (nonatomic, copy) NSString *slotID;
// native UI
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *describeLable;
@property (nonatomic, strong) UIButton *dowloadButton;
@property (nonatomic, strong) UIImageView *interstitialAdView;
@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;
@property (nonatomic, strong) UIImageView *logoImgeView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *buContentView;

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
    if (self.shouldLoadFullscreenAd) {
        self.fullscreenVideoAd = [[BUFullscreenVideoAd alloc] initWithSlotID:self.slotID];
        self.fullscreenVideoAd.delegate = self;
        [self.fullscreenVideoAd loadAdData];
        return;
    }
    BUSize *imgSize1 = [[BUSize alloc] init];
    imgSize1.width = 1080;
    imgSize1.height = 1920;
    
    BUAdSlot *slot1 = [[BUAdSlot alloc] init];
    slot1.ID = self.slotID;
    slot1.AdType = BUAdSlotAdTypeInterstitial;
    slot1.imgSize = imgSize1;
    slot1.isOriginAd = YES;
    slot1.adSize = CGSizeMake(300, 300);
    
    BUNativeAd *nad = [[BUNativeAd alloc] initWithSlot:slot1];
    // 不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。
    nad.delegate = self;
    self.nativeAd = nad;
    [nad loadAdData];
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController
{
    if (self.shouldShowFullscreenAd) {
        [self.fullscreenVideoAd showAdFromRootViewController:rootViewController];
        return;
    }
    self.nativeAd.rootViewController = rootViewController;
    [self buildupViewWithRootViewController:rootViewController];
    [self showBuNativeAdWithRootViewController:rootViewController];
}


- (BOOL)isAdValid {
    return YES;
}

- (NSInteger)eCPM {
    if (self.shouldLoadFullscreenAd) {
        if ([self.fullscreenVideoAd.mediaExt objectForKey:@"price"]) {
            return [[self.fullscreenVideoAd.mediaExt objectForKey:@"price"] integerValue];
        }
        return -1;
    }
    // native没有返回
    return -1;
}

- (NSDictionary *)extraInfo {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    if (self.shouldLoadFullscreenAd) {
        if ([self.fullscreenVideoAd.mediaExt objectForKey:@"request_id"]) {
            [res setObject:[self.fullscreenVideoAd.mediaExt objectForKey:@"request_id"] forKey:GDT_REQ_ID_KEY];
        }
    }
    return [res copy];
}

//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    if (self.shouldLoadFullscreenAd) {
        [self.fullscreenVideoAd win:@(price)];
        return;
    }
    [self.nativeAd win:@(price)];
}

//发送竞败结果
- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    if (self.shouldLoadFullscreenAd) {
        [self.fullscreenVideoAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
        return;
    }
    [self.nativeAd loss:@(price) lossReason:[NSString stringWithFormat:@"%ld", (long)reason] winBidder:adnId];
}

//设置实际结算价
- (void)setBidECPM:(NSInteger)price {
    if (self.shouldLoadFullscreenAd) {
        [self.fullscreenVideoAd setPrice:@(price)];
        return;
    }
    [self.nativeAd setPrice:@(price)];
}

- (void)buildupViewWithRootViewController:(UIViewController *)viewController {
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.backgroundView.hidden = YES;
    [viewController.view addSubview:self.backgroundView];
    
    self.whiteBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.whiteBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.whiteBackgroundView];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLable.textAlignment = NSTextAlignmentLeft;
    self.titleLable.font = [UIFont systemFontOfSize:17];
    [self.whiteBackgroundView addSubview:self.titleLable];
    
    self.describeLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.describeLable.textAlignment = NSTextAlignmentLeft;
    self.describeLable.font = [UIFont systemFontOfSize:13];
    self.describeLable.textColor = [UIColor lightGrayColor];
    [self.whiteBackgroundView addSubview:self.describeLable];
    
    self.dowloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dowloadButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:92/255.0 alpha:1];
    self.dowloadButton.layer.cornerRadius = 5;
    self.dowloadButton.clipsToBounds = YES;
    [self.whiteBackgroundView addSubview:self.dowloadButton];
    
    self.interstitialAdView = [[UIImageView alloc] init];
    _interstitialAdView.contentMode =  UIViewContentModeScaleAspectFill;
    _interstitialAdView.userInteractionEnabled = YES;
    _interstitialAdView.clipsToBounds = YES;
    [self.whiteBackgroundView addSubview:_interstitialAdView];
    
    self.relatedView = [[BUNativeAdRelatedView alloc] init];
    self.logoImgeView = self.relatedView.logoImageView;
    [self.whiteBackgroundView addSubview:self.logoImgeView];
    
    [self.relatedView.dislikeButton setImage:[UIImage new] forState:UIControlStateNormal];
    [self.relatedView.dislikeButton setTitle:@"反馈" forState:UIControlStateNormal];
    [self.relatedView.dislikeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.relatedView.dislikeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.whiteBackgroundView addSubview:self.relatedView.dislikeButton];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"nativeDislike.png"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:_closeButton];
}

- (void)closeButtonTouchUpInside:(id)sender {
    [self pbud_closeInterstitial];
}

- (void)pbud_closeInterstitial {
    self.backgroundView.hidden = YES;
    self.interstitialAdView.image = nil;
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
}

- (void)bud_removeAllSubViews:(UIView *)view {
    NSArray *ary = [view.subviews copy];
    for (UIView *view in ary) {
        [view removeFromSuperview];
    }
}

- (void)showBuNativeAdWithRootViewController:(UIViewController *)viewController {
    [self bud_removeAllSubViews:self.interstitialAdView];
    self.whiteBackgroundView.hidden = NO;
    self.backgroundView.hidden = NO;
    self.interstitialAdView.hidden = NO;
    
    if (self.buContentView) {
        [self.interstitialAdView addSubview:self.buContentView];
        CGFloat width = self.buContentView.frame.size.width;
        CGFloat height = self.buContentView.frame.size.height;
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0f;
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - height) / 2.0f;
        self.interstitialAdView.frame = CGRectMake(0, 0, width, height);
        self.whiteBackgroundView.frame = CGRectMake(x, y, width, height);
    } else {
        [self bud_removeAllSubViews:self.interstitialAdView];
        self.titleLable.text = self.nativeAd.data.AdTitle;
        
        BUImage *adImage = self.nativeAd.data.imageAry.firstObject;
        CGFloat contentWidth = CGRectGetWidth(viewController.view.bounds) - 2*leftEdge - 2*5;
        CGFloat imageViewHeight = contentWidth * adImage.height/ adImage.width;
        self.interstitialAdView.frame = CGRectMake(5, titleHeight, contentWidth, imageViewHeight);
        [self layoutView:viewController.view withimageViewHeight:imageViewHeight];
        
        if (adImage.imageURL.length) {
            [MediationAdapterUtil imageView:self.interstitialAdView setImageUrl:adImage.imageURL placeholderImage:nil];
        }
        
        self.describeLable.frame = CGRectMake(13, CGRectGetMaxY(self.interstitialAdView.frame) + 5, CGRectGetWidth(self.describeLable.bounds), CGRectGetHeight(self.describeLable.bounds));
        self.describeLable.text = self.nativeAd.data.AdDescription;
        
        self.dowloadButton.frame = CGRectMake((CGRectGetWidth(self.whiteBackgroundView.bounds) - CGRectGetWidth(self.dowloadButton.bounds))/2, CGRectGetMaxY(self.describeLable.frame) + 5,   CGRectGetWidth(self.dowloadButton.frame), CGRectGetHeight(self.dowloadButton.frame));
        [self.dowloadButton setTitle:self.nativeAd.data.buttonText forState:UIControlStateNormal];
        
        [self.nativeAd registerContainer:self.whiteBackgroundView    withClickableViews:@[self.titleLable,self.interstitialAdView,self.describeLable,self.dowloadButton]];
        [self.relatedView refreshData:self.nativeAd];
    }
}

- (void)layoutView:(UIView *)view withimageViewHeight:(CGFloat)imageViewHeight {
    CGFloat whiteViewHeight = titleHeight + imageViewHeight + 10 + titleHeight + 10 + 30;
    self.whiteBackgroundView.frame = CGRectMake(leftEdge, (CGRectGetHeight(view.frame) - whiteViewHeight)/2, CGRectGetWidth(view.frame)-2*leftEdge, whiteViewHeight);
    
    self.titleLable.frame = CGRectMake(13, 0, CGRectGetWidth(self.whiteBackgroundView.frame) - 2*13 , titleHeight);
    self.describeLable.frame = CGRectMake(0, 0, CGRectGetWidth(self.whiteBackgroundView.frame) - 2*13 , titleHeight);
    self.dowloadButton.frame = CGRectMake(0, 0, 200, 30);
    
    CGFloat margin = 5;
    CGFloat logoIconX = CGRectGetWidth(self.whiteBackgroundView.bounds) - logoSize.width - margin;
    CGFloat logoIconY = CGRectGetHeight(self.whiteBackgroundView.frame) - logoSize.height - margin;
    self.logoImgeView.frame = CGRectMake(logoIconX, logoIconY, logoSize.width, logoSize.height);
    self.relatedView.dislikeButton.frame = CGRectMake(5, CGRectGetHeight(self.whiteBackgroundView.frame) - 30.0, 30.0, 30.0);
    
    self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.whiteBackgroundView.frame)-dislikeSize.width , CGRectGetMinY(self.whiteBackgroundView.frame)-dislikeSize.height-10, dislikeSize.width, dislikeSize.height);
}

#pragma mark - BUNativeAdDelegate
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd view:(UIView *_Nullable)view {
    self.buContentView = view;
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self];
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self error:error];
}

- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [self.connector adapter_unifiedInterstitialWillExposure:self];
}

- (void)nativeAdDidCloseOtherController:(BUNativeAd *)nativeAd interactionType:(BUInteractionType)interactionType {}

- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    [self.connector adapter_unifiedInterstitialClicked:self];
}

- (void)nativeAd:(BUNativeAd *_Nullable)nativeAd dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterWords {
    [self.connector adapter_adComplainSuccess:self];
}

- (void)nativeAd:(BUNativeAd *_Nullable)nativeAd adContainerViewDidRemoved:(UIView *)adContainerView {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
}

#pragma mark - BUFullscreenVideoAdDelegate
- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self];
}

- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    [self.connector adapter_unifiedInterstitialFailToLoadAd:self error:error];
}

- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {}

- (void)fullscreenVideoAdWillVisible:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialWillExposure:self];
    [self.connector adapter_unifiedInterstitialWillPresentScreen:self];
}

- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidPresentScreen:self];
}

- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialClicked:self];
}

- (void)fullscreenVideoAdWillClose:(BUFullscreenVideoAd *)fullscreenVideoAd {}

- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd {
    [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
}

- (void)fullscreenVideoAdDidPlayFinish:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    if (error) {
        [self.connector adapter_unifiedInterstitialAd:self playerStatusChanged:GDTMediaPlayerStatusError];
    } else {
        [self.connector adapter_unifiedInterstitialAd:self playerStatusChanged:GDTMediaPlayerStatusStoped];
    }
}

- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd {}

- (void)fullscreenVideoAdCallback:(BUFullscreenVideoAd *)fullscreenVideoAd withType:(BUFullScreenVideoAdType)fullscreenVideoAdType {}

@end
