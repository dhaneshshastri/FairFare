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
- (NSDictionary*)providerWithProviderId:(NSString*)providerId andServiceId:(NSString*)serviceId
{
    if(!serviceId || !providerId)
        return nil;
    NSArray* providers = dataFromPlistFile(@"Providers.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"selfId == %@ AND serviceId == %@", providerId,serviceId];
    NSArray* array = [providers filteredArrayUsingPredicate:predicate];
    return safeArray(array)[0];
}
- (NSDictionary*)providerWithProviderId:(NSString *)providerId
{
    if(!providerId)
        return nil;
    NSArray* services = dataFromPlistFile(@"Providers.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"selfId == %@", providerId];
    NSArray* array = [services filteredArrayUsingPredicate:predicate];
    return safeArray(array)[0];
}
- (NSDictionary*)serviceWithServiceId:(NSString*)serviceId
{
    if(!serviceId)
        return nil;
    NSArray* services = dataFromPlistFile(@"Services.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"selfId == %@", serviceId];
    NSArray* array = [services filteredArrayUsingPredicate:predicate];
    return safeArray(array)[0];
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
- (NSDictionary*)subCategoryForServiceId:(NSString*)serviceId
                         providerId:(NSString*)providerId
                   andSubCategoryId:(NSString*)subCategoryId
{
    NSArray* services = dataFromPlistFile(@"SubCategories.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"serviceId == %@ AND providerId == %@ AND selfId == %@", serviceId,providerId,subCategoryId];
    NSArray* array = [services filteredArrayUsingPredicate:predicate];
    return safeArray(array)[0];
}
- (NSArray*)faresForServiceId:(NSString*)serviceId
                   providerId:(NSString*)providerId
             andSubCategoryId:(NSString*)subCategoryId
{
    NSPredicate* predicate = nil;
    if(!serviceId)
        return nil;
    else if(!providerId && !subCategoryId)
    {
        //Here we need to fetch for autorickshaw
        predicate = [NSPredicate predicateWithFormat:@"serviceId == %@", serviceId];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"serviceId == %@ AND providerId == %@ AND subCategoryId == %@", serviceId,providerId,subCategoryId];
    }
    NSArray* fares = dataFromPlistFile(@"Fares.plist");
    NSArray* array = [fares filteredArrayUsingPredicate:predicate];
    return safeArray(array);
}
- (NSDictionary*)detailedFareForFareId:(NSString*)fareId
{
    if(!fareId)
        return nil;
    NSDictionary* retFareDetails = nil;
    NSArray* fares = dataFromPlistFile(@"Fares.plist");
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"selfId == %@",fareId];
    NSArray* filteredFares = [fares filteredArrayUsingPredicate:predicate];
    NSDictionary* firstFareObject = filteredFares[0];
    NSString* dayTimings = firstFareObject[@"dayTimings"];
    NSString* nightTimings = firstFareObject[@"nightTimings"];
    NSString* dayOrNightFareId = nil;
    if((!dayTimings && !nightTimings) || (dayTimings && !nightTimings))
    {
        dayOrNightFareId = firstFareObject[@"dayFareId"];//Only one entry for day
    }
    else if(!dayTimings && nightTimings)
    {
        dayOrNightFareId = firstFareObject[@"nightFareId"];
    }
    else
    {
        if([self isNowBewteenDates:dayTimings])
        {
            //Day
            //NSLog(@"Day Journey");
            dayOrNightFareId = firstFareObject[@"dayFareId"];
        }
        else if([self isNowBewteenDates:nightTimings])
        {
            //Night
          //  NSLog(@"Night Journey");
            dayOrNightFareId = firstFareObject[@"nightFareId"];
        }
    }
    //As now we have the dayOrNightFareId, fetch the curresponding data from plist
    retFareDetails = [[ContentManager sharedManager] dayOrNightDetailedFareForId:dayOrNightFareId
                                                                           isDay:YES];
    return retFareDetails;
}
- (BOOL)isNowBewteenDates:(NSString*)compareDatesString
{
    //Break the dates
    NSArray* array = [compareDatesString componentsSeparatedByString:@"-"];
    NSString* startDateStr = array[0];
    
    
    NSString* endDateStr = array[1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSDate *startDate = [formatter dateFromString:startDateStr];
    NSDate *endDate = [formatter dateFromString:endDateStr];
    
    
    NSDate* currentDate = [NSDate date];
    
    return isDateBetweenDates(currentDate,
                              startDate,
                              endDate);
}
/*
    Will return the data fetched from 'DayFares' or 'NightFares' plist files
    dayOrNightFareId : represents 'selfId' in 'DayFares' or 'NightFares' plist files
    isDay : YES represents 'DayFares' plist file and NO represents 'NightFares' plist file
*/
- (NSDictionary*)dayOrNightDetailedFareForId:(NSString*)dayOrNightFareId isDay:(BOOL)isDay
{
    if(!dayOrNightFareId)
        return nil;
    NSString* fileName = nil;
    if(isDay)
    {
        fileName = @"DayFares.plist";
    }
    else
    {
        fileName = @"NightFares.plist";
    }
    NSArray* fares = dataFromPlistFile(fileName);
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"selfId == %@",dayOrNightFareId];
    NSArray* array = [fares filteredArrayUsingPredicate:predicate];
    //
    return safeArray(array)[0];//returns nil if no data
}
@end
