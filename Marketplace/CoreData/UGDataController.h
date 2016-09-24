//
//  UGDataController.h
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGCatalogItem.h"
#import "UGDeliveryOptionMO.h"

@interface UGDataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;

- (void)storeCatalogItemForIdentity:(NSString*)identity version:(long)version jsonData:(NSString*)jsonData;

- (void)removeCatalogItemForIdentity:(NSString*)identity;

- (UGCatalogItem *)loadStoredCatalogItem:(NSString*)identity;

- (void)storeShoppingCartItemForIdentity:(NSString*)productIdentity version:(long)version productJsonData:(NSString*)productJsonData count:(int)count;

- (void)removeShoppingCartItemForIdentity:(NSString*)identity;

- (NSArray *)loadStoredShoppingCartItems;

- (void)storeDeliveryOption:(NSString *)deliveryOption pickupPointId:(NSString *)pickupPointId forOrganizationId:(NSString *)organizationId;

- (UGDeliveryOptionMO *)loadDeliveryOptionForOrganizationId:(NSString *)organizationId;

- (void)storeDeliveryDetail:(NSString *)detail forDetailType:(NSString *)detailType;

- (NSString *)loadDeliveryDetailForDetailType:(NSString *)detailType;

- (void)storeCommonBuildOrganizationId:(NSString*)identity name:(NSString *)name;

- (NSDictionary *)loadCommonBuildOrganizations;

@end
