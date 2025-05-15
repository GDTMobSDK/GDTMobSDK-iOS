//
//  GDTAppDelegate.h
//  GDTMobApp
//
//  Created by GaoChao on 13-12-2.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTNavigationController.h"

static NSString *kGDTMobSDKAppId = @"1105344611";

@interface GDTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) GDTNavigationController *nav;
@end
