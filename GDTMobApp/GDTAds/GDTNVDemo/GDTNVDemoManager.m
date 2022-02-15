//
//  GDTNVDemoManager.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/12/21.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "GDTNVDemoManager.h"
#import "GDTDLUtils.h"
#import "GDTScanViewController.h"

@implementation GDTNVDemoManager

+ (void)getAdModel:(void (^)(GDTAdBaseModel *adModel))completion {
    if (!self.selectedData) {
        if (completion) completion(nil);
        return;
    }
    [self loadLocalFile:[[self dataUrl] stringByAppendingPathComponent:self.selectedData] completion:^(NSDictionary *data) {
        if (!data) {
            if (completion) completion(nil);
            return;
        }
        GDTAdBaseModel *adModel = [[GDTAdBaseModel alloc] initWithAdDict:[[[data[@"data"] allValues] firstObject][@"list"] firstObject]];
        if (completion) completion(adModel);
    }];
}

+ (void)getTemplate:(void (^)(NSString *template))complation {
    if (!self.selectedTemplate) {
        if (complation) complation(nil);
        return;
    }
    [self loadLocalFile:[[self fileUrl] stringByAppendingPathComponent:self.selectedTemplate] completion:^(NSDictionary * _Nonnull data) {
        if (complation) complation([GDTDLUtils condensedDsl:data]);
    }];
}

+ (void)loadLocalFile:(NSString *)path completion:(void (^)(id data))completion {
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
            if ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSArray class]]) {
                completion(dict);
            } else {
                completion(nil);
            }
        });
    }];
    [dataTask resume];
}


+ (NSString *)fileUrl {
    NSString *host = nil;
#if TARGET_IPHONE_SIMULATOR//模拟器
    host = @"127.0.0.1:8000";
#elif TARGET_OS_IPHONE//真机
    host = [GDTScanViewController currentIp];
#endif
    NSString *url = [NSString stringWithFormat:@"http://%@/file", host];
    return url;
}

+ (NSString *)dataUrl {
    NSString *host = nil;
#if TARGET_IPHONE_SIMULATOR//模拟器
    host = @"127.0.0.1:8000";
#elif TARGET_OS_IPHONE//真机
    host = [GDTScanViewController currentIp];
#endif
    NSString *url = [NSString stringWithFormat:@"http://%@/data", host];
    return url;
}

static NSString * _template = nil;
+ (NSString *)selectedTemplate {
    return _template;
}
+ (void)setSelectedTemplate:(NSString *)selectedTemplate {
    _template = selectedTemplate;
}

static NSString * _data = nil;
+ (NSString *)selectedData {
    return _data;
}
+ (void)setSelectedData:(NSString *)selectedData {
    _data = selectedData;
}

@end
