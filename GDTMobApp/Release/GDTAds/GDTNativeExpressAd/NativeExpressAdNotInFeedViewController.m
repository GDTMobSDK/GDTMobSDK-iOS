//
//  NativeExpressAdNotInFeedViewController.m
//  GDTMobApp
//
//  Created by nancynan on 2024/11/28.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "NativeExpressAdNotInFeedViewController.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "NativeExpressAdConfigView.h"
#import "DemoUtil.h"

@interface NativeExpressAdNotInFeedViewController ()<GDTNativeExpressAdDelegete>

@property (nonatomic, strong) NSMutableArray *expressAdViews;

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (assign, nonatomic)  float widthSliderValue;
@property (assign, nonatomic)  float heightSliderValue;
//切换广告样式
@property (nonatomic, strong) UIButton *changAdvStyleButton;


@end

@implementation NativeExpressAdNotInFeedViewController

static NSString *ABOVEPH_BLOWTEXT_STR = @"5030722621265924";

static NSString *ABOVETEXT_BLOW_PH_STR = @"8010090333885456";

static NSString *LEFTPH_RIHGTTEXT_STR = @"1080793303881448";

static NSString *LEFTTEXT_RIGHTPH_STR = @"9050097313684512";

static NSString *TWOPH_AND_TEXT_STR = @"5070297373087567";

static NSString *WIDTHPHOTO_STR = @"5070791337820394";

static NSString *HEIGHTPHOTO_STR = @"6090492353182599";

static NSString *THREE_SMALLPH_STR = @"9050492343889611";

static NSString *ABOVETEXT_SURFACE_BLOWPH_STR = @"9010495393982624";

static NSString *ABOVEPH_BLOWTEXT_SURFACE_STR = @"6020493353488605";

static NSString *TEXTSURFACE_ONEPHOTO_STR = @"3030690323789618";

static NSString *HEIGHTERPHOTO_STR = @"6060290383380659";

static NSString *Mediator_STR = @"100425";

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return @[
             @[@"2.0-上图下文(图片尺寸1280×720)", @"2011313603627732"],
             @[@"2.0-上文下图(图片尺寸1280×720)", @"5018760231881135"],
             @[@"2.0-左图右文(图片尺寸1200×800)", @"1001317613724659"],
             @[@"2.0-左文右图(图片尺寸1200×800)", @"3061112693227741"],
             @[@"2.0-双图双文-图文(大图尺寸1280×720)", @"6001113663823874"],
             @[@"2.0-文字浮层(上图下文1280×720)", @"6021015693625724"],
             @[@"2.0-文字浮层(上文下图1280×720)", @"2021617633021755"],
             @[@"2.0-文字浮层(单图1280×720)", @"7011916673826880"],
             @[@"2.0-横版纯图片(图片尺寸1280×720)", @"8031910693627892"],
             @[@"2.0-竖版纯图片(图片尺寸800×1200)", @"6021618693720821"],
             @[@"2.0-三小图双文(图片尺寸228×150)", @"1098462271285109"],
             @[@"上图下文(图片尺寸1280×720)",ABOVEPH_BLOWTEXT_STR],
             @[@"上文下图(图片尺寸1280×720)",ABOVETEXT_BLOW_PH_STR],
             @[@"左图右文(图片尺寸1200×800)",LEFTPH_RIHGTTEXT_STR],
             @[@"左文右图(图片尺寸1200×800)",LEFTTEXT_RIGHTPH_STR],
             @[@"双图双文(大图尺寸1280×720)",TWOPH_AND_TEXT_STR],
             @[@"纯图片(图片尺寸1280×720)",WIDTHPHOTO_STR],
             @[@"纯图片(图片尺寸800×1200)",HEIGHTPHOTO_STR],
             @[@"三小图(图片尺寸228×150)",THREE_SMALLPH_STR],
             @[@"文字浮层(上文下图1280×720)",ABOVETEXT_SURFACE_BLOWPH_STR],
             @[@"文字浮层(上图下文1280×720)",ABOVEPH_BLOWTEXT_SURFACE_STR],
             @[@"文字浮层(单图1280×720)",TEXTSURFACE_ONEPHOTO_STR],
             @[@"纯图片(图片尺寸1080×1920或800×1200)",HEIGHTERPHOTO_STR]
];
}

- (void)refreshViewWithNewPosID {
    [self clear];
    
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId
                                                                    adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:1];
}

- (void)addAdSubviews {
    if ([self.expressAdViews count] == 0) {
        return;
    }
    
    GDTNativeExpressAdView *view = [self.expressAdViews objectAtIndex:0];
    view.tag = 1000;
    [self.containerView addSubview:view];
}

- (void)clear {
    [self.expressAdViews removeAllObjects];
    for (UIView *iter in self.containerView.subviews) {
        [iter removeFromSuperview];
    }
}

- (IBAction)refreshButton:(id)sender {
    [self clear];
    
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId
                                                                    adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:1];
}

- (void)initVideoConfig
{
    self.widthSliderValue = [UIScreen mainScreen].bounds.size.width;
    self.heightSliderValue = 50;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多视频配置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAnotherView)];
}

- (void)jumpToAnotherView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NativeExpressAdConfigView *theNativeExpressAdConfigView = [[NativeExpressAdConfigView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    __weak typeof(self) _weakSelf = self;
    theNativeExpressAdConfigView.placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;;
    theNativeExpressAdConfigView.widthSlider.value = self.widthSliderValue;
    theNativeExpressAdConfigView.heightSlider.value = self.heightSliderValue;
    theNativeExpressAdConfigView.callBackBlock = ^(float widthSliderValue,float heightSliderValue,float adCountSliderValue,BOOL navigationRightButtonIsenabled){
        [self.navigationItem.rightBarButtonItem setEnabled:navigationRightButtonIsenabled];
        _weakSelf.widthSliderValue = widthSliderValue;
        _weakSelf.heightSliderValue = heightSliderValue;
    };

    [theNativeExpressAdConfigView showInView:self.view];
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
    
    [self addAdSubviews];
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"%s ad load fail: %@",__FUNCTION__,error);
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self addAdSubviews];
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
    NSLog(@"request_id=%@",[nativeExpressAdView.extraInfo objectForKey:@"request_id"]);
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [nativeExpressAdView removeFromSuperview];
    [self.expressAdViews removeObject:nativeExpressAdView];
}

- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"request_id=%@",[nativeExpressAdView.extraInfo objectForKey:@"request_id"]);
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

@end
