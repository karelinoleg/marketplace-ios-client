//
//  UGDataController.m
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGDataController.h"
#import <CoreData/CoreData.h>
#import "UGCatalogItemMO.h"
#import "UGShoppingCartItemMO.h"
#import "UGCartItem.h"
#import "UGDeliveryDetailMO.h"
#import "UGCommonBuildOrganizationMO.h"

@implementation UGDataController

@synthesize managedObjectContext;

static NSString *const catalogItemMOName = @"CatalogItem";
static NSString *const shoppingCartItemMOName = @"ShoppingCartItem";
static NSString *const deliveryDetailMOName = @"DeliveryDetail";
static NSString *const deliveryOptionMOName = @"DeliveryOption";
static NSString *const commonBuildOrganizationMOName = @"CommonBuildOrganization";

- (id)init {
    self = [super init];
    if (!self)
        return nil;

    [self initializeCoreData];

    return self;
}

- (void)initializeCoreData {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializaig Managed Object Model");

    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error];
        NSAssert(store != nil, @"Error initializang PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

- (void)saveInternal {
    NSError *error = nil;
    if([[self managedObjectContext] save:&error] == NO)
        NSAssert(NO, @"error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
}

- (UGCatalogItemMO *)storeCatalogItemInternalForIdentity:(NSString *)identity version:(long)version jsonData:(NSString *)jsonData {
    UGCatalogItemMO *catalogItemMO = [self getStoredCatalogItemMO:identity];
    if (catalogItemMO == nil)
        catalogItemMO = [NSEntityDescription insertNewObjectForEntityForName:catalogItemMOName inManagedObjectContext:[self managedObjectContext]];
    [catalogItemMO setIdentity:identity];
    [catalogItemMO setVersion:[NSNumber numberWithLong:version]];
    [catalogItemMO setJsonData:jsonData];
    
    return catalogItemMO;
}

- (void)storeCatalogItemForIdentity:(NSString *)identity version:(long)version jsonData:(NSString *)jsonData {
    [self storeCatalogItemInternalForIdentity:identity version:version jsonData:jsonData];
    [self saveInternal];
}

- (void)removeCatalogItemForIdentity:(NSString*)identity {
    UGCatalogItemMO *mo = [self getStoredCatalogItemMO:identity];
    if (mo == nil)
        return;
    
    [[self managedObjectContext] deleteObject:mo];
    [self saveInternal];
}

+ (UGCatalogItem *)catalogItemFromMO:(UGCatalogItemMO *)mo {
    NSString *json = [mo jsonData];
    NSError *jsonErr = nil;
    NSDictionary *itemsJson = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:kNilOptions
                                                                error:&jsonErr];
    
    return [UGCatalogItem createByParameters:itemsJson];
}

- (UGCatalogItem *)loadStoredCatalogItem:(NSString *)identity {
    UGCatalogItemMO *mo = [self getStoredCatalogItemMO:identity];
    if (mo == nil)
        return nil;
    
    return [UGDataController catalogItemFromMO:mo];
}

- (UGCatalogItemMO *)getStoredCatalogItemMO:(NSString *)identity {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:catalogItemMOName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identity == %@", identity]];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (results) {
        if ([results count] < 1)
            return nil;
        return [results objectAtIndex:0];
    }
    
    NSLog(@"Error fetching %@ objects: %@\n%@", catalogItemMOName, [error localizedDescription], [error userInfo]);
    abort();
}

- (void)storeShoppingCartItemForIdentity:(NSString*)productIdentity version:(long)version productJsonData:(NSString*)productJsonData count:(int)count {
    UGCatalogItemMO *catalogItemMO = [self storeCatalogItemInternalForIdentity:productIdentity version:version jsonData:productJsonData];
    UGShoppingCartItemMO *shoppingCartItemMO = [catalogItemMO shoppingCartItem];
    if (shoppingCartItemMO == nil) {
        shoppingCartItemMO = [NSEntityDescription insertNewObjectForEntityForName:shoppingCartItemMOName inManagedObjectContext:[self managedObjectContext]];
        [catalogItemMO setShoppingCartItem:shoppingCartItemMO];
        [shoppingCartItemMO setProduct:catalogItemMO];
    }
    [shoppingCartItemMO setCount:[NSNumber numberWithInt:count]];
    
    [self saveInternal];
}

- (NSArray *)loadStoredShoppingCartItems {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:shoppingCartItemMOName];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (results) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (UGShoppingCartItemMO *scimo in results) {
            UGCatalogItem *catalogItem = [UGDataController catalogItemFromMO:[scimo product]];
            if ([catalogItem isKindOfClass:[UGProduct class]]) {
                UGCartItem *cartItem = [[UGCartItem alloc] init];
                [cartItem setProduct:(UGProduct *)catalogItem];
                [cartItem setCount:[[scimo count] intValue]];
                [result addObject:cartItem];
            }
        }
        return result;
    }
    
    NSLog(@"Error fetching %@ objects: %@\n%@", shoppingCartItemMOName, [error localizedDescription], [error userInfo]);
    abort();
}

- (void)removeShoppingCartItemForIdentity:(NSString*)identity {
    UGCatalogItemMO *mo = [self getStoredCatalogItemMO:identity];
    if (mo == nil)
        return;
    UGShoppingCartItemMO *scimo = [mo shoppingCartItem];
    if (scimo == nil)
        return;
    [[self managedObjectContext] deleteObject:scimo];
    [self saveInternal];
}

- (void)storeDeliveryOption:(NSString *)deliveryOption pickupPointId:(NSString *)pickupPointId forOrganizationId:(NSString *)organizationId {
    UGDeliveryOptionMO *mo = [self loadDeliveryOptionForOrganizationId:organizationId];
    if (mo == nil)
        mo = [NSEntityDescription insertNewObjectForEntityForName:deliveryOptionMOName inManagedObjectContext:[self managedObjectContext]];
    [mo setOrganizationId:organizationId];
    [mo setDeliveryOption:deliveryOption];
    [mo setPickupPointId:pickupPointId];
    [self saveInternal];
}

- (UGDeliveryOptionMO *)loadDeliveryOptionForOrganizationId:(NSString *)organizationId {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:deliveryOptionMOName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"organizationId == %@", organizationId]];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (results) {
        if ([results count] < 1)
            return nil;
        return [results objectAtIndex:0];
    }
    
    NSLog(@"Error fetching %@ objects: %@\n%@", deliveryOptionMOName, [error localizedDescription], [error userInfo]);
    abort();
}

- (void)storeDeliveryDetail:(NSString *)detail forDetailType:(NSString *)detailType {
    UGDeliveryDetailMO* mo = [self loadDeliveryDetailInternalForDetailType:detailType];
    if (mo == nil)
        mo = [NSEntityDescription insertNewObjectForEntityForName:deliveryDetailMOName inManagedObjectContext:[self managedObjectContext]];
    [mo setDetailType:detailType];
    [mo setDetail:detail];
    [self saveInternal];
}

- (NSString *)loadDeliveryDetailForDetailType:(NSString *)detailType {
    UGDeliveryDetailMO* mo = [self loadDeliveryDetailInternalForDetailType:detailType];
    return mo == nil ? nil : [mo detail];
}

- (UGDeliveryDetailMO *)loadDeliveryDetailInternalForDetailType:(NSString *)detailType {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:deliveryDetailMOName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"detailType == %@", detailType]];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (results) {
        if ([results count] < 1)
            return nil;
        return [results objectAtIndex:0];
    }
    
    NSLog(@"Error fetching %@ objects: %@\n%@", deliveryDetailMOName, [error localizedDescription], [error userInfo]);
    abort();
}

- (UGCommonBuildOrganizationMO *)getStoredCommonBuildOrganizationMO:(NSString *)identity {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:commonBuildOrganizationMOName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identity == %@", identity]];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (results) {
        if ([results count] < 1)
            return nil;
        return [results objectAtIndex:0];
    }
    
    NSLog(@"Error fetching %@ objects: %@\n%@", commonBuildOrganizationMOName, [error localizedDescription], [error userInfo]);
    abort();
}

- (void)storeCommonBuildOrganizationId:(NSString *)identity name:(NSString *)name {
    UGCommonBuildOrganizationMO *mo = [self getStoredCommonBuildOrganizationMO:identity];
    if (mo != nil)
        [[self managedObjectContext] deleteObject:mo];

    mo = [NSEntityDescription insertNewObjectForEntityForName:commonBuildOrganizationMOName inManagedObjectContext:[self managedObjectContext]];
    [mo setIdentity:identity];
    [mo setName:name];

    [self saveInternal];
}

- (NSDictionary *)loadCommonBuildOrganizations {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:commonBuildOrganizationMOName];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (results) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        for (UGCommonBuildOrganizationMO *cbomo in results) {
            [result setObject:[cbomo name] forKey:[cbomo identity]];
        }
        return result;
    }
    
    NSLog(@"Error fetching %@ objects: %@\n%@", commonBuildOrganizationMOName, [error localizedDescription], [error userInfo]);
    abort();
}

@end
