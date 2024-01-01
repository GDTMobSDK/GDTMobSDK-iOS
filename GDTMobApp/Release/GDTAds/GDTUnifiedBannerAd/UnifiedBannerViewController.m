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

static const NSUInteger kBannerMinHeight = 48;//banner最小高度
static const CGFloat kBannerMaxLayoutAspectRatio = 0.32; //banner最大高宽比

@interface UnifiedBannerViewController () <GDTUnifiedBannerViewDelegate>
@property (nonatomic, strong) GDTUnifiedBannerView *bannerView;
 
@property (weak, nonatomic) IBOutlet UITextField *placementIdText;
@property (weak, nonatomic) IBOutlet UITextField *refreshIntervalText;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (weak, nonatomic) IBOutlet UISlider *heightSlide;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UISlider *layoutAspectRatioSlide;
@property (weak, nonatomic) IBOutlet UILabel *layoutAspectRatioLabel;
@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, assign) BOOL useToken;

@end

@implementation UnifiedBannerViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    //[self loadAdAndShow:nil];
}

- (void)setupViews {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.heightSlide.minimumValue = kBannerMinHeight;
    self.heightSlide.maximumValue = screenWidth * kBannerMaxLayoutAspectRatio;
    self.heightSlide.value = 60;
    self.layoutAspectRatioSlide.minimumValue = kBannerMinHeight / screenWidth;//根据新banner模版规则（广告位高宽比最大值为0.32）
    self.layoutAspectRatioSlide.maximumValue = kBannerMaxLayoutAspectRatio;
    self.layoutAspectRatioSlide.value = self.heightSlide.value / screenWidth;
    self.heightLabel.text = [NSString stringWithFormat:@"%d", (int)self.heightSlide.value];
    self.layoutAspectRatioLabel.text = [NSString stringWithFormat:@"%0.3f", self.layoutAspectRatioSlide.value];
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

- (IBAction)slideValueChanged:(id)sender {
    if (sender == self.heightSlide) {
        self.heightLabel.text = [NSString stringWithFormat:@"%d", (int)self.heightSlide.value];
    }else if(sender == self.layoutAspectRatioSlide){
        self.layoutAspectRatioLabel.text = [NSString stringWithFormat:@"%0.3f", self.layoutAspectRatioSlide.value];
    }
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择广告位" message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"广点通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdText.text = nil;
    }];
    UIAlertAction *flowDistributionAction = [UIAlertAction actionWithTitle:@"流量分配" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdText.text = [self mediationId];
    }];
    [alert addAction:defaultAction];
    [alert addAction:flowDistributionAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (alert.popoverPresentationController) {
        [alert.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        alert.popoverPresentationController.sourceView=self.view;
        alert.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [self presentViewController:alert animated:YES completion:nil];
}


- (NSString *)mediationId {
    return @"101370";
}

#pragma mark - property getter
- (GDTUnifiedBannerView *)bannerView
{
    if (!_bannerView) {
        NSUInteger height = self.heightSlide.value;
        CGFloat width = height / self.layoutAspectRatioSlide.value;
        CGRect rect = {CGPointZero, CGSizeMake(width,height)};
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
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTUnifiedBannerView *)ad {
    NSInteger fakeWinPrice = 200;
    NSInteger fakeHighestPrice = 100;
    GDTAdBiddingLossReason fakeLossReason = GDTAdBiddingLossReasonLowPrice;
    NSString *fakeAdnId = @"WinAdnId";
    NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_setting_bidding_report"];
    NSInteger reportFlag = flag ? [flag integerValue] : 1;
    if (reportFlag == 1) {
        [ad sendWinNotificationWithInfo:@{GDT_M_W_E_COST_PRICE: @(fakeWinPrice), GDT_M_W_H_LOSS_PRICE: @(fakeHighestPrice)}];
    } else if (reportFlag == 2) {
        [ad sendLossNotificationWithInfo:@{GDT_M_L_WIN_PRICE: @(fakeWinPrice), GDT_M_L_LOSS_REASON:@(fakeLossReason), GDT_M_ADNID: fakeAdnId}];
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


