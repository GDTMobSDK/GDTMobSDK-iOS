//
//  NativeExpressAdConfigView.h
//  GDTMobApp
//
//  Created by 胡城阳 on 2019/11/14.
//  Copyright © 2019 Tencent. All rights reserved.
//


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^CallBackBlcok) (float widthSliderValue,float heightSliderValue,float adCountSliderValue,BOOL navigationRightButtonIsenabled);
@interface NativeExpressAdConfigView : UIView
@property (copy,nonatomic) CallBackBlcok callBackBlock;
@property (strong, nonatomic) UILabel *widthLabel;
@property (strong, nonatomic) UISlider *widthSlider;
@property (strong, nonatomic) UILabel *heightLabel;
@property (strong, nonatomic) UISlider *heightSlider;
@property (strong, nonatomic) UISlider *adCountSlider;
@property (strong, nonatomic) UILabel *adCountLabel;

@property (nonatomic, copy) NSString *placementId;
@property (nonatomic, strong) UILabel *tokenLabel;
@property (nonatomic, strong) UISwitch *useTokenSwitch;
@property (nonatomic, strong) UIButton *getTokenButton;
@property (nonatomic, strong) UILabel *tokenTipLabel;
@property (nonatomic, copy) void (^tokenBlock)(BOOL useToken, NSString *token);

- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  显示属性选择视图
 *
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view;

/**
 *  属性视图的消失
 */
- (void)removeView;
@end

NS_ASSUME_NONNULL_END
