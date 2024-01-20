//
//  SplashViewContronller.m
//  GDTMobApp
//
//  Created by GaoChao on 15/8/21.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "SplashViewController.h"
#import "GDTSplashAd.h"
#import "GDTAppDelegate.h"
#import "S2SBiddingManager.h"

static NSString *IMAGE_AD_PLACEMENTID = @"2023121674786777";
static NSString *VIDEO_AD_PLACEMENTID = @"7003628706619303";

@interface SplashViewController () <GDTSplashAdDelegate>

@property (nonatomic, strong) GDTSplashAd *splashAd;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *logoHeightTextField;
@property (weak, nonatomic) IBOutlet UILabel *logoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, assign) BOOL isParallelLoad;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL useToken;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, weak) IBOutlet UILabel *adValidLabel;
@end

@implementation SplashViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logoHeightTextField.text = [NSString stringWithFormat:@"%@", @([[UIScreen mainScreen] bounds].size.height * 0.12)] ;
    self.logoDescLabel.text = [NSString stringWithFormat:@"底部logo高度上限：\n %@(屏幕高度) * 12%% = %@", @([[UIScreen mainScreen] bounds].size.height), @([[UIScreen mainScreen] bounds].size.height * 0.12)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)preloadContractSplashAd:(id)sender {
    self.isParallelLoad = NO;
    self.tipsLabel.text = nil;
    NSString *placementId = self.placementIdTextField.text.length > 0?self.placementIdTextField.text:self.placementIdTextField.placeholder;
    GDTSplashAd *preloadSplashAd = [[GDTSplashAd alloc] initWithPlacementId:placementId];
    [preloadSplashAd preloadSplashOrderWithPlacementId:placementId];
}
- (IBAction)changePlacementID:(id)sender {
    UIAlertController *changePosIdController = [UIAlertController alertControllerWithTitle:@"选择广告类型" message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    if (changePosIdController.popoverPresentationController) {
        [changePosIdController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        changePosIdController.popoverPresentationController.sourceView=self.view;
        changePosIdController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    UIAlertAction *portraitLandscapeAdIdAction = [UIAlertAction actionWithTitle:@"图文广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.placeholder = IMAGE_AD_PLACEMENTID;
    }];
    [changePosIdController addAction:portraitLandscapeAdIdAction];
    
    UIAlertAction *videoAdIdAction = [UIAlertAction actionWithTitle:@"视频广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           self.placementIdTextField.placeholder = VIDEO_AD_PLACEMENTID;
    }];
    [changePosIdController addAction:videoAdIdAction];
    
    UIAlertAction *mediationAdIdAction = [UIAlertAction actionWithTitle:@"流量分配广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.placeholder = [self mediationId];
    }];
    
    [changePosIdController addAction:mediationAdIdAction];
    [changePosIdController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:changePosIdController animated:YES completion:nil];
}

- (NSString *)mediationId {
    return @"101371";
}

- (IBAction)parallelLoadAd:(id)sender {
    self.tipsLabel.text = nil;
    self.isParallelLoad = YES;
    self.tipsLabel.text = @"拉取中...";

    self.splashAd = [self createASplashAd];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    self.splashAd.backgroundImage = [self getLaunchScreenImage];
    self.splashAd.backgroundImage.accessibilityIdentifier = @"splash_ad";
    [self setupSplashAd:self.splashAd];
    [self.splashAd loadAd];
}

- (void)setupSplashAd:(GDTSplashAd *)splashAd {}

- (IBAction)parallelShowAd:(id)sender {
    if (self.isParallelLoad) {
        CGFloat logoHeight = [self.logoHeightTextField.text floatValue];
        if (logoHeight > 0 && logoHeight <= [[UIScreen mainScreen] bounds].size.height * 0.25) {
            self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, logoHeight)];
            self.bottomView.backgroundColor = [UIColor whiteColor];
            UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashLogo"]];
            logo.accessibilityIdentifier = @"splash_logo";
            logo.frame = CGRectMake(0, 0, 140, 34.65);
            logo.center = self.bottomView.center;
            [self.bottomView addSubview:logo];
        } else {
            return;
        }
        
        UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
        [self.splashAd showAdInWindow:fK withBottomView:self.bottomView skipView:nil];
    }
}

- (IBAction)loadFullscreenAd:(id)sender {
    self.tipsLabel.text = nil;
    self.isParallelLoad = YES;
    self.tipsLabel.text = @"拉取中...";

    self.splashAd = [self createASplashAd];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    self.splashAd.backgroundImage = [self getLaunchScreenImage];;
    self.splashAd.backgroundImage.accessibilityIdentifier = @"splash_ad";
    [self setupSplashAd:self.splashAd];
    [self.splashAd loadFullScreenAd];
}

- (IBAction)showFullscreenAd:(id)sender {
    if (!self.isParallelLoad) return;
    
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [self.splashAd showFullScreenAdInWindow:fK withLogoImage:[UIImage imageNamed:@"SplashLogo"] skipView:nil];
}

- (IBAction)loadAndShowAd:(id)sender {
    self.tipsLabel.text = nil;
    self.isParallelLoad = NO;
    self.tipsLabel.text = @"拉取中...";

    self.splashAd = [self createASplashAd];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    self.splashAd.backgroundImage = [self getLaunchScreenImage];;
    self.splashAd.backgroundImage.accessibilityIdentifier = @"splash_ad";
    [self setupSplashAd:self.splashAd];
    
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    CGFloat logoHeight = [self.logoHeightTextField.text floatValue];
    if (logoHeight > 0 && logoHeight <= [[UIScreen mainScreen] bounds].size.height * 0.25) {
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, logoHeight)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashLogo"]];
        logo.accessibilityIdentifier = @"splash_logo";
        logo.frame = CGRectMake(0, 0, 140, 34.65);
        logo.center = self.bottomView.center;
        [self.bottomView addSubview:logo];
    } else {
        return;
    }
    [self.splashAd loadAdAndShowInWindow:fK withBottomView:self.bottomView skipView:nil];
}

- (IBAction)loadAndShowFullScreenAd:(id)sender {
    self.tipsLabel.text = nil;
    self.isParallelLoad = NO;
    self.tipsLabel.text = @"拉取中...";

    self.splashAd = [self createASplashAd];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    self.splashAd.backgroundImage = [self getLaunchScreenImage];;
    self.splashAd.backgroundImage.accessibilityIdentifier = @"splash_ad";
    [self setupSplashAd:self.splashAd];
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [self.splashAd loadAdAndShowFullScreenInWindow:fK withLogoImage:nil skipView:nil];
}

- (IBAction)handleUseToken:(UISwitch *)sender {
    self.useToken = sender.isOn;
}

- (IBAction)handleGetS2SToken:(UIButton *)sender {
    __weak __typeof(self) ws = self;
    NSString *placementId = self.placementIdTextField.text.length > 0?self.placementIdTextField.text:self.placementIdTextField.placeholder;
    [S2SBiddingManager getTokenWithPlacementId:placementId completion:^(NSString * _Nonnull token) {
        ws.token = token;
        ws.tokenLabel.text = ws.token;
        if (token) {
            ws.tipsLabel.text = @"token 获取成功";
        } else {
            ws.tipsLabel.text = @"token 获取失败";
        }
    }];
}

- (GDTSplashAd *)createASplashAd {
    GDTSplashAd *splashAd = nil;
    NSString *placementId = self.placementIdTextField.text.length > 0?self.placementIdTextField.text:self.placementIdTextField.placeholder;
    if (self.useToken) {
        splashAd = [[GDTSplashAd alloc] initWithPlacementId:placementId token:self.token];
    } else {
        splashAd = [[GDTSplashAd alloc] initWithPlacementId:placementId];
    }
    return splashAd;
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTSplashAd *)ad {
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

- (IBAction)checkAdValidation:(id)sender {
    self.adValidLabel.text = [self.splashAd isAdValid] ? @"广告有效" : @"广告无效";
}

- (UIImage *)getLaunchScreenImage {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil];
    UIViewController *launchScreen = [storyBoard instantiateViewControllerWithIdentifier:@"launchscreen"];
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, [UIScreen mainScreen].scale);
    [launchScreen.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - GDTSplashAdDelegate

- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    NSLog(@"extraInfo: %@", splashAd.extraInfo);
    NSLog(@"%s", __func__);
    self.tipsLabel.text = [NSString stringWithFormat:@"%@ 广告拉取成功", splashAd.adNetworkName];
    NSLog(@"ecpm:%ld ecpmLevel:%@", splashAd.eCPM, splashAd.eCPMLevel);
    
    // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [splashAd setBidECPM:100];
    } else {
        [self reportBiddingResult:splashAd];
    }
}

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
    self.tipsLabel.text = @"广告展示成功";
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
    if (self.isParallelLoad) {
        self.tipsLabel.text = @"广告展示失败";
    }
    else {
        self.tipsLabel.text = @"广告拉取失败";
    }
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"广告已曝光");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"广告已点击");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
    self.splashAd = nil;
    self.tipsLabel.text = @"广告关闭";
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdLifeTime:(NSUInteger)time {
    NSLog(@"%s, 剩余时间 %lds",__FUNCTION__, time);
}


@end
