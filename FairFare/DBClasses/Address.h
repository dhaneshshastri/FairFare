//
//  Address.h
//  
//
//  Created by dhaneshs on 30/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * selfId;
@property (nonatomic) double lat;
@property (nonatomic) double lon;
@property (nonatomic, retain) NSString * address;
@property (nonatomic) BOOL isDestination;
@property (nonatomic) BOOL isSource;

@end
