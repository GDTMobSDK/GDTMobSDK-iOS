//
//  NativeExpressAdViewController.m
//  GDTMobApp
//
//  Created by michaelxing on 2017/4/17.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "NativeExpressAdViewController.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "GDTAppDelegate.h"
#import "NativeExpressAdConfigView.h"
#import "DemoUtil.h"

@interface NativeExpressAdViewController ()<GDTNativeExpressAdDelegete,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *expressAdViews;

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)  float widthSliderValue;
@property (assign, nonatomic)  float heightSliderValue;
@property (assign, nonatomic)  float adCountSliderValue;

//切换广告样式

@property (nonatomic, strong) UIButton *changAdvStyleButton;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL useToken;

@end

@implementation NativeExpressAdViewController

static NSString *ABOVEPH_BLOWTEXT_STR = @"2011313603627732";
static NSString *ABOVETEXT_BLOW_PH_STR = @"5018760231881135";
static NSString *LEFTPH_RIHGTTEXT_STR = @"1001317613724659";
static NSString *LEFTTEXT_RIGHTPH_STR = @"3061112693227741";
static NSString *TWOPH_AND_TEXT_STR = @"6001113663823874";
static NSString *ABOVEPH_BLOWTEXT_SURFACE_STR = @"6021015693625724";
static NSString *ABOVETEXT_SURFACE_BLOWPH_STR = @"2021617633021755";
static NSString *TEXTSURFACE_ONEPHOTO_STR = @"7011916673826880";
static NSString *HORIZONTAL_IMAGE_STR = @"8031910693627892";
static NSString *VERTICAL_IMAGE_STR = @"6021618693720821";
static NSString *THREE_SMALLPH_STR = @"1098462271285109";
static NSString *Mediator_STR = @"100014";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nativeexpresscell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"splitnativeexpresscell"];
    
    [self initVideoConfig];
    [self refreshButton:nil];
}

- (IBAction)selectADVStyle:(id)sender {
    UIAlertController *advStyleAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告样式" message:nil preferredStyle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    NSArray *advTypeTextArray = [self getAdvTypeTextArray];
    
    for (NSInteger i = 0; i < advTypeTextArray.count; i++) {
        UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:advTypeTextArray[i][0]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            self.placementIdTextField.placeholder = advTypeTextArray[i][1];
            [self refreshViewWithNewPosID];
        }];
        [advStyleAlertController addAction:advTypeAction];
    }
    [advStyleAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (advStyleAlertController.popoverPresentationController) {
        [advStyleAlertController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        advStyleAlertController.popoverPresentationController.sourceView=self.view;
        advStyleAlertController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [self presentViewController:advStyleAlertController
                       animated:YES
                     completion:nil];
}

- (NSArray *)getAdvTypeTextArray
{
    return @[ @[@"上图下文(图片尺寸1280×720)", ABOVEPH_BLOWTEXT_STR],
              @[@"上文下图(图片尺寸1280×720)", ABOVETEXT_BLOW_PH_STR],
              @[@"左图右文(图片尺寸1200×800)", LEFTPH_RIHGTTEXT_STR],
              @[@"左文右图(图片尺寸1200×800)", LEFTTEXT_RIGHTPH_STR],
              @[@"双图双文-图文(大图尺寸1280×720)", TWOPH_AND_TEXT_STR],
              @[@"文字浮层(上图下文1280×720)", ABOVEPH_BLOWTEXT_SURFACE_STR],
              @[@"文字浮层(上文下图1280×720)", ABOVETEXT_SURFACE_BLOWPH_STR],
              @[@"文字浮层(单图1280×720)", TEXTSURFACE_ONEPHOTO_STR],
              @[@"横版纯图片(图片尺寸1280×720)", HORIZONTAL_IMAGE_STR],
              @[@"竖版纯图片(图片尺寸800×1200)", VERTICAL_IMAGE_STR],
              @[@"三小图双文(图片尺寸228×150)", THREE_SMALLPH_STR],
             @[@"流量分配",Mediator_STR]
            ];
}

- (void)refreshViewWithNewPosID {
    [self.expressAdViews removeAllObjects];
    [self.tableView reloadData];
    
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    if (self.useToken) {
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId token:self.token
                                                                        adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    } else {
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId
                                                                        adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    }
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:(NSInteger)self.adCountSliderValue];
}


- (IBAction)refreshButton:(id)sender {
    [self.expressAdViews removeAllObjects];
    [self.tableView reloadData];
    
    
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    if (self.useToken) {
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId token:self.token
                                                                        adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    } else {
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId
                                                                        adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    }
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:(NSInteger)self.adCountSliderValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)initVideoConfig
{
    self.widthSliderValue = [UIScreen mainScreen].bounds.size.width;
    self.heightSliderValue = 50;
    self.adCountSliderValue = 3;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多视频配置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAnotherView)];
}

- (void)jumpToAnotherView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NativeExpressAdConfigView *theNativeExpressAdConfigView = [[NativeExpressAdConfigView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    __weak typeof(self) _weakSelf = self;
    theNativeExpressAdConfigView.placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;;
    theNativeExpressAdConfigView.widthSlider.value = self.widthSliderValue;
    theNativeExpressAdConfigView.heightSlider.value = self.heightSliderValue;
    theNativeExpressAdConfigView.adCountSlider.value = self.adCountSliderValue;
    theNativeExpressAdConfigView.useTokenSwitch.on = self.useToken;
    theNativeExpressAdConfigView.tokenLabel.text = self.token;
    theNativeExpressAdConfigView.callBackBlock = ^(float widthSliderValue,float heightSliderValue,float adCountSliderValue,BOOL navigationRightButtonIsenabled){
        [self.navigationItem.rightBarButtonItem setEnabled:navigationRightButtonIsenabled];
        _weakSelf.widthSliderValue = widthSliderValue;
        _weakSelf.heightSliderValue = heightSliderValue;
        _weakSelf.adCountSliderValue = adCountSliderValue;
    };
    theNativeExpressAdConfigView.tokenBlock = ^(BOOL useToken, NSString * _Nonnull token) {
        _weakSelf.useToken = useToken;
        _weakSelf.token = token;
    };
    [theNativeExpressAdConfigView showInView:self.view];
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult {
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [[self.expressAdViews firstObject] setBidECPM:100];
    }
    else {
        NSInteger fakeWinPrice = 200;
        NSInteger fakeHighestPrice = 100;
        GDTAdBiddingLossReason fakeLossReason = GDTAdBiddingLossReasonLowPrice;
        NSString *fakeAdnId = @"WinAdnId";
        NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_setting_bidding_report"];
        NSInteger reportFlag = flag ? [flag integerValue] : 1;
        if (reportFlag == 1) {
            for (GDTNativeExpressAdView *iter in self.expressAdViews) {
                [iter sendWinNotificationWithInfo:@{GDT_M_W_E_COST_PRICE: @(fakeWinPrice), GDT_M_W_H_LOSS_PRICE: @(fakeHighestPrice)}];
            }
            
        } else if (reportFlag == 2) {
            for (GDTNativeExpressAdView *iter in self.expressAdViews) {
                [iter sendLossNotificationWithInfo:@{GDT_M_L_WIN_PRICE: @(fakeWinPrice), GDT_M_L_LOSS_REASON:@(fakeLossReason), GDT_M_ADNID: fakeAdnId}];
            }
        }
    }
}

#pragma mark - GDTNativeExpressAdDelegete
/**
 * 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    NSLog(@"%s",__FUNCTION__);
    self.expressAdViews = [NSMutableArray arrayWithArray:views];
    if (self.expressAdViews.count) {
        [self.expressAdViews enumerateObjectsUsingBlock:^(GDTNativeExpressAdView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            expressView.controller = self;
            if ([expressView isAdValid]) {
                [expressView render];
            }
            NSLog(@"extraInfo: %@", obj.extraInfo);
            NSLog(@"eCPM:%ld eCPMLevel:%@", [expressView eCPM], [expressView eCPMLevel]);
        }];
    }
    [self.tableView reloadData];
    
    // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
    [self reportBiddingResult];
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"Express Ad Load Fail : %@",error);
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.tableView reloadData];
}

/**
 * 模板渲染失败的回调
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.expressAdViews removeObject:nativeExpressAdView];
    [self.tableView reloadData];
}

- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status {
    NSString *statusString = [DemoUtil videoPlayerStatusStringFromStatus:status];
    NSLog(@"%s-----status:%@",__FUNCTION__,statusString);
}

- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewWillDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewDidDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"--------%s-------",__FUNCTION__);
}

/**
 *  投诉成功回调
 */
- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
        return view.bounds.size.height;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expressAdViews.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row % 2 == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"nativeexpresscell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
        if ([subView superview]) {
            [subView removeFromSuperview];
        }
        GDTNativeExpressAdView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
        view.tag = 1000;
        [cell.contentView addSubview:view];
        
        cell.accessibilityIdentifier = @"nativeTemp_even_ad";
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"splitnativeexpresscell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];
        cell.accessibilityIdentifier = @"nativeTemp_odd_ad";
    }
    return cell;
}

@end
