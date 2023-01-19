//
//  MediationAdapterUtil.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediationAdapterUtil : NSObject

+ (NSMutableDictionary *_Nullable)getURLParams:(NSString *)url;

+ (void)imageView:(UIImageView *)imageView
      setImageUrl:(NSString *)urlStr
 placeholderImage:(UIImage *_Nullable)image;

+ (void)sendRequest:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
