//
//  GDTAppDelegate.m
//  GDTMobApp
//
//  Created by GaoChao on 13-12-2.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "GDTAppDelegate.h"
#import "GDTSDKConfig.h"
#import "GDTAdViewController.h"

@implementation GDTAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *vc = [[GDTAdViewController alloc] init];
    self.nav = [[GDTNavigationController alloc] initWithRootViewController:vc];
    self.nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.nav.navigationBar.topItem.title = [NSString stringWithFormat:@"广告形式   ver %@",[GDTSDKConfig sdkVersion]];
    self.nav.navigationBar.translucent = NO;

    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];

    //设置地理位置信息
    //[GDTSDKConfig setExtraUserData:@{@"lng":@"116.3899", @"lat":@"39.8766", @"loc_time":@"1639450944"}];

    // 初始化SDK
    BOOL result = [GDTSDKConfig initWithAppId:kGDTMobSDKAppId];
    if (result) {
        NSLog(@"初始化成功");
    }
    // 启动SDK
    [GDTSDKConfig startWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"启动成功");
        }
    }];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([[url scheme] isEqual:@"ylh"] &&
        [url.absoluteString hasPrefix:@"ylh://com.qq.e.union.demo/main"]) {
        return YES;
    }
    return NO;
}

@end
