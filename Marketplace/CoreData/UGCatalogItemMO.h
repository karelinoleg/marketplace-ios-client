//
//  UGCatalogItemMO.h
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <CoreData/CoreData.h>
@class UGShoppingCartItemMO;

@interface UGCatalogItemMO : NSManagedObject

@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *jsonData;
@property (nonatomic, strong) UGShoppingCartItemMO *shoppingCartItem;

@end
