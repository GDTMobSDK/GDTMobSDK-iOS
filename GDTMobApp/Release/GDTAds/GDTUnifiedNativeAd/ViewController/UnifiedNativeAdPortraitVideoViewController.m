//
//  UnifiedNativeAdPortraitVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdPortraitVideoViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTAppDelegate.h"
#import "DemoPlayerTableViewCell.h"
#import "UnifiedNativeAdPortraitVideoTableViewCell.h"

@interface UnifiedNativeAdPortraitVideoViewController () <GDTUnifiedNativeAdDelegate, UITableViewDelegate, UITableViewDataSource, GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong) GDTUnifiedNativeAd *nativeAd;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableViewCell *lastCell;

@end

@implementation UnifiedNativeAdPortraitVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    if (self.useToken) {
        self.nativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId token:self.token];
    } else {
        self.nativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId];
    }
    self.nativeAd.delegate = self;
    self.nativeAd.minVideoDuration = self.minVideoDuration;
    self.nativeAd.maxVideoDuration = self.maxVideoDuration;
    [self.nativeAd loadAdWithAdCount:10];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)initView
{
    [self.view addSubview:self.tableView];
#if defined(__IPHONE_11_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.tableView registerClass:[DemoPlayerTableViewCell class] forCellReuseIdentifier:@"DemoPlayerTableViewCell"];
    [self.tableView registerClass:[UnifiedNativeAdPortraitVideoTableViewCell class] forCellReuseIdentifier:@"UnifiedNativeAdPortraitVideoTableViewCell"];
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult:(GDTUnifiedNativeAd *)ad {
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

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (error) {
        NSLog(@"error %@", error);
        return;
    }
    for (GDTUnifiedNativeAdDataObject *obj in unifiedNativeAdDataObjects) {
        NSLog(@"extraInfo: %@", obj.extraInfo);
    }
    self.dataArray = unifiedNativeAdDataObjects;
    [self.tableView reloadData];
    
    // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [self.nativeAd setBidECPM:100];
    } else {
        [self reportBiddingResult:self.nativeAd];
    }
}

- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDTUnifiedNativeAdDataObject *nativeAdDataObject = self.dataArray[indexPath.row];
    nativeAdDataObject.videoConfig = self.videoConfig;
    UnifiedNativeAdPortraitVideoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UnifiedNativeAdPortraitVideoTableViewCell"];
    [cell setupWithUnifiedNativeAdDataObject:nativeAdDataObject delegate:self vc:self];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(UnifiedNativeAdPortraitVideoTableViewCell *)cell resetAnimations];
}

#pragma mark - private
- (void)clickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
        _tableView.pagingEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}

@end
