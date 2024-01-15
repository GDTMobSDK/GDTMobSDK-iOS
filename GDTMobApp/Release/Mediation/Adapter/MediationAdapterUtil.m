//
//  MediationAdapterUtil.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "MediationAdapterUtil.h"
#import <UIKit/UIKit.h>

@implementation MediationAdapterUtil

+ (NSMutableDictionary *_Nullable)getURLParams:(NSString *)url
{
    if (url.length == 0) {
        return nil;
    }
    NSArray * pairs = [url componentsSeparatedByString:@"&"];
    NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
    for (NSString * pair in pairs) {
        NSArray * bits = [pair componentsSeparatedByString:@"="];
        NSString * key = [[bits objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString * value = [[bits objectAtIndex:1] stringByRemovingPercentEncoding];
        [kvPairs setObject:value forKey:key];
    }
    return kvPairs;
}

+ (void)imageView:(UIImageView *)imageView setImageUrl:(NSString *)urlStr placeholderImage:(UIImage *)image {
    imageView.image = image;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *downloadImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = downloadImage;
        });
    });
}

+ (void)sendRequest:(NSString *)requestUrl {
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error:%@", error);
    }];
    [dataTask resume];
}

@end
