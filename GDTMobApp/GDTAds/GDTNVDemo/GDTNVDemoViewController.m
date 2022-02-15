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

@interface GDTNVDemoViewController ()<GDTDLRootViewDelegate>

@property (nonatomic, copy) NSString *selectedTemplate;
@property (nonatomic, strong) GDTDLRootView *templateView;
@property (nonatomic, strong) GDTAdBaseModel *adModel;

@end

@implementation GDTNVDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.templateView dlViewDidDisappear];
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
    [self.templateView removeFromSuperview];
    GDTDLTemplateNode *node = [GDTDLTemplateFactory createTemplate:resource];
    GDTDLRootView *view = [GDTDLViewFactory getRootViewWithTemplateNode:node];
    view.delegate = self;
    view.tag = 10032;
    view.frame = self.view.bounds;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.adModel) {
        [dict addEntriesFromDictionary:@{@"callback": self, @"adModel": self.adModel}];
    }
    [dict addEntriesFromDictionary:@{@"safeArea": @(UIRectEdgeAll)}];
    [dict addEntriesFromDictionary:@{@"a":[UIColor redColor], @"b": @"100", @"c": @"的是覅is登记方式冬季福利胜多负少的离开飞机", @"d": @(0)}];
    [view bindData:@{@"dlInfo": dict}];
    self.templateView = view;
    [self.view insertSubview:self.templateView atIndex:0];
    [self.templateView dlViewDidAppear];
}

- (IBAction)handleReload:(id)sender {
    [self reload];
}

@end
