//
//  DataBaseManager.m
//  iSalesTool
//
//  Created by Administrator on 21/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DataBaseManager.h"
//#import "NSDictionary + Validation.h"
#define DB_NAME @"FairFare"
#define DB_MODEL_PLIST_NAME @"DBModel.plist"
#define DB_ENTRIES_PATHS_PLIST_NAME @"DBEntriesPaths.plist"
@interface DataBaseManager ()
{
    NSMutableDictionary* _managedObjectModels;
    NSMutableDictionary* _createdEntities;
}
@end
@implementation DataBaseManager
static DataBaseManager *dataBaseManager;
@synthesize currentCustomerDetail;
@synthesize customerDetailUid;
@synthesize storeName;

+ (DataBaseManager *)dataBaseManager
{
    @synchronized(self)
    {
        if (!dataBaseManager)
        {
            dataBaseManager = [[DataBaseManager alloc] init];
        }
        return dataBaseManager;
    }
}
- (id)init
{
    self = [super init];
    
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextChanged:) name:NSManagedObjectContextDidSaveNotification object:nil];

        [self setStoreName:DB_NAME];
        [self persistentStoreCoordinator];

        return self;
    }
    return nil;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
    self.customerDetailUid = nil;
    
    persistentStoreCoordinator_ = nil;
    managedObjectModel_ = nil;
    persistentStoreCoordinatorForIssue_ = nil;
    managedObjectModelForIssue_ = nil;
}

static NSString * const AQPerThreadManagedObjectContext = @"AQPerThreadManagedObjectContext";

void StoreManagedObjectContextForCurrentThread( NSManagedObjectContext * context )
{
    [[NSThread currentThread] threadDictionary][[DataBaseManager dataBaseManager].storeName] = context;
}


- (void)setStoreName:(NSString *)storeName_
{
    //set to user defaults
    [[NSUserDefaults standardUserDefaults] setValue:storeName_ forKey:CurrentStore];
}
- (NSString*)storeName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:CurrentStore];
}
- (void)setCurrentPersistantStore:(NSString*)storeName_
{
 //   logToConsole(@"Loadng .... %@",storeName_);

    if([storeName_ isEqualToString:@"Book"])
    {
     //   logToConsole(@"Loadng .... %@",storeName_);
    }
    self.storeName = storeName_;
}

- (void)releaseCoreData
{
    [self resetPersistentStore]; 
}

- (NSPersistentStoreCoordinator *)resetPersistentStore
{
    NSError *error = nil;
    
    if ([persistentStoreCoordinator_ persistentStores] == nil)
        return [self persistentStoreCoordinator];
    
  
    
    // FIXME: dirty. If there are many stores...
    NSPersistentStore *store = [[persistentStoreCoordinator_ persistentStores] lastObject];
    
    if (![persistentStoreCoordinator_ removePersistentStore:store error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    // Delete the reference to non-existing store
    persistentStoreCoordinator_ = nil;
    
    return nil;
}

- (void)mergeChanges:(NSNotification *)notification
{
    NSManagedObjectContext *mainContext = [self managedObjectContextFor:nil];
    
    // Merge changes into the main context on the main thread
    [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
}


- (NSFetchedResultsController *)fetchedResultsControllerFor:(NSString*)stringModelNAme 
                                                    sortKey:(NSString*)key
                                            andSearchformat:(NSString *)predicateFormat, ... 
                                                 
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    if(!entity)
    {
        fetchRequest = nil;
        return nil;
    }
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    va_list args;
    va_start(args, predicateFormat);
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    
    [fetchRequest setPredicate:predicate];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
                                                              initWithFetchRequest:fetchRequest 
                                                              managedObjectContext:[self managedObjectContextFor:stringModelNAme]
                                                              sectionNameKeyPath:nil 
                                                              cacheName:nil] ;
    aFetchedResultsController.delegate = self;
    
    fetchRequest = nil;
    
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    sortDescriptor = nil;
    sortDescriptors = nil;
    return aFetchedResultsController;
}
- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme 
                      sortKey:(NSString *)key 
              andSearchformat:(NSString *)predicateFormat, ...
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    if(!entity)
    {
        fetchRequest = nil;
        return nil;
    }
    [fetchRequest setEntity:entity];
    
    
    if(!key)
        key = [self defaultSortKeyForEntity:stringModelNAme];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    va_list args;
    va_start(args, predicateFormat);
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                              initWithFetchRequest:fetchRequest 
                                                              managedObjectContext:[self managedObjectContextFor:stringModelNAme] 
                                                              sectionNameKeyPath:nil 
                                                              cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    fetchRequest = nil;
    
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    sortDescriptor = nil;
    sortDescriptors = nil;
    return safeArray([aFetchedResultsController fetchedObjects]);
}

- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme 
                      sortKey:(NSString *)key 
                secondSortKey:(NSString *)secondKey
              andSearchformat:(NSString *)predicateFormat, ...
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    if(!entity)
    {
        fetchRequest = nil;
        return nil;
    }
    [fetchRequest setEntity:entity];
    
    
    if(!key)
        key = [self defaultSortKeyForEntity:stringModelNAme];
    
    if(!secondKey)
        secondKey = [self defaultSortKeyForEntity:stringModelNAme];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:secondKey ascending:YES];

    NSArray *sortDescriptors = @[sortDescriptor, sortDescriptor1];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    va_list args;
    va_start(args, predicateFormat);
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    
    [fetchRequest setPredicate:predicate];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                              initWithFetchRequest:fetchRequest 
                                                              managedObjectContext:[self managedObjectContextFor:stringModelNAme]
                                                              sectionNameKeyPath:nil 
                                                              cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    fetchRequest = nil;
    
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    sortDescriptor = nil;
    sortDescriptor1 = nil;
    sortDescriptors = nil;
    return safeArray([aFetchedResultsController fetchedObjects]);
}

- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme
                      sortKey:(NSString *)key
                sortAscending:(BOOL)ascending
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme
                                              inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    
    if(!entity)
    {
        fetchRequest = nil;
        return nil;
    }
    
    [fetchRequest setEntity:entity];
    
    if(!key)
        key = [self defaultSortKeyForEntity:stringModelNAme];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                              initWithFetchRequest:fetchRequest
                                                              managedObjectContext:[self managedObjectContextFor:stringModelNAme]
                                                              sectionNameKeyPath:nil
                                                              cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    fetchRequest = nil;
    
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    sortDescriptor = nil;
    sortDescriptors = nil;
    return safeArray([aFetchedResultsController fetchedObjects]);
}
- (NSArray*)fetchUniqueResultsFor:(NSString*)stringModelNAme andKeyAttribute:(NSString*)attribute
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:stringModelNAme];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme
                                              inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:attribute]];
    fetchRequest.returnsDistinctResults = YES;
    
    // Now it should yield an NSArray of distinct values in dictionaries.
    NSArray *dictionaries = [[self managedObjectContextFor:stringModelNAme] executeFetchRequest:fetchRequest error:nil];
    
    return safeArray(dictionaries);
}
- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme 
                      sortKey:(NSString *)key
                sortAscending:(BOOL)ascending
                 searchformat:(NSString *)predicateFormat, ...
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    if(!entity)
    {
        fetchRequest = nil;
        return nil;
    }
    [fetchRequest setEntity:entity];
    
    
    if(!key)
        key = [self defaultSortKeyForEntity:stringModelNAme];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    va_list args;
    va_start(args, predicateFormat);
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                              initWithFetchRequest:fetchRequest 
                                                              managedObjectContext:[self managedObjectContextFor:stringModelNAme]
                                                              sectionNameKeyPath:nil 
                                                              cacheName:nil];
    aFetchedResultsController.delegate = self;

    fetchRequest = nil;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    sortDescriptor = nil;
    sortDescriptors = nil;
    return safeArray([aFetchedResultsController fetchedObjects]);
}

- (NSArray*)fetchedResultsFor:(NSString *)stringModelNAme 
                      sortKey:(NSString *)key 
              predicateFormat:(NSString*)predicateFormat
           andSearchArguments:(va_list*)args
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:stringModelNAme inManagedObjectContext:[self managedObjectContextFor:stringModelNAme]];
    if(!entity)
    {
        fetchRequest = nil;
        return nil;
    }
    [fetchRequest setEntity:entity];

    if(!key)
        key = [self defaultSortKeyForEntity:stringModelNAme];
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    


    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicateFormat arguments:*args];
    [fetchRequest setPredicate:predicate];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                              initWithFetchRequest:fetchRequest 
                                                              managedObjectContext:[self managedObjectContextFor:stringModelNAme]
                                                              sectionNameKeyPath:nil 
                                                              cacheName:nil];
    aFetchedResultsController.delegate = self;
    fetchRequest = nil;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
    sortDescriptor = nil;
    sortDescriptors = nil;
    return safeArray([aFetchedResultsController fetchedObjects]);
}
- (void)deleteEntity:(NSManagedObject* __strong *)entity
{
    if(!(*entity))
        return;
    [[self managedObjectContextFor:nil] deleteObject:*entity];
    [[self managedObjectContextFor:nil] save:nil];
    
    *entity = nil;
}
- (void)deleteEntity:(NSManagedObject*)entity
             sortKey:(NSString*)key
    associatedEntity:(NSString*)associatedEntity 
     andSearchFormat:(NSString*)predicateFormat, ...
{
    //Directly delete this entity
    //Search for the pridicate in associated entity name
    if(!entity)
        return;

    va_list args;
    va_start(args, predicateFormat);
    NSArray* array = [self fetchedResultsFor:associatedEntity 
                                     sortKey:key 
                             predicateFormat:predicateFormat 
                          andSearchArguments:&args];
    va_end(args);
    if(array && [array count] > 0)
    {
        for(NSManagedObject* object in array)
        {
            [[self managedObjectContextFor:nil] deleteObject:object];
            [[self managedObjectContextFor:nil] save:nil];
        }
    }
    [[self managedObjectContextFor:nil] deleteObject:entity];
    [self saveContext:nil];
}

- (NSString*)defaultSortKeyForEntity:(NSString*)entityName
{
    NSString* retSortKey = @"selfId";
    
    return retSortKey;
}
- (NSManagedObject*)createUniqueDataEntryFor:(NSString*)entityName
                                 matchFormat:(NSString *)predicateFormat, ...
{
    va_list args;
    va_start(args, predicateFormat);
    NSArray* array = [self fetchedResultsFor:entityName sortKey:nil predicateFormat:predicateFormat andSearchArguments:&args];
    va_end(args);
    return (safeArray(array)[0] ? : [self createDataEntryFor:entityName]);
}
- (NSManagedObject*)createDataEntryFor:(NSString*)entityNAme
{
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:entityNAme
                                                            inManagedObjectContext:[self managedObjectContextFor:entityNAme]];
    
    if([(id)object respondsToSelector:NSSelectorFromString(@"setSelfId:")])
    {
        [(id)object setValue:getCurrentDetailedDateAndTime()
                      forKey:@"selfId"];//Init
        
    }
    return object;
}
- (void)deleteEntity:(NSManagedObject*)entity
            withType:(NSString*)type
{
    NSManagedObjectContext* context = entity.managedObjectContext;
    [context deleteObject:entity];
    
    [self saveContext:type];
}
- (void)deleteAllFrom:(NSString*)entity
        withModelName:(NSString*)modelName
      andSearchFormat:(NSString*)predicateFormat, ...
{
    va_list args;
    va_start(args, predicateFormat);
    NSArray* array = [self fetchedResultsFor:entity sortKey:nil predicateFormat:predicateFormat andSearchArguments:&args];
    va_end(args);
    if(array && [array count])
    {
        for(NSManagedObject* dataEntity in array)
        {
            [[self managedObjectContextFor:modelName] deleteObject:dataEntity];
            [[self managedObjectContextFor:modelName] save:nil];
        }
    }
}


- (void)contextChanged:(NSNotification*)notification
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(contextChanged:) withObject:notification waitUntilDone:YES];
        return;
    }
    
    [(NSManagedObjectContext*)[notification object] mergeChangesFromContextDidSaveNotification:notification];
}
- (void)saveContext:(NSString*)type
{
    NSError* error = nil;

    if ([self managedObjectContextFor:type] != nil) {
        
       // NSError* error = nil;
        [[self managedObjectContextFor:type] save:&error];
    }
    
#ifdef DEBUG
    //Debug error handling
    if(error)
        NSAssert(0, nil);
#endif
    
}
- (void)saveContextWith
{
    if ([self managedObjectContextFor:nil] != nil) {
        
        NSError* error = nil;
        [[self managedObjectContextFor:nil] save:&error];
    }
}
#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {

    NSManagedObjectContext * result = [[NSThread currentThread] threadDictionary][self.storeName];
    if ( result != nil )
    {
        
        return ( result );
    }
    
    NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
	
    [moc setMergePolicy: NSMergeByPropertyObjectTrumpMergePolicy];
    
    [moc setPersistentStoreCoordinator: [self persistentStoreCoordinator]];
    
    StoreManagedObjectContextForCurrentThread(moc);
    
    return (moc);
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */

- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}
- (NSManagedObjectModel *)managedObjectModelForIssue {
    
    if (managedObjectModelForIssue_ != nil) {
        return managedObjectModelForIssue_;
    }
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Issue" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModelForIssue_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModelForIssue_;
}
- (NSManagedObjectModel *)managedObjectModelForMissingAssets {
    
    if (managedObjectModelForMissingAssets_ != nil) {
        return managedObjectModelForMissingAssets_;
    }
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"MissingAsset" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModelForMissingAssets_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModelForMissingAssets_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }


    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite",self.storeName]]];

    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return persistentStoreCoordinator_;
}
static NSString * const AQPerThreadManagedObjectContextForIssue = @"AQPerThreadManagedObjectContextForIssue";
static NSString * const AQPerThreadManagedObjectContextFoMissingAssets = @"AQPerThreadManagedObjectContextFoMissingAssets";


- (NSManagedObjectContext*)managedObjectContextFor:(NSString*)type
{
    NSString* storeName_ = nil;
    
    if([type isEqualToString:@"Entity"])
    {
        storeName_ = @"MasterModel";
    }
    else
    {
        storeName_ = DB_NAME;
    }

    NSManagedObjectContext * result = [[NSThread currentThread] threadDictionary][storeName_];
    if ( result != nil)
    {
        return ( result );
    }
    
    NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
    
    [moc setMergePolicy: NSMergeByPropertyObjectTrumpMergePolicy];
    
    [moc setPersistentStoreCoordinator: [self persistantStoreCoordinatorFor:storeName_]];
    
    [[NSThread currentThread] threadDictionary][storeName_] = moc;
    
    return (moc);
}

- (NSPersistentStoreCoordinator*)persistantStoreCoordinatorFor:(NSString*)storeName_
{
//    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite",storeName_]]];
    NSURL *storeURL = nil;
    if([[storeName_ pathExtension] isEqualToString:@"sqlite"])
    {
        storeURL = [NSURL fileURLWithPath: storeName_];
    }
    else
    {
        storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite",storeName_]]];
    }
    
    NSError *error = nil;
    NSManagedObjectModel* newModel = [self managedObjectModelFor:storeName_];
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:newModel];
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     
                                     [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,nil];
    
    NSPersistentStore* store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                        configuration:nil
                                                                                  URL:storeURL
                                                                              options:optionsDictionary
                                                                                error:&error];
    if (!store) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return persistentStoreCoordinator;
}
- (BOOL)migrateStore:(NSURL *)storeURL
   toVersionTwoStore:(NSURL *)dstStoreURL
               error:(NSError **)outError
            modelSrc:(NSManagedObjectModel*)modelSrc
        andModelDest:(NSManagedObjectModel*)modelDest
{
    // Try to get an inferred mapping model.
    NSMappingModel *mappingModel =
    [NSMappingModel inferredMappingModelForSourceModel:modelSrc
                                      destinationModel:modelDest
                                                 error:outError];
    
    // If Core Data cannot create an inferred mapping model, return NO.
    if (!mappingModel) {
        return NO;
    }
    
    // Create a migration manager to perform the migration.
    NSMigrationManager *manager = [[NSMigrationManager alloc]
                                   initWithSourceModel:modelSrc
                                   destinationModel:modelDest];
    
    BOOL success = [manager migrateStoreFromURL:storeURL
                                           type:NSSQLiteStoreType
                                        options:nil
                               withMappingModel:mappingModel
                               toDestinationURL:dstStoreURL
                                destinationType:NSSQLiteStoreType
                             destinationOptions:nil
                                          error:outError];
    

    
    return success;
}
- (NSManagedObjectModel*)managedObjectModelFor:(NSString*)managedModelName
{
    if(!managedModelName)
    {
        managedModelName = DB_NAME;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:managedModelName
                                                          ofType:@"momd"];
    NSURL *modelURL = nil;
    
    if(!_managedObjectModels)
    {
        _managedObjectModels = [NSMutableDictionary new];
    }
    if(modelPath)
    {
        modelURL = [NSURL fileURLWithPath:modelPath];
        NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        
        _managedObjectModels[managedModelName] = managedObjectModel;
        
        managedObjectModel = nil;
        
        return _managedObjectModels[managedModelName];
    }

    NSManagedObjectModel *managedObjectModel = _managedObjectModels[managedModelName];
    if(managedObjectModel)
    {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel alloc] init];
    _managedObjectModels[managedModelName] = managedObjectModel;
    
    
    managedObjectModel = nil;
    
    return _managedObjectModels[managedModelName];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



#pragma DBMethods
- (NSArray*)masterModelEntities
{
    NSArray* array = [self fetchedResultsFor:@"Entity"
                                     sortKey:nil
                             andSearchformat:nil];
    return array;
}
//This will check the MasterModel table and then it finds the entry, will return yes, No otherwise
- (BOOL)isEntityExistsWithName:(NSString*)entityName
{
    NSArray* array = [self fetchedResultsFor:@"Entity"
                                     sortKey:nil
                             andSearchformat:@"modelEntity == %@",entityName];
    
    return (array) ? YES : NO;
}
@end
