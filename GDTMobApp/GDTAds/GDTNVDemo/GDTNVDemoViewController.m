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

@interface GDTNVDemoViewController ()<GDTDLRootViewDelegate>

@end

@implementation GDTNVDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    // todo test for NV
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"helloNative" ofType:@"json"];
    NSString *resource = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    GDTDLTemplateNode *node = [GDTDLTemplateFactory createTemplate:resource];
    GDTDLRootView *view = [GDTDLViewFactory getRootViewWithTemplateNode:node];
    view.delegate = self;
    view.frame = self.view.bounds;
    [view bindData:@{@"text":@{@"huihui":@"Who is your daddyWho is your daddyWho is your daddyWho is your daddyWho is your daddyWho is your daddy"}}];
    [self.view addSubview:view];
}

- (void)gdt_dlRootViewToucheBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event action:(NSString *)action target:(NSString *)target
{
    NSLog(@"");
}

- (void)gdt_dlRootViewToucheEnd:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event action:(NSString *)action target:(NSString *)target
{
    NSLog(@"");
}

@end
