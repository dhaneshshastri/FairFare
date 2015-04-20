//
//  ContentManager.h
//  FairFare
//
//  Created by dhaneshs on 4/7/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentManager : NSObject
- (NSArray*)cities;
- (NSArray*)services;
- (NSDictionary*)serviceWithServiceId:(NSString*)serviceId;
- (NSDictionary*)providerWithProviderId:(NSString*)providerId andServiceId:(NSString*)serviceId;
- (NSDictionary*)providerWithProviderId:(NSString *)providerId;
- (NSArray*)providersForServiceId:(NSString*)serviceId;
- (NSArray*)subCategoriesForServiceId:(NSString*)serviceId andProviderId:(NSString*)providerId;
- (NSDictionary*)subCategoryForServiceId:(NSString*)serviceId
                         providerId:(NSString*)providerId
                   andSubCategoryId:(NSString*)subCategoryId;
- (NSArray*)faresForServiceId:(NSString*)serviceId
                   providerId:(NSString*)providerId
             andSubCategoryId:(NSString*)subCategoryId;
- (NSDictionary*)detailedFareForFareId:(NSString*)fareId;
- (NSDictionary*)dayOrNightDetailedFareForId:(NSString*)dayOrNightFareId isDay:(BOOL)isDay;
+ (id)sharedManager;
@end
