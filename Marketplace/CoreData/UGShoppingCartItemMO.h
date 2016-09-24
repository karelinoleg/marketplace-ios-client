//
//  UGShoppingCartItemMO.h
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <CoreData/CoreData.h>
@class UGCatalogItemMO;

@interface UGShoppingCartItemMO : NSManagedObject

@property (nonatomic, strong) UGCatalogItemMO *product;
@property (nonatomic, strong) NSNumber *count;

@end
