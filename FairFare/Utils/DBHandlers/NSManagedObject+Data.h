//
//  NSManagedObject+Data.h
//  The A3 Creator
//
//  Created by dhaneshs on 14/08/13.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Data)
+ (NSManagedObject*)createWithEntityName:(NSString*)entityName;
+ (NSManagedObject*)createUniqueDataEntryFor:(NSString*)entityName
                                 matchFormat:(NSString *)predicateFormat, ...;
- (NSDictionary*)dictionary;
- (void)copyFrom:(NSManagedObject*)anotherObject;
- (NSManagedObject*)createCopy;
@end
