//
//  GDTAppDelegate+DataDetector.m
//  GDTMobDataDetectorSample
//
//  Created by nimo on 2020/8/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "GDTAppDelegate+DataDetector.h"
#import "GDTSDKConfig.h"
#import "GDTAdViewController.h"
#import "GDTAdViewController.h"
#import "GDTAction.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation GDTAppDelegate (DataDetector)
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 此处填写您的数据源UserActionSetId和在后台看到的secretKey密钥串
    [GDTAction init:@"1106262171" secretKey:@"9be5526f281752a4fda1345fee7cbc56"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *vc = [[GDTAdViewController alloc] init];
    self.nav = [[GDTNavigationController alloc] initWithRootViewController:vc];
    self.nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.nav.navigationBar.topItem.title = [NSString stringWithFormat:@"广告形式   ver %@",[GDTSDKConfig sdkVersion]];
    self.nav.navigationBar.translucent = NO;

    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    BOOL result = [GDTSDKConfig registerAppId:kGDTMobSDKAppId];
    if (result) {
        NSLog(@"注册成功");
    }
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            //  授权完成回调
            // [self loadGDTAd];
        }];
    } else {
        // Fallback on earlier versions
    }
    
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
    /*
     * 在应用启动的时候请上报GDTSDKActionNameStartApp行为
     * SDK内部会判断此次启动行为是否为激活行为并上报，开发者无需另外作判断逻辑
     */
    [GDTAction logAction:GDTSDKActionNameStartApp actionParam:@{}];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [GDTAction logAction:GDTSDKActionNameStartApp actionParam:@{GDTSDKActionParamKeyOpenUrl:url.absoluteString}];
    return YES;
}
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
    self.splash = nil;
}

- (void)splashAdWillClosedBeforeClick:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdDidClosedBeforeClick:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
    self.splash = nil;
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

@end
