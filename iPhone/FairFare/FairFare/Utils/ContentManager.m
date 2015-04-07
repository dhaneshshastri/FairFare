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
    return @[@"Cab",@"Auto Rickshaw"];
}
- (NSArray*)categoriesForServiceId:(NSString*)serviceId
{
    if([serviceId  isEqual: @"1"])
    {
        return @[@"Meru",@"Dot Cabs"];
    }
    else
    {
        return nil;
    }
}
@end
