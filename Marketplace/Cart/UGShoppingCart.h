//
//  UGShoppingCart.h
//  Marketplace
//
//  Created by Олег on 4/22/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGProduct.h"

@interface UGShoppingCart : NSObject

+ (id)instance;

- (void)increaseProductCount:(UGProduct *)product;

- (void)decreaseProductCount:(UGProduct *)product;

- (void)setProduct:(UGProduct *)product count:(int)count;

- (int)getProductCount:(NSString *)productId;

- (void)clearCartForOrganizationId:(NSString *)organizationId;

- (NSDictionary *)getOrdersForOrganizations;

- (NSDictionary *)getOrdersFilteredByOrganizationId:(NSString *)organizationId;

- (NSArray *)getOrderForOrganizationId:(NSString *)organizationId;

- (double)getSumForOrganizationId:(NSString *)organizationId;

- (BOOL)isEmptyForOrganizationId:(NSString *)organizationId;

- (void)removeProduct:(UGProduct *)product;

- (void)loadStoredCartContent:(NSArray *)cartItems;

@end
