//
//  UnifiedInterstitialViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/13.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedInterstitialViewController.h"
#import "GDTUnifiedInterstitialAd.h"
#import "GDTAppDelegate.h"
#import "S2SBiddingManager.h"
#import "DemoUtil.h"

@interface UnifiedInterstitialViewController () <GDTUnifiedInterstitialAdDelegate>
@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitial;
@property (weak, nonatomic) IBOutlet UILabel *interstitialStateLabel;
@property (weak, nonatomic) IBOutlet UITextField *positionID;
@property (weak, nonatomic) IBOutlet UISwitch *videoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *detailPageVideoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoAutoPlaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *maxVideoDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *maxVideoDurationSlider;

@property (weak, nonatomic) IBOutlet UILabel *minVideoDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *minVideoDurationSlider;

//插屏视频按钮
@property (nonatomic, strong) UISwitch *changADVStyleSwitch;
@property (nonatomic, copy) NSString *placeHolderString;
@property (nonatomic, strong) UILabel * changeADVStyleLabel;

@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, assign) BOOL useToken;
@property (nonatomic, weak) IBOutlet UILabel *adValidLabel;
@end

@implementation UnifiedInterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

static NSString *CHANGE_ADVSTYLE_TEXT = @"切换插屏视频";

static NSString *VIDEO_PLACEMENT_ID_STR = @"6050298509489032";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minVideoDurationSlider.value = 5.0;
    self.maxVideoDurationSlider.value = 30.0;
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
    
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
    [self.maxVideoDurationSlider addTarget:self action:@selector(sliderMaxVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.minVideoDurationSlider addTarget:self action:@selector(sliderMinVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    
    self.changeADVStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.maxVideoDurationLabel.frame.origin.x, 299, 80, 17)];
    self.changeADVStyleLabel.text = CHANGE_ADVSTYLE_TEXT;
    self.changeADVStyleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.changeADVStyleLabel];
    
    self.placeHolderString = self.positionID.placeholder;
    self.changADVStyleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(110, 290, CGRectGetWidth(self.videoMutedSwitch.frame), CGRectGetHeight(self.videoMutedSwitch.frame))];
    [self.changADVStyleSwitch addTarget:self action:@selector(changeADVStyle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.changADVStyleSwitch];

    self.minVideoDurationSlider.maximumValue = self.maxVideoDurationSlider.maximumValue = 200;
    self.minVideoDurationSlider.minimumValue = self.maxVideoDurationSlider.minimumValue = 0;
}

- (void)changeADVStyle:(UISwitch *)sender {
    if (sender.on) {
        self.positionID.placeholder = VIDEO_PLACEMENT_ID_STR;
    } else {
        self.positionID.placeholder = self.placeHolderString;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAd:(id)sender {
    self.adValidLabel.text = @"";
    if (self.interstitial) {
        self.interstitial.delegate = nil;
    }
    
    NSString *placmentId = self.positionID.text.length > 0? self.positionID.text: self.positionID.placeholder;
    if (self.useToken) {
        self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:placmentId token:self.token];
    } else {
        self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:placmentId];
    }
    self.interstitial.delegate = self;
    self.interstitial.videoMuted = self.videoMutedSwitch.on;
    self.interstitial.detailPageVideoMuted = self.detailPageVideoMutedSwitch.on;
    self.interstitial.videoAutoPlayOnWWAN = self.videoAutoPlaySwitch.on;
    self.interstitial.minVideoDuration = (NSInteger)self.minVideoDurationSlider.value;
    self.interstitial.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;  // 如果需要设置视频最大时长，可以通过这个参数来进行设置

    [self.interstitial loadAd];
}

- (IBAction)showAd:(id)sender {
    if ([self.interstitial isAdValid]) {
        [self.interstitial presentAdFromRootViewController:self];
    }
    else {
        self.interstitialStateLabel.text = @"广告数据无效";
    }
}

- (void)sliderMaxVideoDurationChanged {
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
}

- (void)sliderMinVideoDurationChanged {
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
}

- (IBAction)changePid:(id)sender {
    UIAlertController *changePidAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告位" message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    NSArray *posIDArray = @[
                                  @[@"插屏图文", @"1050652855580392"],
                                  @[@"插屏视频", VIDEO_PLACEMENT_ID_STR],
                                  @[@"流量分配广告位", @"101369"],
    ];
    
    for (NSInteger i = 0; i < [posIDArray count]; i++) {
        UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:posIDArray[i][0]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            self.positionID.placeholder = posIDArray[i][1];
        }];
        [changePidAlertController addAction:advTypeAction];
    }
    [changePidAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (changePidAlertController.popoverPresentationController) {
        [changePidAlertController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        changePidAlertController.popoverPresentationController.sourceView=self.view;
        changePidAlertController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [self presentViewController:changePidAlertController
                       animated:YES
                     completion:nil];
}

- (IBAction)handleGetToken:(id)sender {
    __weak __typeof(self) ws = self;
    NSString *placementId = self.positionID.text.length > 0? self.positionID.text: self.positionID.placeholder;
    [S2SBiddingManager getTokenWithPlacementId:placementId completion:^(NSString * _Nonnull token) {
        ws.token = token;
        ws.tokenLabel.text = self.token;
        if (token) {
            ws.interstitialStateLabel.text = @"token 获取成功";
        } else {
            ws.interstitialStateLabel.text = @"token 获取失败";
        }
    }];
}

- (IBAction)handleUseToken:(UISwitch *)sender {
    self.useToken = sender.isOn;
}


/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTUnifiedInterstitialAd *)ad {
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
    self.adValidLabel.text = [self.interstitial isAdValid] ? @"广告有效" : @"广告无效";
}

#pragma mark - GDTUnifiedInterstitialAdDelegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"extraInfo: %@", unifiedInterstitial.extraInfo);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@ %@",INTERSTITIAL_STATE_TEXT,unifiedInterstitial.adNetworkName, @"Load Success." ];
    NSLog(@"eCPM:%ld eCPMLevel:%@", [unifiedInterstitial eCPM], [unifiedInterstitial eCPMLevel]);
    NSLog(@"videoDuration:%lf isVideo: %@", unifiedInterstitial.videoDuration, @(unifiedInterstitial.isVideoAd));
    
    // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [unifiedInterstitial setBidECPM:100];
    } else {
        [self reportBiddingResult:unifiedInterstitial];
    }
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@,Error : %@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded.",error ];
    NSLog(@"interstitial fail to load, Error : %@",error);
}


- (void)unifiedInterstitialDidDownloadVideo:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    NSLog(@"%s",__FUNCTION__);
}

- (void)unifiedInterstitialRenderSuccess:(GDTUnifiedInterstitialAd *)unifiedInterstitial {
    NSLog(@"%s",__FUNCTION__);
}

- (void)unifiedInterstitialRenderFail:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present." ];
}

- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"fail to present." ];
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." ];
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented." ];
}

/**
 *  当点击下载应用时会调用系统程序打开
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background." ];
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"广告已曝光");
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"广告已点击");
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}


/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSString *statusString = [DemoUtil videoPlayerStatusStringFromStatus:status];
    NSLog(@"%s-----status:%@",__FUNCTION__,statusString);
}

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  投诉成功回调
 */
- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}

@end
