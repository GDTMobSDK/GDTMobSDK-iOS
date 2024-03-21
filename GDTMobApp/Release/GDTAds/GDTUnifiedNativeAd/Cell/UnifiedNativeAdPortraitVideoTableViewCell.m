//
//  UnifiedNativeAdPortraitVideoTableViewCell.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdPortraitVideoTableViewCell.h"

@interface UnifiedNativeAdPortraitVideoTableViewCell() <GDTMediaViewDelegate>
@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, strong) NSLayoutConstraint *consH;
@end

@implementation UnifiedNativeAdPortraitVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 底部渐变
        UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, GDTScreenHeight - 225, GDTScreenWidth, 225)];
        gradientView.alpha = 0.5;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = gradientView.bounds;
        gradientLayer.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:1].CGColor];
        
        [gradientView.layer addSublayer:gradientLayer];
        [self.adView insertSubview:gradientView belowSubview:self.adView.mediaView];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    // adView
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.adView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.adView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.adView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    
    CGFloat elementWidth = GDTScreenWidth * 511.0 / 750;
    
    // mediaView
    self.adView.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.imageView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
    [self.adView.imageView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor].active = YES;
    [self.adView.imageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.adView.imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    self.adView.imageView.alpha = 0.4;
    
    // 头像
    self.adView.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.iconImageView.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.adView.iconImageView.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.adView.iconImageView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-7].active = YES;
    [self.adView.iconImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-274.5].active = YES;
    self.adView.iconImageView.layer.cornerRadius = 10;
    self.adView.iconImageView.layer.masksToBounds = YES;
    
    // 头像挂件
    self.icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.icon.layer.cornerRadius = 12;
    self.icon.clipsToBounds = YES;
    self.icon.backgroundColor = [UIColor colorWithRed:0.192 green:0.522 blue:0.988 alpha:1];
    self.icon.alpha = 0;
    self.icon.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    self.icon.userInteractionEnabled = NO;
    [self.adView addSubview:self.icon];
    self.icon.contentMode = UIViewContentModeCenter;
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.icon.centerYAnchor constraintEqualToAnchor:self.adView.iconImageView.bottomAnchor].active = YES;
    [self.icon.centerXAnchor constraintEqualToAnchor:self.adView.iconImageView.centerXAnchor].active = YES;
    [self.icon.widthAnchor constraintEqualToConstant:24].active = YES;
    [self.icon.heightAnchor constraintEqualToConstant:24].active = YES;
    
    // descLabel
    self.adView.descLabel.numberOfLines = 2;
    self.adView.descLabel.font = [UIFont systemFontOfSize:14];
    self.adView.descLabel.textColor = [UIColor whiteColor];
    self.adView.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.descLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12].active = YES;
    CGFloat descLabelBottomAnchorConstant = -72;
#if DEBUG
    descLabelBottomAnchorConstant = -120;
#endif
    [self.adView.descLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:descLabelBottomAnchorConstant].active = YES;
    [self.adView.descLabel.widthAnchor constraintEqualToConstant:elementWidth].active = YES;
    [self.adView.descLabel.heightAnchor constraintLessThanOrEqualToConstant:39].active = YES;
    
    // titleLabel
    self.adView.titleLabel.textColor = [UIColor whiteColor];
    self.adView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    self.adView.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12].active = YES;
    [self.adView.titleLabel.bottomAnchor constraintEqualToAnchor:self.adView.descLabel.topAnchor constant:-3.5].active = YES;
    
    // clickButton
    self.adView.clickButton.frame = CGRectMake(12, GDTScreenHeight - 84, elementWidth, 37);
    self.adView.clickButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.adView.clickButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.adView.clickButton.layer.cornerRadius = 3;
    self.adView.clickButton.clipsToBounds = YES;
    self.adView.clickButton.alpha = 0;
    self.adView.clickButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.clickButton.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12].active = YES;
    [self.adView.clickButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:descLabelBottomAnchorConstant].active = YES;
    [self.adView.clickButton.widthAnchor constraintEqualToConstant:elementWidth].active = YES;
    [self.adView.clickButton.heightAnchor constraintEqualToConstant:35].active = YES;
    
    // mediaView
    self.adView.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.mediaView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;
    self.consH = [self.adView.mediaView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor];
    self.consH.active = YES;
    [self.adView.mediaView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.adView.mediaView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    
    // logoView
    self.adView.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView.logoView.widthAnchor constraintEqualToConstant:kGDTLogoImageViewDefaultWidth].active = YES;
    [self.adView.logoView.heightAnchor constraintEqualToConstant:kGDTLogoImageViewDefaultHeight].active = YES;
    [self.adView.logoView.rightAnchor constraintEqualToAnchor:self.adView.rightAnchor].active = YES;
    [self.adView.logoView.bottomAnchor constraintEqualToAnchor:self.adView.bottomAnchor constant:-60].active = YES;
    
}

#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    self.adView.delegate = delegate; // adView 广告回调
    self.adView.viewController = vc; // 跳转 VC
    self.adView.mediaView.delegate = self;
    [self.adView setupWithUnifiedNativeAdObject:dataObject];
    if ([dataObject isAdValid]) {
        [self.adView registerDataObject:dataObject clickableViews:@[self.adView.clickButton,
                                                                    self.adView.iconImageView,
                                                                    self.adView.imageView,
                                                                    self.adView.titleLabel,
                                                                    self.adView.descLabel]];
    }
    [dataObject bindImageViews:@[self.adView.imageView] placeholder:nil];
    if (dataObject.imageWidth > 0) {
        self.consH.active = NO;
        self.consH = [self.adView.mediaView.heightAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:(float)dataObject.imageHeight/(float)dataObject.imageWidth];
        self.consH.active = YES;
    }
    NSString *imageName = dataObject.isAppAd ? @"feed_download" : @"feed_link";
    UIImage *image = [UIImage imageNamed:imageName];
    [self.adView.clickButton setImage:image forState:UIControlStateNormal];
    [self.icon setImage:image forState:UIControlStateNormal];
}

- (void)resetAnimations {
    [self.adView.layer removeAllAnimations];
    [self.adView.titleLabel.layer removeAllAnimations];
    [self.adView.descLabel.layer removeAllAnimations];
    [self.adView.clickButton.layer removeAllAnimations];
    self.adView.titleLabel.transform = CGAffineTransformIdentity;
    self.adView.descLabel.transform = CGAffineTransformIdentity;
    self.adView.clickButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.adView.clickButton.alpha = 0;
    self.icon.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.icon.alpha = 1;
    } completion:nil];
    NSInteger delayTime = [self.adView.dataObject isVideoAd] ? 4 : 0;
    [UIView animateWithDuration:[self.adView.dataObject isVideoAd] ? 0.3 : 0 delay:delayTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.adView.titleLabel.transform = CGAffineTransformMakeTranslation(0, -47);
        self.adView.descLabel.transform = CGAffineTransformMakeTranslation(0, -47);
        self.adView.clickButton.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:delayTime + 2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.adView.clickButton.backgroundColor = [UIColor colorWithRed:0.192 green:0.522 blue:0.988 alpha:1];
    } completion:nil];
}

#pragma mark - GDTMediaViewDelegate
- (void)gdt_mediaViewDidPlayFinished:(GDTMediaView *)mediaView
{

}

- (void)gdt_mediaViewDidTapped:(GDTMediaView *)mediaView
{
    
}

@end
