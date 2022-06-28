//
//  MediationAdapterUtil.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "MediationAdapterUtil.h"

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

@end
