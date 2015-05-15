//
//  AppDataBaseManager.h
//  FairFare
//
//  Created by dhaneshs on 01/05/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "DataBaseManager.h"

@interface AppDataBaseManager : DataBaseManager
+ (AppDataBaseManager*)appDataBaseManager;
- (Journey*)createJourneyEntryWith:(NSDictionary*)dictionary;
- (Address*)createAddressEntryWith:(NSDictionary*)dictionary;
- (void)deleteJourneyWithId:(NSString*)journeyId;
- (void)addLocationToJourneyWithId:(NSString*)journeyId
                               lat:(double)lat
                            andLon:(double)lon;
- (NSArray*)journeys;
- (Journey*)journeyWithId:(NSString*)journeyId;
- (Address*)addressWithId:(NSString*)addressId;
- (Address*)addressWithId:(NSString*)addressId
             andJourneyId:(NSString*)journeyId;
@end
