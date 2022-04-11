//
//  GDTNVDemoViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2021/5/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "GDTNVDemoViewController.h"
#import "GDTDLTemplateFactory.h"
#import "GDTDLViewFactory.h"
#import "GDTDLRootView.h"
#import "GDTDLUtils.h"
#import "GDTNVDemoManager.h"
#import "UIView+GDTToast.h"
#import "GDTBizFeedVideoPlayerView.h"
#import "GDTDLVideoView.h"
#import "GDTSDKServerService.h"
#import "GDTDLBusinessManager.h"

@interface GDTNVDemoViewController ()<GDTDLRootViewDelegate>

@property (nonatomic, copy) NSString *selectedTemplate;
@property (nonatomic, strong) GDTDLBusinessManager *manager;
@property (nonatomic, strong) GDTAdBaseModel *adModel;

@end

@implementation GDTNVDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [NSClassFromString(@"GDTDLBusinessManager") performSelector:NSSelectorFromString(@"setupRegisterData")];
#pragma clang diagnostic pop
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self reload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"animations" ofType:@"json"];
//    NSString *resource = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
//    CFTimeInterval loadTime = CFAbsoluteTimeGetCurrent();
//    GDTDLTemplateNode *node = [GDTDLTemplateFactory createTemplate:resource];
//    GDTDLRootView *view = [GDTDLViewFactory getRootViewWithTemplateNode:node];
//    view.delegate = self;
//    view.frame = self.view.frame;
//    [view bindData:@{}];
//    NSLog(@"111, %f",(CFAbsoluteTimeGetCurrent() - loadTime) * 1000);
//
//    [self.view addSubview:view];
//    [view doAnimationIfNeccessary];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.manager.rootView dlViewDidDisappear];
}

- (void)gdt_dlRootViewEventsBegan:(GDTDLTouchInfo *)info {
    NSLog(@"touch began");
}

- (void)gdt_dlRootViewEventsEnded:(GDTDLTouchInfo *)info {
    NSLog(@"touch end");
    GDT_SHOW_TOAST(info.interactionEvent.eventAction);
}

- (void)reload {
    [GDTNVDemoManager getAdModel:^(GDTAdBaseModel * _Nonnull adModel) {
        self.adModel = adModel;
        [GDTNVDemoManager getTemplate:^(NSString * _Nonnull template) {
            [self reloadTemplate:template];
        }];
    }];
}

- (void)reloadTemplate:(NSString *)template {
    NSString *resource = template;
    NSData *data = [GDTSDKServerService packageRequestData:resource];
    resource = [GDTSDKServerService base64StringWithData:data];
    
    [self.manager.rootView removeFromSuperview];
    self.manager = [GDTDLBusinessManager managerWithLocalTemlateBase64:resource adModel:self.adModel];
    
    self.manager.delegate = self;
    self.manager.rootView.tag = 10032;
    self.manager.rootView.frame = self.view.bounds;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.adModel) {
        [dict addEntriesFromDictionary:@{@"callback": self, @"adModel": self.adModel}];
    }
    [dict addEntriesFromDictionary:@{@"safeArea": @(UIRectEdgeAll)}];
    [self.adModel.jsonDict addEntriesFromDictionary:@{@"dlInfo": dict ?: @""}];
    [self.manager bindData:self.adModel.jsonDict adModel:self.adModel];
    [self.view insertSubview:self.manager.rootView atIndex:0];
    [self.manager.rootView dlViewDidAppear];
}

- (IBAction)handleReload:(id)sender {
    [self reload];
}

@end
