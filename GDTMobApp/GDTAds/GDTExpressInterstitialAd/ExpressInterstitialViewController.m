//
//  ExpressInterstitialViewController.m
//  GDTMobApp
//
//  Created by nancynan on 2021/2/25.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "ExpressInterstitialViewController.h"
#import "GDTExpressInterstitialAd.h"
#import "GDTAppDelegate.h"

@interface ExpressInterstitialViewController () <GDTExpressInterstitialAdDelegate>
@property (nonatomic, strong) GDTExpressInterstitialAd *interstitial;
@property (weak, nonatomic) IBOutlet UILabel *interstitialStateLabel;
@property (weak, nonatomic) IBOutlet UITextField *positionID;
@property (weak, nonatomic) IBOutlet UISwitch *videoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *detailPageVideoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoAutoPlaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *maxVideoDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *maxVideoDurationSlider;

@property (weak, nonatomic) IBOutlet UILabel *minVideoDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *minVideoDurationSlider;

@property (nonatomic, copy) NSString *placeHolderString;
@property (nonatomic, strong) UIAlertController *advStyleAlertController;
@end

@implementation ExpressInterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.minVideoDurationSlider.value = 5.0;
    self.maxVideoDurationSlider.value = 30.0;
    
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
    
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
    [self.maxVideoDurationSlider addTarget:self action:@selector(sliderMaxVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.minVideoDurationSlider addTarget:self action:@selector(sliderMinVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    
    self.placeHolderString = self.positionID.placeholder;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAd:(id)sender {
    if (self.interstitial) {
        self.interstitial.delegate = nil;
    }
    
    self.interstitial = [[GDTExpressInterstitialAd alloc] initWithPlacementId:self.positionID.text.length > 0? self.positionID.text: self.positionID.placeholder];
    self.interstitial.delegate = self;
    self.interstitial.videoMuted = self.videoMutedSwitch.on;
    self.interstitial.detailPageVideoMuted = self.detailPageVideoMutedSwitch.on;
    self.interstitial.videoAutoPlayOnWWAN = self.videoAutoPlaySwitch.on;
    self.interstitial.minVideoDuration = (NSInteger)self.minVideoDurationSlider.value;
    self.interstitial.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;  // 如果需要设置视频最大时长，可以通过这个参数来进行设置

    [self.interstitial loadHalfScreenAd];
}

- (IBAction)showAd:(id)sender {
    [self.interstitial presentHalfScreenAdFromRootViewController:self];
}

- (void)sliderMaxVideoDurationChanged {
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
}

- (void)sliderMinVideoDurationChanged {
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
}

- (IBAction)selectADVStyle:(id)sender {
    self.advStyleAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.advStyleAlertController.popoverPresentationController) {
        [self.advStyleAlertController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        self.advStyleAlertController.popoverPresentationController.sourceView=self.view;
        self.advStyleAlertController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
    NSArray *advTypeTextArray = @[@[@"图文（横模板）9041576832414785", @"9041576832414785"],
                                  @[@"图文（竖模板）3031171802018751", @"3031171802018751"],
                                  @[@"图文（横/竖模板）8031477832315773", @"8031477832315773"],
                                  @[@"视频（横模板）9081773802017616", @"9081773802017616"],
                                  @[@"视频（竖模板）8021871832917695", @"8021871832917695"],
                                  @[@"视频（横/竖模板）4051072852911663", @"4051072852911663"]];
    
    for (NSArray *item in advTypeTextArray) {
        __weak typeof(self) _weakSelf = self;
        UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:item[0]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            _weakSelf.positionID.placeholder = item[1];
            _weakSelf.positionID.text = item[1];
        }];
        [_weakSelf.advStyleAlertController addAction:advTypeAction];
    }
    [self presentViewController:self.advStyleAlertController animated:YES completion:^{
        
    }];
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTExpressInterstitialAd *)ad {
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

#pragma mark - GDTExpressInterstitialAdDelegate

/**
 *  模板插屏半屏广告加载成功回调
 *  当接收服务器返回的广告数据成功且模板渲染成功后调用该函数
 */
- (void)expressInterstitialSuccessToLoadAd:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Load Success." ];
    NSLog(@"videoDuration:%lf isVideo: %@", unifiedInterstitial.videoDuration, @(unifiedInterstitial.isVideoAd));
    NSLog(@"eCPM:%ld eCPMLevel:%@", [unifiedInterstitial eCPM], [unifiedInterstitial eCPMLevel]);
    
    // 在 bidding 结束之后, 调用对应的竟胜/竟败接口
    [self reportBiddingResult:unifiedInterstitial];
}

/**
 *  模板插屏半屏广告预加载失败回调
 *  当接收服务器返回的广告数据失败或模板渲染失败后调用该函数
 */
- (void)expressInterstitialFailToLoadAd:(GDTExpressInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@,Error : %@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded.",error ];
    NSLog(@"interstitial fail to load, Error : %@",error);
}

- (void)expressInterstitialDidDownloadVideo:(GDTExpressInterstitialAd *)unifiedInterstitial {
    NSLog(@"%s",__FUNCTION__);
}

- (void)expressInterstitialRenderSuccess:(GDTExpressInterstitialAd *)unifiedInterstitial {
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"render success." ];
}

- (void)expressInterstitialRenderFail:(GDTExpressInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"render fail." ];
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  模板插屏半屏广告将要展示回调
 *  模板插屏半屏广告即将展示回调该函数
 */
- (void)expressInterstitialWillPresentScreen:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present." ];
}


/**
 *  模板插屏半屏广告展示失败回调
 *  模板插屏半屏展示失败时回调该函数
 */
- (void)expressInterstitialFailToPresent:(GDTExpressInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"fail to present." ];
}

/**
 *  模板插屏半屏广告视图展示成功回调
 *  模板插屏半屏广告展示成功回调该函数
 */
- (void)expressInterstitialDidPresentScreen:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." ];
}

/**
 *  模板插屏半屏广告展示结束回调
 *  模板插屏半屏广告展示结束回调该函数
 */
- (void)expressInterstitialDidDismissScreen:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented." ];
}

/**
 *  当点击下载应用时会调用系统程序打开
 */
- (void)expressInterstitialWillLeaveApplication:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background." ];
}

/**
 *  模板插屏半屏广告曝光回调
 */
- (void)expressInterstitialWillExposure:(GDTExpressInterstitialAd *)expressInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  模板插屏半屏广告点击回调
 */
- (void)expressInterstitialClicked:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击模板插屏半屏广告以后即将弹出全屏广告页
 */
- (void)expressInterstitialAdWillPresentFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击模板插屏半屏广告以后弹出全屏广告页
 */
- (void)expressInterstitialAdDidPresentFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页将要关闭
 */
- (void)expressInterstitialAdWillDismissFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页被关闭
 */
- (void)expressInterstitialAdDidDismissFullScreenModal:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}


/**
 *  模板插屏半屏视频广告 player 播放状态更新回调
 */
- (void)expressInterstitialAd:(GDTExpressInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSLog(@"%s status:%ld", __FUNCTION__, status);
}

/**
 * 模板插屏半屏视频广告详情页 WillPresent 回调
 */
- (void)expressInterstitialAdViewWillPresentVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 模板插屏半屏视频广告详情页 DidPresent 回调
 */
- (void)expressInterstitialAdViewDidPresentVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 模板插屏半屏视频广告详情页 WillDismiss 回调
 */
- (void)expressInterstitialAdViewWillDismissVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 模板插屏半屏视频广告详情页 DidDismiss 回调
 */
- (void)expressInterstitialAdViewDidDismissVideoVC:(GDTExpressInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}
@end
