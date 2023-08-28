//
//  UnifiedNativeAdBaseViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdBaseViewController.h"
#import "GDTUnifiedNativeAd.h"
#if DEBUG
#import "GDTAppDelegate.h"
#endif

@interface UnifiedNativeAdBaseViewController ()

@end

@implementation UnifiedNativeAdBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#if DEBUG
    self.placementId = self.placementId ? : @"3050349752532954";
#endif
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
