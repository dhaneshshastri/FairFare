//
//  Journey.h
//  
//
//  Created by dhaneshs on 15/05/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Journey : NSManagedObject

@property (nonatomic) double calculatedFare;
@property (nonatomic) double travelledDistance;
@property (nonatomic, retain) NSString * endLocationId;
@property (nonatomic, retain) NSString * journeyDate;
@property (nonatomic, retain) NSString * providerId;
@property (nonatomic, retain) NSString * selfId;
@property (nonatomic, retain) NSString * serviceId;
@property (nonatomic, retain) NSString * startLocationId;
@property (nonatomic, retain) NSString * subCategoryId;

@end
