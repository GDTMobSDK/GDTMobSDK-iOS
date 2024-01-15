//
//  RewardVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2018/9/5.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "RewardVideoViewController.h"
#import "GDTRewardVideoAd.h"
#import "GDTAppDelegate.h"
#import "GDTSDKConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "S2SBiddingManager.h"

static NSString *PORTRAIT_AD_PLACEMENTID = @"8020744212936426";
static NSString *PORTRAIT_LANDSCAPE_AD_PLACEMENTID = @"9070098640008762";
static NSString *MEDIATION_AD_PLACEMENTID = @"101366";


@interface RewardVideoViewController () <GDTRewardedVideoAdDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) UIInterfaceOrientation supportOrientation;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UIButton *changePlacementId;
@property (weak, nonatomic) IBOutlet UISwitch *videoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *audioSessionSwitch;


@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (nonatomic, assign) BOOL useToken;
@property (nonatomic, weak) IBOutlet UILabel *adValidLabel;

@end

@implementation RewardVideoViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.placementIdTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)changePlacementId:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *changePosIdController = [UIAlertController alertControllerWithTitle:@"选择广告类型" message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    if (changePosIdController.popoverPresentationController) {
        [changePosIdController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        changePosIdController.popoverPresentationController.sourceView=self.view;
        changePosIdController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
    UIDevice *device = [UIDevice currentDevice];
    __weak __typeof(self) ws = self;
    UIAlertAction *portraitAdIdAction = nil;
    if (device.orientation == UIInterfaceOrientationPortrait) {
        portraitAdIdAction = [UIAlertAction actionWithTitle:@"竖屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ws.placementIdTextField.placeholder = PORTRAIT_AD_PLACEMENTID;
        }];
    } else {
        portraitAdIdAction = [UIAlertAction actionWithTitle:@"横屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ws.placementIdTextField.placeholder = PORTRAIT_AD_PLACEMENTID;
        }];
    }
    [changePosIdController addAction:portraitAdIdAction];
    
    UIAlertAction *portraitLandscapeAdIdAction = [UIAlertAction actionWithTitle:@"横竖屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ws.placementIdTextField.placeholder = PORTRAIT_LANDSCAPE_AD_PLACEMENTID;
    }];
    [changePosIdController addAction:portraitLandscapeAdIdAction];
    
    UIAlertAction *mediationAdIdAction = [UIAlertAction actionWithTitle:@"流量分配广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ws.placementIdTextField.placeholder = MEDIATION_AD_PLACEMENTID;
       }];
    [changePosIdController addAction:mediationAdIdAction];
    [changePosIdController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:changePosIdController animated:YES completion:nil];
    
}

- (IBAction)loadAd:(id)sender {
    self.adValidLabel.text = @"";
    NSString *placementId = self.placementIdTextField.text.length > 0 ?self.placementIdTextField.text: self.placementIdTextField.placeholder;
    //placementId = @"1040149434136928";
    if (!self.useToken) {
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:placementId];
    } else {
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:placementId token:self.token];
    }
    
    
    self.rewardVideoAd.videoMuted = self.videoMutedSwitch.on;
    self.rewardVideoAd.delegate = self;
    //如果设置了服务端验证，可以设置serverSideVerificationOptions属性
    GDTServerSideVerificationOptions *ssv = [[GDTServerSideVerificationOptions alloc] init];
    ssv.userIdentifier = @"APP's user id for server verify";
    ssv.customRewardString = @"APP's custom data";
    self.rewardVideoAd.serverSideVerificationOptions = ssv;
    [self setupRewardVideoAd:self.rewardVideoAd];
    [self.rewardVideoAd loadAd];
}

- (void)setupRewardVideoAd:(GDTRewardVideoAd *)rewardVideoAd {}

- (IBAction)playVideo:(UIButton *)sender {
    if (!self.rewardVideoAd.isAdValid) {
        self.statusLabel.text = @"广告失效，请重新拉取";
        return;
    }
    
    [GDTSDKConfig enableDefaultAudioSessionSetting:!self.audioSessionSwitch.on];
    
    [self.rewardVideoAd showAdFromRootViewController:self];
    
    if (self.audioSessionSwitch.on) {
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
}

- (IBAction)changeOrientation:(UIButton *)sender {
    // 仅为方便调试提供的逻辑，应用接入流程中不需要程序设置方向
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        self.supportOrientation = UIInterfaceOrientationLandscapeRight;
    } else {
        self.supportOrientation = UIInterfaceOrientationPortrait;
    }
    [[UIDevice currentDevice] setValue:@(self.supportOrientation) forKey:@"orientation"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (IBAction)handleGetToken:(UIButton *)sender {
    __weak __typeof(self) ws = self;
    NSString *placementId = self.placementIdTextField.text.length > 0 ?self.placementIdTextField.text: self.placementIdTextField.placeholder;
    [S2SBiddingManager getTokenWithPlacementId:placementId completion:^(NSString * _Nonnull token) {
        ws.token = token;
        ws.tokenLabel.text = self.token;
        if (token) {
            ws.statusLabel.text = @"token 获取成功";
        } else {
            ws.statusLabel.text = @"token 获取失败";
        }
    }];
}

- (IBAction)handleUseToken:(UISwitch *)sender {
    self.useToken = sender.isOn;
}

- (IBAction)checkAdValidation:(id)sender {
    BOOL adValid = [self.rewardVideoAd isAdValid];
    self.adValidLabel.text = adValid ? @"广告有效" : @"广告无效";
}
/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTRewardVideoAd *)ad {
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

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"extraInfo: %@", rewardedVideoAd.extraInfo);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告数据加载成功", rewardedVideoAd.adNetworkName];
    NSLog(@"eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
    NSLog(@"videoDuration :%lf rewardAdType:%ld", rewardedVideoAd.videoDuration, rewardedVideoAd.rewardAdType);
    
    // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [rewardedVideoAd setBidECPM:100];
    } else {
        [self reportBiddingResult:rewardedVideoAd];
    }
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 视频文件加载成功", rewardedVideoAd.adNetworkName];
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放页即将打开");
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已曝光", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已曝光");
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已关闭", rewardedVideoAd.adNetworkName];

    NSLog(@"广告已关闭");
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已点击", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已点击");
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
        self.statusLabel.text = @"请拉取到广告后再调用展示接口";
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
        self.statusLabel.text = @"应用方向与广告位支持方向不一致";
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
        self.statusLabel.text = @"广告已过期";
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
        self.statusLabel.text = @"广告已经播放过，请重新拉取";
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
        self.statusLabel.text = @"视频下载失败";
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
        self.statusLabel.text = @"视频播放失败";
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
        self.statusLabel.text = @"没有合适的广告";
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
        self.statusLabel.text = @"请求太频繁，请稍后再试";
    } else if (error.code == 3002) {
        NSLog(@"网络连接超时");
        self.statusLabel.text = @"网络连接超时";
    } else if (error.code == 5027){
        NSLog(@"页面加载失败");
        self.statusLabel.text = @"页面加载失败";
    }
    NSLog(@"ERROR: %@", error);
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"播放达到激励条件 transid:%@", [info objectForKey:@"GDT_TRANS_ID"]);
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放结束");
    
    if (self.audioSessionSwitch.on) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
}

- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}

@end
