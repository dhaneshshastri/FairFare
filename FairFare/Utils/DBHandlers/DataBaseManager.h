//
//  DataBaseManager.h
//  iSalesTool
//
//  Created by Administrator on 21/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#define CurrentStore @"CurrentStore"
@interface DataBaseManager : NSObject <NSFetchedResultsControllerDelegate>{

    NSManagedObjectModel *managedObjectModel_;
    NSManagedObjectModel* managedObjectModelForIssue_;
    NSManagedObjectModel* managedObjectModelForMissingAssets_;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    NSPersistentStoreCoordinator* persistentStoreCoordinatorForIssue_;
    NSPersistentStoreCoordinator* persistentStoreCoordinatorForMissingAssets_;
    
}
@property (strong, nonatomic,readonly) NSDictionary* currentCustomerDetail;
@property (nonatomic,strong) NSString* customerDetailUid;
@property (nonatomic,strong) NSString* storeName;


- (void)releaseCoreData;

+ (DataBaseManager*)dataBaseManager;
- (NSManagedObjectContext*)managedObjectContextFor:(NSString*)type;



- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;
- (NSManagedObjectModel *)managedObjectModel;

- (NSFetchedResultsController *)fetchedResultsControllerFor:(NSString*)stringModelNAme 
                                                    sortKey:(NSString*)key
                                            andSearchformat:(NSString *)predicateFormat, ... ;

- (NSArray *)fetchedResultsFor:(NSString*)stringModelNAme 
                        sortKey:(NSString*)key
                andSearchformat:(NSString *)predicateFormat, ... ;

- (NSArray *)fetchedResultsFor:(NSString*)stringModelNAme 
                       sortKey:(NSString*)key
                 secondSortKey:(NSString*)secondKey
               andSearchformat:(NSString *)predicateFormat, ... ;

- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme 
                      sortKey:(NSString *)key
                sortAscending:(BOOL)ascending;

- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme 
                      sortKey:(NSString *)key 
              predicateFormat:(NSString*)predicateFormat
           andSearchArguments:(va_list*)args;

- (void)deleteEntity:(NSManagedObject*)entity
             sortKey:(NSString*)key
    associatedEntity:(NSString*)associatedEntity 
     andSearchFormat:(NSString*)predicateFormat, ...;

- (void)deleteEntity:(NSManagedObject* __strong *)entity;

- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme
                      sortKey:(NSString *)key
                sortAscending:(BOOL)ascending
                 searchformat:(NSString *)predicateFormat, ...;
- (NSArray*)fetchUniqueResultsFor:(NSString*)stringModelNAme andKeyAttribute:(NSString*)attribute;


- (void)deleteEntity:(NSManagedObject*)entity withType:(NSString*)type;
- (void)deleteAllFrom:(NSString*)entity
        withModelName:(NSString*)modelName
      andSearchFormat:(NSString *)predicateFormat, ...;

- (NSManagedObject*)createUniqueDataEntryFor:(NSString*)entityName matchFormat:(NSString *)predicateFormat, ...;
- (NSManagedObject*)createDataEntryFor:(NSString*)entityNAme;
- (void)saveContext:(NSString*)type;
- (void)setCurrentPersistantStore:(NSString*)storeName;
void StoreManagedObjectContextForCurrentThread( NSManagedObjectContext * context );
- (NSPersistentStoreCoordinator*)persistantStoreCoordinatorFor:(NSString*)storeName_;
- (NSManagedObjectModel*)managedObjectModelFor:(NSString*)storeName;

- (NSArray*)masterModelEntities;
- (BOOL)isEntityExistsWithName:(NSString*)entityName;


@end
