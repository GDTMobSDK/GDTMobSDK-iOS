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
#import "GDTScanViewController.h"
#import "GDTDLUtils.h"

@interface GDTNVDemoViewController ()<GDTDLRootViewDelegate>

@property (nonatomic, copy) NSString *selectedTemplate;
@property (nonatomic, strong) GDTDLRootView *templateView;

@end

@implementation GDTNVDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedTemplate = @"animations.json";
    [self handleReload];
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithTitle:@"配置" style:UIBarButtonItemStylePlain target:self action:@selector(handleSetting)];
    self.navigationItem.rightBarButtonItems = @[setting];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.templateView stopAnimationIfNeccessary];
}

- (void)gdt_dlRootViewTouchesBegan:(GDTDLTouchInfo *)info {
    NSLog(@"touch began");
}

- (void)gdt_dlRootViewTouchesEnded:(GDTDLTouchInfo *)info {
    NSLog(@"touch end");
}

- (void)handleSetting {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) ws = self;
    UIAlertAction *qr = [UIAlertAction actionWithTitle:@"扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws handleScan];
    }];
    UIAlertAction *menu = [UIAlertAction actionWithTitle:@"模板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws handleMenu];
    }];
    UIAlertAction *reload = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws handleReload];
    }];
    [alert addAction:qr];
    [alert addAction:menu];
    [alert addAction:reload];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleScan {
    GDTScanViewController *vc = [[GDTScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleMenu {
    [self loadLocalFile:[self fileUrl] completion:^(NSDictionary *data) {
        if ([data[@"data"] isKindOfClass:[NSArray class]]) {
            [self selectTemplate:data[@"data"]];
        }
    }];
}

- (void)handleReload {
    [self loadLocalFile:[[self fileUrl] stringByAppendingPathComponent:self.selectedTemplate] completion:^(NSDictionary *data) {
        [self reloadTemplate:[GDTDLUtils condensedDsl:data]];
    }];
}

- (void)selectTemplate:(NSArray *)files {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) ws = self;
    for (NSString *file in files) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:file style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([file isEqualToString:ws.selectedTemplate]) return;
            ws.selectedTemplate = file;
            [ws handleReload];
        }];
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadLocalFile:(NSString *)path completion:(void (^)(NSDictionary *data))completion {
    if (!completion) return;
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!data.length) {
                GDTLog(@"No data");
                completion(nil);
                return;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                completion(dict);
            } else {
                completion(nil);
            }
        });
    }];
    [dataTask resume];
}

- (void)reloadTemplate:(NSString *)template {
    NSString *resource = template;
    [self.templateView removeFromSuperview];
    GDTDLTemplateNode *node = [GDTDLTemplateFactory createTemplate:resource];
    GDTDLRootView *view = [GDTDLViewFactory getRootViewWithTemplateNode:node];
    view.delegate = self;
    view.frame = self.view.bounds;
    [view bindData:@{}];
    self.templateView = view;
    [self.view addSubview:self.templateView];
    [self.templateView doAnimationIfNeccessary];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    if (!dict) {
        GDTLog(@"File error");
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        GDTLog(@"%@", error);
        return nil;
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

- (NSString *)fileUrl {
    NSString *host = nil;
#if TARGET_IPHONE_SIMULATOR//模拟器
    host = @"127.0.0.1:8000";
#elif TARGET_OS_IPHONE//真机
    host = [GDTScanViewController currentIp];
#endif
    NSString *url = [NSString stringWithFormat:@"http://%@/file", host];
    return url;
}

@end
