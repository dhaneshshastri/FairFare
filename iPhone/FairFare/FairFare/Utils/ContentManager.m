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
- (NSArray*)services
{
    NSArray* services = dataFromPlistFile(@"Services.plist");
    return services;
}
- (NSArray*)providersForServiceId:(NSString*)serviceId
{
    if(!serviceId)
        return nil;
    NSArray* services = dataFromPlistFile(@"Providers.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(serviceId == %@)", serviceId];
    NSArray* array = [services filteredArrayUsingPredicate:predicate];
    return array;
}
@end
