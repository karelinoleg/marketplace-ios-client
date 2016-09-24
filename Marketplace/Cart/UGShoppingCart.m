//
//  UGShoppingCart.m
//  Marketplace
//
//  Created by Олег on 4/22/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGShoppingCart.h"
#import "UGAppDelegate.h"
#import "UGCartItem.h"

@implementation UGShoppingCart {

    NSMutableDictionary *products;
    NSMutableDictionary *order;
}

+ (id)instance {
    static UGShoppingCart *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (instancetype)init {
    products = [[NSMutableDictionary alloc] init];
    order = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)increaseProductCount:(UGProduct *)product {
    NSString *productId = [product identity];
    int oldCount = [[order objectForKey:productId] intValue];
    [self setProduct:product count:(oldCount + 1)];
}

- (void)decreaseProductCount:(UGProduct *)product {
    NSString *productId = [product identity];
    int oldCount = [[order objectForKey:productId] intValue];
    if (oldCount > 0)
        [self setProduct:product count:(oldCount - 1)];
}

- (void)setProduct:(UGProduct *)product count:(int)count {
    NSString *productId = [product identity];
    if (count == 0)
        [self removeProduct:product];
    else {
        [products setObject:product forKey:productId];
        NSData *data = [product toJsonData];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[UGAppDelegate dataController] storeShoppingCartItemForIdentity:productId version:[product version] productJsonData:jsonString count:count];

        [order setObject:[NSNumber numberWithInt:count] forKey:productId];
    }
}

- (int) getProductCount:(NSString *)productId {
    return [[order objectForKey:productId] intValue];
}

- (void)clearCartForOrganizationId:(NSString *)organizationId {
    for (UGProduct *product in [products allValues]) {
        if ([organizationId isEqualToString:[product organizationId]])
            [self removeProduct:product];
    }
}

- (NSDictionary *)getOrdersForOrganizations {
    return [self getOrdersFilteredByOrganizationId:nil];
}

- (NSDictionary *)getOrdersFilteredByOrganizationId:(NSString *)organizationId {
    // cart key is organizationId
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSString *productId in [order keyEnumerator]) {
        UGProduct *product = [products objectForKey:productId];
        NSString *productOrgId = [product organizationId];
        
        if (organizationId != nil && ![organizationId isEqualToString:productOrgId])
            continue;
        
        UGCartItem *cartItem = [[UGCartItem alloc] init];
        [cartItem setProduct:product];
        [cartItem setCount:[[order objectForKey:productId] intValue]];

        NSMutableArray *cart = [result objectForKey:productOrgId];
        if (cart == nil) {
            cart = [[NSMutableArray alloc] init];
            [result setObject:cart forKey:productOrgId];
        }
        [cart addObject:cartItem];
    }
    return result;
}

- (NSArray *)getOrderForOrganizationId:(NSString *)organizationId {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *productId in [order keyEnumerator]) {
        UGProduct *product = [products objectForKey:productId];
        if ([organizationId isEqualToString:[product organizationId]]) {
            UGCartItem *cartItem = [[UGCartItem alloc] init];
            [cartItem setProduct:product];
            [cartItem setCount:[[order objectForKey:productId] intValue]];
            [result addObject:cartItem];
        }
    }
    return result;
}

- (double)getSumForOrganizationId:(NSString *)organizationId {
    double result = 0;
    for (NSString *productId in [order keyEnumerator]) {
        UGProduct *product = [products objectForKey:productId];
        if ([organizationId isEqualToString:[product organizationId]])
             result += [product getEffectivePrice] * [[order objectForKey:productId] intValue];
    }
    return result;
}

- (BOOL)isEmptyForOrganizationId:(NSString *)organizationId {
    for (NSString *productId in [order keyEnumerator]) {
        UGProduct *product = [products objectForKey:productId];
        if ([organizationId isEqualToString:[product organizationId]])
            return NO;
    }
    return YES;
}

- (void)removeProduct:(UGProduct *)product {
    NSString *productId = [product identity];
    [order removeObjectForKey:productId];
    [products removeObjectForKey:productId];
    [[UGAppDelegate dataController] removeShoppingCartItemForIdentity:productId];
}

- (void)loadStoredCartContent:(NSArray *)cartItems {
    for (UGCartItem *cartItem in cartItems) {
        UGProduct *product = [cartItem product];
        NSString *productId = [product identity];
        [products setObject:product forKey:productId];
        [order setObject:[NSNumber numberWithInt:[cartItem count]] forKey:productId];
    }
}

@end
