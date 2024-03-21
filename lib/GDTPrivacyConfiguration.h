//
//  GDTPrivacyConfiguration.h
//  GDTMediationApp
//
//  Created by Nancy on 2022/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTPrivacyConfiguration : NSObject

/// the COPPA of the user, COPPA is the short of Children's Online Privacy Protection Rule,
/// the interface only works in the United States.
/// Coppa 0 adult, 1 child,  0:default
/// You can change its value at any time
@property (nonatomic, assign) NSInteger coppa;

/// Custom set the CCPA of the user,CCPA is the short of General Data Protection Regulation,the interface only works in USA.
/// CCPA  0: "sale" of personal information is permitted, 1: user has opted out of "sale" of personal information  0: default
@property (nonatomic, assign) NSInteger CCPA;

/// Custom set the GDPR of the user,GDPR is the short of General Data Protection Regulation,the interface only works in The European.
/// GDPR 0 close privacy protection, 1 open privacy protection, 0:default
/// You can change its value at any time
@property (nonatomic, assign) NSInteger GDPR;

/**
 User's consent for advertiser tracking.

 The setter API only works in iOS14 or above and won't take effect in iOS13 or below.
 */
@property (nonatomic, assign) BOOL advertiserTrackingEnabled;

+ (instancetype)configuration;

@end

NS_ASSUME_NONNULL_END
