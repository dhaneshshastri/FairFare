//
//  Address.h
//  
//
//  Created by dhaneshs on 13/05/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * administrativeArea;
@property (nonatomic, retain) NSString * country;
@property (nonatomic) BOOL isDestination;
@property (nonatomic) BOOL isSource;
@property (nonatomic, retain) NSString * journeyId;
@property (nonatomic) double lat;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic) double lon;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * selfId;
@property (nonatomic, retain) NSString * subLocality;
@property (nonatomic, retain) NSString * thoroughfare;

@end
