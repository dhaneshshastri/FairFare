//
//  ContentManager.m
//  FairFare
//
//  Created by dhaneshs on 4/7/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "ContentManager.h"

@implementation ContentManager
#pragma mark Singleton Methods

+ (id)sharedManager {
    static ContentManager *sharedContentManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContentManager = [[self alloc] init];
    });
    return sharedContentManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}
- (NSArray*)cities
{
    return @[@"Hyderabad",@"Bangalore",@"Chennai"];
}
//Returns safe array
- (NSArray*)services
{
    NSArray* services = dataFromPlistFile(@"Services.plist");
    return safeArray(services);
}
//Returns safe array with configured Predicate applied
- (NSArray*)providersForServiceId:(NSString*)serviceId
{
    if(!serviceId)
        return nil;
    NSArray* services = dataFromPlistFile(@"Providers.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"serviceId == %@", serviceId];
    NSArray* array = [services filteredArrayUsingPredicate:predicate];
    return safeArray(array);
}
//Returns safe array with configured Predicate applied
- (NSArray*)subCategoriesForServiceId:(NSString*)serviceId
                        andProviderId:(NSString*)providerId
{
    if(!serviceId || !providerId)
        return nil;
    NSArray* services = dataFromPlistFile(@"SubCategories.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"serviceId == %@ AND providerId == %@", serviceId,providerId];
    NSArray* array = [services filteredArrayUsingPredicate:predicate];
    return safeArray(array);
}
@end
