//
//  UGCartItem.h
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGProduct.h"

@interface UGCartItem : NSObject

@property (nonatomic, strong) UGProduct *product;
@property (nonatomic) int count;

@end
