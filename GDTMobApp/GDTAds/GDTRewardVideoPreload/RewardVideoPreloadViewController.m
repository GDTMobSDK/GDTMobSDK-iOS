//
//  RewardVideoPreloadViewController.m
//  GDTMobApp
//
//  Created by 杨玄 on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "RewardVideoPreloadViewController.h"
#import "GDTRewardVideoAd.h"

@interface RewardVideoPreloadViewController () <GDTRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation RewardVideoPreloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadBtn];
    [self.view addSubview:self.showBtn];
    [self.view addSubview:self.textField];
    self.mutableArray = [NSMutableArray array];
}

- (UIButton *)loadBtn {
    if (!_loadBtn) {
        _loadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
        [_loadBtn setTitle:@"load" forState:UIControlStateNormal];
        [_loadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loadBtn addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadBtn;
}

- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 40)];
        [_showBtn setTitle:@"show" forState:UIControlStateNormal];
        [_showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.showBtn.frame)+10, CGRectGetMinY(self.showBtn.frame), 100, 40)];
        _textField.placeholder = @"输入索引";
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _textField;
}

- (void)loadAd {
    [self.mutableArray removeAllObjects];
    for (int i = 0; i < 6; i++) {
        GDTRewardVideoAd *rewardAd = [[GDTRewardVideoAd alloc] initWithPlacementId:@"8020744212936426"];
        rewardAd.delegate = self;
        [self.mutableArray addObject:rewardAd];
    }
    for (int i = 0 ; i < 6; i++) {
        GDTRewardVideoAd *rewardAd = [self.mutableArray objectAtIndex:i];
        [rewardAd loadAd];
    }
}

- (void)showAd {
    NSInteger index = 0;
    if (self.textField.text.length > 0) {
        index = [self.textField.text integerValue];
    }
    [self showAd:index];
}

- (void)showAd:(NSInteger)index {
    if (index >= self.mutableArray.count) {
        NSLog(@"GDTRewardPreload:索引不正确");
        return;
    }
    GDTRewardVideoAd *rewardAd = [self.mutableArray objectAtIndex:index];
    [rewardAd showAdFromRootViewController:self];
}

#pragma mark - GDTRewardVideoAdDelegate

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    NSInteger index = [self.mutableArray indexOfObject:rewardedVideoAd];
    NSLog(@"GDTRewardPreload:-success-%ld-ecpm-%ld",index,rewardedVideoAd.eCPM);
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSInteger index = [self.mutableArray indexOfObject:rewardedVideoAd];
    NSLog(@"GDTRewardPreload:-fail-%ld-errorCode-%ld",index,error.code);
}

@end
