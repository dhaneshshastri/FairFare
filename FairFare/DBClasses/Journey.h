//
//  Journey.h
//  
//
//  Created by dhaneshs on 30/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Journey : NSManagedObject

@property (nonatomic, retain) NSString * selfId;
@property (nonatomic, retain) NSString * journeyDate;
@property (nonatomic, retain) NSString * startLocationId;
@property (nonatomic, retain) NSString * endLocationId;

@end
