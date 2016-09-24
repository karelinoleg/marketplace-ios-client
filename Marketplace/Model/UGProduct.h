//
//  UGProduct.h
//  Marketplace
//
//  Created by Олег on 3/7/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGCatalogItem.h"

@interface UGProduct : UGCatalogItem

@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *discountPrice;
@property (nonatomic) BOOL specialOffer;

- (double)getEffectivePrice;

@end
