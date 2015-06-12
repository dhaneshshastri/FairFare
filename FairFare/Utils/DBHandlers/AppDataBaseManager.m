//
//  AppDataBaseManager.m
//  FairFare
//
//  Created by dhaneshs on 01/05/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "AppDataBaseManager.h"

@implementation AppDataBaseManager
static AppDataBaseManager *appDataBaseManager;
+ (AppDataBaseManager *)appDataBaseManager
{
    @synchronized(self)
    {
        if (!appDataBaseManager)
        {
            appDataBaseManager = [[AppDataBaseManager alloc] init];
        }
        return appDataBaseManager;
    }
}
- (id)init
{
    self = [super init];
    
    if(self)
    {
        return self;
    }
    return nil;
}
- (Journey*)createJourneyEntryWith:(NSDictionary*)dictionary
{
    Journey* journey = (Journey*)[self createDataEntryFor:@"Journey"];
    if(!journey)
    {
        return nil;
    }
    journey.journeyDate = getCurrentDateAndTime();
    
    if(!isDictionarySafe(dictionary))
    {
        return journey;
    }
    journey.startLocationId = dictionary[@"startLocationId"];
    journey.endLocationId = dictionary[@"endLocationId"];
    [self saveContext:nil];
    return journey;
}
- (Address*)createAddressEntryWith:(NSDictionary*)dictionary
{
    Address* address = (Address*)[self createDataEntryFor:@"Address"];
    if(!address)
    {
        return nil;
    }
    address.isSource = dictionary[@"isSource"] ? [dictionary[@"isSource"] doubleValue] : NO;
    address.isDestination = dictionary[@"isDestination"] ? [dictionary[@"isDestination"] doubleValue] : NO;
    address.lat = [dictionary[@"lat"] doubleValue];
    address.lon = [dictionary[@"lon"] doubleValue];
    address.journeyId = dictionary[@"journeyId"];
    
    
    NSDictionary* addressDict = safeDictionary(dictionary[@"address"]);
    address.subLocality = addressDict[@"sublocality"];
    address.locality = addressDict[@"locality"];
    address.thoroughfare = addressDict[@"thoroughfare"];
    address.subLocality = addressDict[@"administrativeArea"];
    address.postalCode = addressDict[@"postalCode"];
    address.country = addressDict[@"country"];
    
    //Address lines
    NSArray* addressLines = safeArray(addressDict[@"lines"]);
    address.addressLine1 = addressLines[0];
    address.addressLine2 = addressLines[1];
    
    
    [self saveContext:nil];
    return address;
}
- (void)deleteJourneyWithId:(NSString*)journeyId
{
    //Delete entries
    [[DataBaseManager dataBaseManager] deleteEntityWithName:@"Journey"
                                                  andSelfId:journeyId];
    
    [[DataBaseManager dataBaseManager] deleteAllFrom:@"Address"
                                       withModelName:nil
                                     andSearchFormat:@"journeyId == %@",journeyId];
    [[DataBaseManager dataBaseManager] saveContext:nil];
}
- (void)addLocationToJourneyWithId:(NSString*)journeyId
                               lat:(double)lat
                            andLon:(double)lon
{
    if(!journeyId)
        return;
    Address* address = (Address*)[self createDataEntryFor:@"Address"];
    [address setLat:lat];
    [address setLon:lon];
    [address setJourneyId:journeyId];
    [self saveContext:nil];
}
- (NSArray*)journeys
{
    NSArray* array = [self fetchedResultsFor:@"Journey"
                                     sortKey:nil sortAscending:NO];
    return safeArray(array);
}
- (Journey*)journeyWithId:(NSString*)journeyId
{
    NSArray* array = [self fetchedResultsFor:@"Journey"
                                     sortKey:nil
                             andSearchformat:@"selfId == %@",journeyId];
    return safeArray(array)[0];
}
- (Address*)addressWithId:(NSString*)addressId
{
    NSArray* addresses = [self fetchedResultsFor:@"Address"
                                         sortKey:nil
                                 andSearchformat:@"selfId == %@",addressId];
    return safeArray(addresses)[0];
}
- (Address*)addressWithId:(NSString*)addressId
             andJourneyId:(NSString*)journeyId
{
    NSArray* addresses = [self fetchedResultsFor:@"Address"
                                         sortKey:nil
                                 andSearchformat:@"selfId == %@ AND journeyId == %@",addressId,journeyId];
    return safeArray(addresses)[0];
}
@end
