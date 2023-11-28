//
//  UnifiedNativeAdFeedVideoCell.m
//  GDTMobApp
//
//  Created by qpwang on 2019/5/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdFeedVideoCell.h"
#import <objc/runtime.h>

@interface UnifiedNativeAdFeedVideoCell()

@property (nonatomic, strong) UILabel *muteLabel;
@property (nonatomic, strong) UISwitch *muteSwitch;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, assign) CGSize customSize;
@property (nonatomic, assign) CGFloat imageRate;
@property (nonatomic, strong) NSLayoutConstraint *consMediaViewW;
@property (nonatomic, strong) NSLayoutConstraint *consMediaViewH;

@end

@implementation UnifiedNativeAdFeedVideoCell

+ (void)setCustomSize:(CGSize)customSize {
    objc_setAssociatedObject(self, @selector(customSize), [NSValue valueWithCGSize:customSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGSize)customSize {
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.muteLabel];
        [self addSubview:self.muteSwitch];
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.stopButton];
        
        self.adView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *adView = self.adView;
        NSArray<NSLayoutConstraint *> *consV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[adView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(adView)];
        NSArray<NSLayoutConstraint *> *consH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[adView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(adView)];
        [NSLayoutConstraint activateConstraints:consV];
        [NSLayoutConstraint activateConstraints:consH];

        self.adView.logoView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *logoView = self.adView.logoView;
        NSArray<NSLayoutConstraint *> *consLogoV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoView(logoH)]-0-|" options:0 metrics:@{@"logoH":@(kGDTLogoImageViewDefaultHeight)} views:NSDictionaryOfVariableBindings(logoView)];
        NSArray<NSLayoutConstraint *> *consLogoH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[logoView(logoW)]-0-|" options:0 metrics:@{@"logoW":@(kGDTLogoImageViewDefaultWidth)} views:NSDictionaryOfVariableBindings(logoView)];
        [NSLayoutConstraint activateConstraints:consLogoV];
        [NSLayoutConstraint activateConstraints:consLogoH];
        
        self.adView.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *mediaView = self.adView.mediaView;
        NSLayoutConstraint *consMediaViewX = [NSLayoutConstraint constraintWithItem:mediaView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:adView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *consMediaViewB = [NSLayoutConstraint constraintWithItem:mediaView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:adView attribute:NSLayoutAttributeBottom multiplier:1 constant:-14];
        NSLayoutConstraint *consMediaViewW = [NSLayoutConstraint constraintWithItem:mediaView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:adView attribute:NSLayoutAttributeWidth multiplier:1 constant:-16];
        NSLayoutConstraint *consMediaViewH = [NSLayoutConstraint constraintWithItem:mediaView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:adView attribute:NSLayoutAttributeHeight multiplier:1 constant:-134];
        [NSLayoutConstraint activateConstraints:@[consMediaViewX,consMediaViewB,consMediaViewW,consMediaViewH]];
        self.consMediaViewW = consMediaViewW;
        self.consMediaViewH = consMediaViewH;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.muteLabel.hidden = YES;
    self.muteSwitch.hidden = YES;
    self.playButton.hidden = YES;
    self.pauseButton.hidden = YES;
    self.stopButton.hidden = YES;
}

#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    self.adView.delegate = delegate; // adView 广告回调
    self.adView.viewController = vc; // 跳转 VC
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    self.adView.backgroundColor = [UIColor grayColor];
    self.adView.iconImageView.frame = CGRectMake(8, 8, 60, 60);
    self.adView.titleLabel.frame = CGRectMake(76, 8, 200, 30);
    self.adView.descLabel.frame = CGRectMake(8, 76, width, 30);
    
    [self.adView setupWithUnifiedNativeAdObject:dataObject];
    [self.adView.clickButton sizeToFit];
    self.adView.clickButton.frame = (CGRect) {
        .origin.x = width + 8 - self.adView.clickButton.frame.size.width,
        .origin.y = 8,
        .size = self.adView.clickButton.frame.size
    };
    [self.adView.CTAButton sizeToFit];
    self.adView.CTAButton.frame = (CGRect) {
        .origin.x = width + 8 - self.adView.CTAButton.frame.size.width,
        .origin.y = 8,
        .size = self.adView.CTAButton.frame.size
    };
    if ([dataObject isVideoAd]) {
        if ([dataObject isAdValid]) {
            // 这里加上contentView，测试重叠情况
            [self.adView registerDataObject:dataObject clickableViews:@[self.adView.iconImageView,
            self.adView.imageView] customClickableViews:@[self.adView.clickButton,self.contentView]];
        }
    }
    else {
        if ([dataObject isAdValid]) {
            // 这里不加上contentView，测试不重叠情况
            [self.adView registerDataObject:dataObject clickableViews:@[self.adView.clickButton, self.adView.iconImageView,
                                                                    self.adView.imageView]];
        }
    }
    [self.adView registerClickableCallToActionView:self.adView.CTAButton];
    [self.adView.mediaView setPlayButtonImage:[UIImage imageNamed:@"play"] size:CGSizeMake(60, 60)]; // register方法后调用
    if (dataObject.isVideoAd) {
        self.muteLabel.frame = CGRectMake(76, 40, 50, 40);
        self.muteLabel.hidden = NO;
        self.muteSwitch.frame = CGRectMake(120, 40, 50, 40);
        self.muteSwitch.on = dataObject.videoConfig.videoMuted;
        self.muteSwitch.hidden = NO;
        self.playButton.frame = CGRectMake(170, 40, 40, 40);
        self.playButton.hidden = NO;
        self.pauseButton.frame = CGRectMake(210, 40, 50, 40);
        self.pauseButton.hidden = NO;
        self.stopButton.frame = CGRectMake(260, 40, 40, 40);
        self.stopButton.hidden = NO;
    }
    
}

+ (CGFloat)cellHeightWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
{
    CGFloat height = 0;
    CGFloat imageRate = 16.0 / 9.0;
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    CGFloat imageWidth = width;
    height = 134 + imageWidth / imageRate;
    //
    if (!CGSizeEqualToSize(CGSizeZero, self.customSize)) {
        if ((self.customSize.height > 0)) {
            return 122 + self.customSize.height;
        }
    }
    NSLog(@"cell height %@", @(height));
    return height;
}

#pragma mark - private
- (void)adaptCustomSize {
    if (!CGSizeEqualToSize(self.customSize, [UnifiedNativeAdFeedVideoCell customSize])) {
        [NSLayoutConstraint deactivateConstraints:@[self.consMediaViewW]];
        [NSLayoutConstraint deactivateConstraints:@[self.consMediaViewH]];
        if ([UnifiedNativeAdFeedVideoCell customSize].width > 0) {
            self.consMediaViewW = [NSLayoutConstraint constraintWithItem:self.adView.mediaView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0 constant:[UnifiedNativeAdFeedVideoCell customSize].width];
        } else {
            self.consMediaViewW = [NSLayoutConstraint constraintWithItem:self.adView.mediaView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.adView attribute:NSLayoutAttributeWidth multiplier:1 constant:-16];
        }
        if ([UnifiedNativeAdFeedVideoCell customSize].height > 0) {
            self.consMediaViewH = [NSLayoutConstraint constraintWithItem:self.adView.mediaView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:[UnifiedNativeAdFeedVideoCell customSize].height];
        } else {
            self.consMediaViewH = [NSLayoutConstraint constraintWithItem:self.adView.mediaView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.adView attribute:NSLayoutAttributeHeight multiplier:1 constant:-134];
        }
        [NSLayoutConstraint activateConstraints:@[self.consMediaViewW,self.consMediaViewH]];
        self.customSize = [UnifiedNativeAdFeedVideoCell customSize];
    }
}

- (void)clickMuteSwitch
{
    [self.adView.mediaView muteEnable:self.muteSwitch.on];
}

- (void)clickPlay
{
    [self.adView.mediaView play];
}

- (void)clickPause
{
    [self.adView.mediaView pause];
}

- (void)clickStop
{
    [self.adView.mediaView stop];
}

#pragma mark - property getter
- (UISwitch *)muteSwitch
{
    if (!_muteSwitch) {
        _muteSwitch = [[UISwitch alloc] init];
        [_muteSwitch addTarget:self action:@selector(clickMuteSwitch) forControlEvents:UIControlEventValueChanged];
        _muteSwitch.accessibilityIdentifier = @"muteSwitch_id";
    }
    return _muteSwitch;
}

- (UILabel *)muteLabel
{
    if (!_muteLabel) {
        _muteLabel = [[UILabel alloc] init];
        _muteLabel.text = @"静音";
        _muteLabel.accessibilityIdentifier = @"muteLabel_id";
    }
    return _muteLabel;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setTitle:@"play" forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
        _playButton.accessibilityIdentifier = @"playButton_id";
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc] init];
        [_pauseButton setTitle:@"pause" forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(clickPause) forControlEvents:UIControlEventTouchUpInside];
        _pauseButton.accessibilityIdentifier = @"pauseButton_id";
    }
    return _pauseButton;
}

- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] init];
        [_stopButton setTitle:@"stop" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(clickStop) forControlEvents:UIControlEventTouchUpInside];
        _stopButton.accessibilityIdentifier = @"stopButton_id";
    }
    return _stopButton;
}
@end
