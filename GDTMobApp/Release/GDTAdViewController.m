//
//  GDTAdViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/3/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTAdViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <objc/runtime.h>

#define kTableViewHeaderHeight 44.0

@interface GDTAdViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation GDTAdViewController

- (void)loadView
{
    [super loadView];
    NSArray *section1 = @[
                          @[@"自渲染", @"UnifiedNativeAdViewController"],
                          @[@"开屏广告", @"SplashViewController"],
                          @[@"原生模板信息流(优量汇渲染)", @"NativeExpressAdEntranceViewController"],
                          @[@"激励视频广告", @"RewardVideoViewController"],
                          @[@"Banner", @"UnifiedBannerViewController"],
                          @[@"插屏半屏", @"UnifiedInterstitialViewController"],
                          @[@"插屏全屏", @"UnifiedInterstitialFullScreenVideoViewController"]];
    
    self.demoArray = @[@{@"广告形式": section1}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.demoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTableViewHeaderHeight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.0, 0, header.bounds.size.width - 18.0, kTableViewHeaderHeight)];
    label.text = [[self.demoArray[section] allKeys] firstObject];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    [header addSubview:label];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[(NSDictionary *)self.demoArray[section] allValues] firstObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSArray *cellConfig = (NSArray *)[[(NSDictionary *)self.demoArray[indexPath.section] allValues] firstObject];
    cell.textLabel.text = cellConfig[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cellConfig = (NSArray *)[[(NSDictionary *)self.demoArray[indexPath.section] allValues] firstObject];
    id item = cellConfig[indexPath.row][1];
    if ([item isKindOfClass:[NSString class]]) {
        UIViewController *vc = [[NSClassFromString(item) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}

@end
