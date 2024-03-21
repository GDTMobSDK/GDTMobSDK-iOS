//
//  UnifiedNativeAdPortraitDetailViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/6/2.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdPortraitDetailViewController.h"
#import "UnifiedNativeAdCustomView.h"
#import "DemoUtil.h"

@interface UnifiedNativeAdPortraitDetailViewController () <GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong) UnifiedNativeAdCustomView *nativeAdView;
@property (nonatomic, strong) NSLayoutConstraint *consH;

@end

@implementation UnifiedNativeAdPortraitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initViews];
    self.nativeAdView.viewController = self;
    self.nativeAdView.delegate = self;
    
    if ([self.dataObject isAdValid]) {
        [self.nativeAdView registerDataObject:self.dataObject clickableViews:@[self.nativeAdView.imageView,
                                                                               self.nativeAdView.titleLabel,
                                                                               self.nativeAdView.iconImageView,
                                                                               self.nativeAdView.descLabel,
                                                                               self.nativeAdView.clickButton]];
    }
    
    [self.nativeAdView setupWithUnifiedNativeAdObject:self.dataObject];
    
    if (self.nativeAdView.dataObject.imageWidth > 0) {
        self.consH.active = NO;
        self.consH = [self.nativeAdView.mediaView.heightAnchor constraintEqualToAnchor:self.nativeAdView.mediaView.widthAnchor multiplier:(float)self.nativeAdView.dataObject.imageHeight/(float)self.nativeAdView.dataObject.imageWidth];
        self.consH.active = YES;
    }
    
    [self.dataObject bindImageViews:@[self.nativeAdView.imageView] placeholder:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nativeAdView.mediaView play];
}

- (void)initViews
{
    [self.view addSubview:self.nativeAdView];
    self.nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.nativeAdView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.nativeAdView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.nativeAdView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    // mediaView
    self.nativeAdView.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdView.imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.nativeAdView.imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    [self.nativeAdView.imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.nativeAdView.imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    self.nativeAdView.imageView.alpha = 0.4;
    
    self.nativeAdView.clickButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdView.clickButton.leftAnchor constraintEqualToAnchor:self.nativeAdView.leftAnchor constant:15].active = YES;
    [self.nativeAdView.clickButton.rightAnchor constraintEqualToAnchor:self.nativeAdView.rightAnchor constant:-20].active = YES;
    [self.nativeAdView.clickButton.bottomAnchor constraintEqualToAnchor:self.nativeAdView.bottomAnchor constant:-15].active = YES;
    [self.nativeAdView.clickButton.heightAnchor constraintEqualToConstant:44].active = YES;
    self.nativeAdView.clickButton.backgroundColor = [UIColor orangeColor];
    self.nativeAdView.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nativeAdView.descLabel.textColor = [UIColor redColor];
    [self.nativeAdView.descLabel.leftAnchor constraintEqualToAnchor:self.nativeAdView.clickButton.leftAnchor].active = YES;
    [self.nativeAdView.descLabel.rightAnchor constraintEqualToAnchor:self.nativeAdView.clickButton.rightAnchor].active = YES;
    [self.nativeAdView.descLabel.heightAnchor constraintEqualToConstant:30].active = YES;
    [self.nativeAdView.descLabel.bottomAnchor constraintEqualToAnchor:self.nativeAdView.clickButton.topAnchor constant:-10].active = YES;
    self.nativeAdView.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nativeAdView.titleLabel.textColor = [UIColor blueColor];
    [self.nativeAdView.titleLabel.leftAnchor constraintEqualToAnchor:self.nativeAdView.clickButton.leftAnchor].active = YES;
    [self.nativeAdView.titleLabel.rightAnchor constraintEqualToAnchor:self.nativeAdView.clickButton.rightAnchor].active = YES;
    [self.nativeAdView.titleLabel.heightAnchor constraintEqualToConstant:30].active = YES;
    [self.nativeAdView.titleLabel.bottomAnchor constraintEqualToAnchor:self.nativeAdView.descLabel.topAnchor constant:-10].active = YES;
    self.nativeAdView.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdView.iconImageView.leftAnchor constraintEqualToAnchor:self.nativeAdView.clickButton.leftAnchor].active = YES;
    [self.nativeAdView.iconImageView.heightAnchor constraintEqualToConstant:60].active = YES;
    [self.nativeAdView.iconImageView.widthAnchor constraintEqualToConstant:60].active = YES;
    [self.nativeAdView.iconImageView.bottomAnchor constraintEqualToAnchor:self.nativeAdView.titleLabel.topAnchor constant:-10].active = YES;
    [self.nativeAdView addSubview:self.nativeAdView.logoView];
    self.nativeAdView.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdView.logoView.widthAnchor constraintEqualToConstant:kGDTLogoImageViewDefaultWidth].active = YES;
    [self.nativeAdView.logoView.heightAnchor constraintEqualToConstant:kGDTLogoImageViewDefaultHeight].active = YES;
    [self.nativeAdView.logoView.rightAnchor constraintEqualToAnchor:self.nativeAdView.rightAnchor].active = YES;
    [self.nativeAdView.logoView.bottomAnchor constraintEqualToAnchor:self.nativeAdView.bottomAnchor constant:-20].active = YES;
    // mediaView
    self.nativeAdView.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdView.mediaView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    self.consH = [self.nativeAdView.mediaView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor];
    self.consH.active = YES;
    [self.nativeAdView.mediaView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.nativeAdView.mediaView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-60].active = YES;
}

#pragma mark - GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@ 广告曝光", unifiedNativeAdView.dataObject.title);
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.nativeAdView.mediaView pause];
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.nativeAdView.mediaView play];
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo
{
    NSString *statusString = [DemoUtil videoPlayerStatusStringFromStatus:status];
    NSLog(@"%s-----status:%@",__FUNCTION__,statusString);
}

- (void)gdtAdComplainSuccess:(id)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告投诉成功");
}

#pragma mark - property getter
- (UnifiedNativeAdCustomView *)nativeAdView
{
    if (!_nativeAdView) {
        _nativeAdView = [[UnifiedNativeAdCustomView alloc] init];
        _nativeAdView.accessibilityIdentifier = @"nativeAdView_id";
    }
    return _nativeAdView;
}

@end
