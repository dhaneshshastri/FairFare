//
//  NSManagedObject+Data.m
//  The A3 Creator
//
//  Created by dhaneshs on 14/08/13.
//
//

#import "NSManagedObject+Data.h"

@implementation NSManagedObject (Data)
+ (NSManagedObject*)createWithEntityName:(NSString*)entityName
{
    NSManagedObject* object = [[DataBaseManager dataBaseManager] createDataEntryFor:entityName];
    
    return object;
}
+ (NSManagedObject*)createUniqueDataEntryFor:(NSString*)entityName
                                 matchFormat:(NSString *)predicateFormat, ...
{
    va_list args;
    va_start(args, predicateFormat);
    NSArray* array = [[DataBaseManager dataBaseManager] fetchedResultsFor:entityName sortKey:nil predicateFormat:predicateFormat andSearchArguments:&args];
    va_end(args);
    return safeArray(array)[0] ? : [[DataBaseManager dataBaseManager] createDataEntryFor:entityName];
}
- (NSDictionary*)dictionary
{
    NSArray* keys = [[[self entity] attributesByName] allKeys];
    NSDictionary* retDict = [self dictionaryWithValuesForKeys:keys];
    return retDict;
}
- (void)copyFrom:(NSManagedObject*)anotherObject
{
    ([self.entity.name isEqual:anotherObject.entity.name]) ?
    [self setValuesForKeysWithDictionary:[anotherObject dictionary]] : "";

}
- (NSManagedObject*)createCopy
{
    id retObject = [NSEntityDescription insertNewObjectForEntityForName:self.entity.name
                                                 inManagedObjectContext:[[DataBaseManager dataBaseManager] managedObjectContextFor:nil]];
    
    [retObject setValuesForKeysWithDictionary:[self dictionary]];
    
    return retObject;
}

@end
