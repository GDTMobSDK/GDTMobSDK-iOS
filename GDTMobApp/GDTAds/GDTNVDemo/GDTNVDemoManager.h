//
//  GDTNVDemoManager.h
//  GDTMobApp
//
//  Created by zhangzilong on 2021/12/21.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTAdBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GDTNVDemoManager : NSObject

@property (nonatomic, strong, class) NSString *selectedTemplate;
@property (nonatomic, strong, class) NSString *selectedData;

+ (void)getAdModel:(void (^)(GDTAdBaseModel *adModel))completion;
+ (void)getTemplate:(void (^)(NSString *template))complation;

+ (void)loadLocalFile:(NSString *)path completion:(void (^)(id data))completion;

+ (NSString *)fileUrl;
+ (NSString *)dataUrl;

@end

NS_ASSUME_NONNULL_END
