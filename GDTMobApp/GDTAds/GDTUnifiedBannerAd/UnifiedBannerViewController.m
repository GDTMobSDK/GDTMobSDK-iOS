//
//  UnifiedBannerViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/7.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedBannerViewController.h"
#import "GDTUnifiedBannerView.h"
#import "GDTAppDelegate.h"
#import "S2SBiddingManager.h"

#define DEMO_BANNER_WIDTH GDTScreenWidth
#define DEMO_BANNER_HEIGHT (DEMO_BANNER_WIDTH / 6.4)

@interface UnifiedBannerViewController () <GDTUnifiedBannerViewDelegate>
@property (nonatomic, strong) GDTUnifiedBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITextField *placementIdText;
@property (weak, nonatomic) IBOutlet UITextField *refreshIntervalText;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;

@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, assign) BOOL useToken;

@end

@implementation UnifiedBannerViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAdAndShow:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAdAndShow:(id)sender {
    if (self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }

    [self.view addSubview:self.bannerView];
    [self.bannerView loadAdAndShow];
}

- (IBAction)removeAd:(id)sender {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

- (IBAction)handleGetToken:(id)sender {
    __weak __typeof(self) ws = self;
    NSString *placementId = self.placementIdText.text.length > 0 ? self.placementIdText.text: self.placementIdText.placeholder;
    [S2SBiddingManager getTokenWithPlacementId:placementId completion:^(NSString * _Nonnull token) {
        ws.token = token;
        ws.tokenLabel.text = self.token;
    }];
}

- (IBAction)handleUseToken:(UISwitch *)sender {
    self.useToken = sender.isOn;
}

- (void)setupBannerView:(GDTUnifiedBannerView *)bannerView {}

- (IBAction)choosePlacementId:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择广告位" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"广点通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdText.text = nil;
    }];
    UIAlertAction *flowDistributionAction = [UIAlertAction actionWithTitle:@"流量分配" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdText.text = @"100013";
    }];
    [alert addAction:defaultAction];
    [alert addAction:flowDistributionAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - property getter
- (GDTUnifiedBannerView *)bannerView
{
    if (!_bannerView) {
        CGRect rect = {CGPointZero, CGSizeMake(DEMO_BANNER_WIDTH, DEMO_BANNER_HEIGHT)};
        NSString *placementId = self.placementIdText.text.length > 0 ? self.placementIdText.text: self.placementIdText.placeholder;
        if (self.useToken) {
            _bannerView = [[GDTUnifiedBannerView alloc] initWithPlacementId:placementId
                                                                      token:self.token viewController:self];
            _bannerView.frame = rect;
        } else {
            _bannerView = [[GDTUnifiedBannerView alloc] initWithFrame:rect
                                                          placementId:placementId viewController:self];
        }
        _bannerView.accessibilityIdentifier = @"banner_ad";
        _bannerView.animated = self.animationSwitch.on;
        _bannerView.autoSwitchInterval = [self.refreshIntervalText.text intValue];
        _bannerView.delegate = self;
        [self setupBannerView:_bannerView];
    }
    return _bannerView;
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTUnifiedBannerView *)ad {
    NSInteger fakeWinPrice = 100;
    GDTAdBiddingLossReason fakeLossReason = GDTAdBiddingLossReasonLowPrice;
    NSString *fakeAdnId = @"WinAdnId";
    NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_setting_bidding_report"];
    NSInteger reportFlag = flag ? [flag integerValue] : 1;
    if (reportFlag == 1) {
        [ad sendWinNotificationWithPrice:fakeWinPrice];
    } else if (reportFlag == 2) {
        [ad sendLossNotificationWithWinnerPrice:fakeWinPrice lossReason:fakeLossReason winnerAdnID:fakeAdnId];
    }
}

#pragma mark - GDTUnifiedBannerViewDelegate
/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"unified banner did load");
    NSLog(@"ecpm %ld ecpmLevel:%@", unifiedBannerView.eCPM, unifiedBannerView.eCPMLevel);
    NSLog(@"extraInfo: %@", unifiedBannerView.extraInfo);
    // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [unifiedBannerView setBidECPM:100];
    } else {
        [self reportBiddingResult:unifiedBannerView];
    }
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  应用进入后台时调用
 *  当点击应用下载或者广告调用系统程序打开，应用将被自动切换到后台
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    // 真正关闭
//    [self.bannerView removeFromSuperview];
//    self.bannerView = nil;
    NSLog(@"%s",__FUNCTION__);
}

/**
 *   投诉成功回调
 */
- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"广告投诉成功");
}

@end


