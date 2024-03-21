//
//  NativeFullVideoAdViewCell.m
//  GDTMobApp
//
//  Created by Andrew on 2024/1/25.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "NativeFullVideoAdViewCell.h"

@interface NativeFullVideoAdViewCell()
@property (nonatomic, strong) UIImageView *bg;
@end

@implementation NativeFullVideoAdViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addlabel];
    }
    return self;
}
- (void)setAdView:(GDTNativeExpressAdView *)adView {
    if (_adView) {
        if (_adView == adView) {
            return;
        } else {
            [_adView removeFromSuperview];
            _adView = adView;
        }
    } else {
        _adView = adView;
    }
    _bg.hidden = _adView;
    if (_adView) {
        _adView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_adView];
    }
}
- (void)addlabel {
    _bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height-100)];
    _bg.image = [UIImage imageNamed:@"bg"];
    _bg.contentMode = UIViewContentModeScaleAspectFill;
    _bg.clipsToBounds = YES;
    [self.contentView addSubview:_bg];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-100, self.contentView.frame.size.width, 100)];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:22];
    label2.text = @"这里是开发提醒上滑区";
    label2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label2];
}
@end
