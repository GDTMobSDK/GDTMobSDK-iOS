//
//  UnifiedNativeAdFeedVideoTableViewController.m
//  GDTMobApp
//
//  Created by qpwang on 2019/5/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdFeedVideoTableViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "UnifiedNativeAdFeedVideoCell.h"
#import "UnifiedNativeAdImageCell.h"
#import "UnifiedNativeAdThreeImageCell.h"
#import "GDTAppDelegate.h"

@interface UnifiedNativeAdFeedVideoTableViewController () <GDTUnifiedNativeAdDelegate, GDTUnifiedNativeAdViewDelegate, UITableViewDelegate, UITableViewDataSource, GDTMediaViewDelegate>

@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property (nonatomic, strong) NSArray *adDataArray;
@property (nonatomic, strong) NSMutableArray *adCellArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UnifiedNativeAdFeedVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adCellArray = [[NSMutableArray alloc] init];
    
    if (self.useToken) {
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId token:self.token];
    } else {
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId ?: @"3050349752532954"];
    }
    self.unifiedNativeAd.minVideoDuration = self.minVideoDuration;
    self.unifiedNativeAd.maxVideoDuration = self.maxVideoDuration;
    self.unifiedNativeAd.delegate = self;
    [self.view addSubview:self.tableView];
    [self.unifiedNativeAd loadAdWithAdCount:10];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"自定义播放器尺寸" style:UIBarButtonItemStylePlain target:self action:@selector(customMediaViewSize)];
    self.navigationItem.rightBarButtonItem = item;
    [UnifiedNativeAdFeedVideoCell setCustomSize:CGSizeZero];
}

- (void)customMediaViewSize {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"自定义播放器尺寸" message:@"只填写一项的话根据比例计算另一项" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Width";
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Height";
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *imageW = alertController.textFields.firstObject;
        UITextField *imageH = alertController.textFields.lastObject;
        [UnifiedNativeAdFeedVideoCell setCustomSize:CGSizeMake(imageW.text.integerValue, imageH.text.integerValue)];
        [self.tableView reloadData];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.unifiedNativeAd.minVideoDuration = self.minVideoDuration;
//    self.unifiedNativeAd.maxVideoDuration = self.maxVideoDuration;
//    [self.unifiedNativeAd loadAdWithAdCount:10];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDTUnifiedNativeAdDataObject *dataObject = self.adDataArray[indexPath.row];
    if (dataObject.isVideoAd) {
        return [UnifiedNativeAdFeedVideoCell cellHeightWithUnifiedNativeAdDataObject:dataObject];
    } else if (dataObject.isThreeImgsAd) {
        return [UnifiedNativeAdThreeImageCell cellHeightWithUnifiedNativeAdDataObject:dataObject];
    } else {
        return [UnifiedNativeAdImageCell cellHeightWithUnifiedNativeAdDataObject:dataObject];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDTUnifiedNativeAdDataObject *dataObject = self.adDataArray[indexPath.row];
    NSLog(@"eCPM:%ld eCPMLevel:%@ videoDuration:%lf", [dataObject eCPM], [dataObject eCPMLevel], [dataObject duration]);

    UnifiedNativeAdBaseTableViewCell *returnCell = nil;
    
    if (self.adCellArray.count > indexPath.row) {
        returnCell = self.adCellArray[indexPath.row];
        [returnCell adaptCustomSize];
        return returnCell;
    }

    if (dataObject.isVideoAd) {
        dataObject.videoConfig = self.videoConfig;
        UnifiedNativeAdFeedVideoCell *cell = [[UnifiedNativeAdFeedVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnifiedNativeAdFeedVideoCell"];
        cell.adView.mediaView.delegate = self;
        [cell setupWithUnifiedNativeAdDataObject:dataObject delegate:self vc:self];
        returnCell = cell;
    } else if (dataObject.isThreeImgsAd) {
        UnifiedNativeAdThreeImageCell *cell = [[UnifiedNativeAdThreeImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnifiedNativeAdThreeImageCell"];
        [cell setupWithUnifiedNativeAdDataObject:dataObject delegate:self vc:self];
        [dataObject bindImageViews:@[cell.adView.leftImageView, cell.adView.midImageView, cell.adView.rightImageView] placeholder:nil];
        returnCell = cell;
    } else {
        UnifiedNativeAdImageCell *cell = [[UnifiedNativeAdImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnifiedNativeAdImageCell"];
        [cell setupWithUnifiedNativeAdDataObject:dataObject delegate:self vc:self];
        [dataObject bindImageViews:@[cell.adView.imageView] placeholder:nil];
        returnCell = cell;
    }
    [returnCell adaptCustomSize];
    [self.adCellArray addObject:returnCell];
    return returnCell;
}

/**
 * 上报给优量汇服务端在开发者客户端竞价中优量汇的竞价结果，以便于优量汇服务端调整策略提供给开发者更合理的报价
 *
 * 优量汇竞价失败调用 biddingLoss，并填入优量汇竞败原因（必填）、竞胜ADN ID（选填）、竞胜ADN报价（选填）
 * 优量汇竞价胜出调用 biddingWin，并填入开发者期望扣费价格（单位分）和最高竞败出价（单位分）
 * 请开发者如实上报相关参数，以保证优量汇服务端能根据相关参数调整策略，使开发者收益最大化
*/

- (void)reportBiddingResult {
    //这里只是示例，请根据真实的比价结果来上报每个广告的竞胜竞败信息
    if (self.useToken) {
        // 针对本次曝光的媒体期望扣费，常用扣费逻辑包括一价扣费与二价扣费
        // 当采用一价扣费时，胜者出价即为本次扣费价格；当采用二价扣费时，第二名出价为本次扣费价格；
        // 自己根据实际情况设置
        [[self.adDataArray firstObject] setBidECPM:100];
    }
    else {
        NSInteger fakeWinPrice = 200;
        NSInteger fakeHighestPrice = 100;
        GDTAdBiddingLossReason fakeLossReason = GDTAdBiddingLossReasonLowPrice;
        NSString *fakeAdnId = @"WinAdnId";
        NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_setting_bidding_report"];
        NSInteger reportFlag = flag ? [flag integerValue] : 1;
        if (reportFlag == 1) {
            for (GDTUnifiedNativeAdDataObject *iter in self.adDataArray) {
                [iter sendWinNotificationWithInfo:@{GDT_M_W_E_COST_PRICE: @(fakeWinPrice), GDT_M_W_H_LOSS_PRICE: @(fakeHighestPrice)}];
            }
        } else if (reportFlag == 2) {
            for (GDTUnifiedNativeAdDataObject *iter in self.adDataArray) {
                [iter sendLossNotificationWithInfo:@{GDT_M_L_WIN_PRICE: @(fakeWinPrice), GDT_M_L_LOSS_REASON:@(fakeLossReason), GDT_M_ADNID: fakeAdnId}];
            }
        }
    }
}

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (!error && unifiedNativeAdDataObjects.count > 0) {
        NSLog(@"成功请求到广告数据");
        for (GDTUnifiedNativeAdDataObject *obj in unifiedNativeAdDataObjects) {
            NSLog(@"extraInfo: %@", obj.extraInfo);
        }
        self.adDataArray = unifiedNativeAdDataObjects;
        [self.tableView reloadData];
        
        // 在 bidding 结束之后, 调用对应的竞胜/竞败接口
        [self reportBiddingResult];
        return;
    }
    
    if (error.code == 5004) {
        NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    } else if (error.code == 5005) {
        NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    } else if (error.code == 5009) {
        NSLog(@"流量控制导致没有广告，超过小时限额");
    } else if (error.code == 5006) {
        NSLog(@"包名错误");
    } else if (error.code == 5010) {
        NSLog(@"广告样式校验失败");
    } else if (error.code == 3001) {
        NSLog(@"网络错误");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

#pragma mark - GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@ 广告被点击", unifiedNativeAdView.dataObject);
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告被曝光");
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告详情页已关闭");
}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告进入后台");
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告详情页面即将打开");
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频广告状态变更");
    switch (status) {
        case GDTMediaPlayerStatusInitial:
            NSLog(@"视频初始化");
            break;
        case GDTMediaPlayerStatusLoading:
            NSLog(@"视频加载中");
            break;
        case GDTMediaPlayerStatusStarted:
            NSLog(@"视频开始播放");
            break;
        case GDTMediaPlayerStatusPaused:
            NSLog(@"视频暂停");
            break;
        case GDTMediaPlayerStatusStoped:
            NSLog(@"视频停止");
            break;
        case GDTMediaPlayerStatusError:
            NSLog(@"视频播放出错");
        default:
            break;
    }
    if (userInfo) {
        long videoDuration = [userInfo[kGDTUnifiedNativeAdKeyVideoDuration] longValue];
        NSLog(@"视频广告长度为 %ld s", videoDuration);
    }
}

- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}

- (void)gdt_mediaViewDidTapped:(GDTMediaView *)mediaView {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}
@end
