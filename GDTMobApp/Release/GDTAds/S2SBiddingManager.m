//
//  S2SManager.m
//  GDTMobApp
//
//  Created by zhangzilong on 2021/7/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "S2SBiddingManager.h"
#import "GDTSDKConfig.h"
#import <sys/utsname.h>

NSString * const kS2SUrl = @"https://mi.gdt.qq.com/server_bidding";

@implementation S2SBiddingManager

+ (void)getTokenWithPlacementId:(NSString *)placementId completion:(void (^)(NSString *token))completion {
    NSString *buyerId = [GDTSDKConfig getBuyerIdWithContext:@{@"placementId":placementId ?: @""}];
    if (!placementId || !buyerId) {
        if (completion) completion(nil);
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self getUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    request.HTTPMethod = @"POST";
    [request setValue:@"2.5" forHTTPHeaderField:@"X-OpenRTB-Version"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *sdkInfo = [GDTSDKConfig getSDKInfoWithPlacementId:placementId];
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    NSString *osversion = [[UIDevice currentDevice] systemVersion];
    // 此处需自行设置正确信息
    NSString *params = [NSString stringWithFormat:@"{\"id\":\"5f0417f6354b680001e94518\",\"imp\":[{\"ad_count\":1,\"id\":\"1\",\"video\":{\"minduration\":0,\"maxduration\":46,\"w\":720,\"h\":1422,\"linearity\":1,\"minbitrate\":250,\"maxbitrate\":15000,\"ext\":{\"skip\":0,\"videotype\":\"rewarded\",\"rewarded\":1}},\"tagid\":\"%@\",\"bidfloor\":1,\"bidfloorcur\":\"CNY\",\"secure\":1}],\"app\":{\"id\":\"5afa947e9c8119360fba1bea\",\"name\":\"VungleApp123\",\"bundle\":\"com.qq.gdt.GDTMobAppDemo\"},\"device\":{\"ua\":\"Mozilla/5.0 (Linux; Android 9; SM-A207F Build/PPR1.180610.011; wv) AppleWebKit/537.36 KHTML, like Gecko) Version/4.0 Chrome/74.0.3729.136 Mobile Safari/537.36\",\"geo\":{\"lat\":-7.2484,\"lon\":112.7419},\"ip\":\"115.178.227.128\",\"devicetype\":1,\"make\":\"iPhone\",\"model\":\"%@\",\"os\":\"ios\",\"osv\":\"%@\",\"h\":1422,\"w\":720,\"language\":\"en\",\"connectiontype\":3,\"ifa\":\"dd94e183d8790d057fc73d9c761ea2fa\",\"ext\":{\"oaid\":\"0176863C3B9A5E419BCAF702B37BEFB38B8D05CEA84022FB76BD723BA89D2ED2116F960A73FE1FFB12499E31EF664F5EAE87386F19D8A41390FEBAA5362042BC7A601D4CB006DA4E66\"}},\"cur\":[\"CNY\"],\"ext\":{\"buyer_id\":\"%@\",\"sdk_info\":\"%@\"}}", placementId, machineName, osversion, buyerId, sdkInfo];
    
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!data.length) {
                if (completion) completion(nil);
                return;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (completion) {
                if (dict && dict[@"token"]) {
                    completion(dict[@"token"]);
                } else {
                    completion(nil);
                }
            }
        });
    }];
    [dataTask resume];
}

+(NSURL *)getUrl{
    return [NSURL URLWithString:kS2SUrl];
}

@end
