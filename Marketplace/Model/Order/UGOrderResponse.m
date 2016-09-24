//
//  UGOrderResponse.m
//  Marketplace
//
//  Created by Олег on 5/19/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrderResponse.h"
#import "UGProduct.h"

@implementation UGOrderResponse

@synthesize status;
@synthesize actualProducts;
@synthesize orderEntry;
@synthesize deliveryServicePhone;
@synthesize message;

- (instancetype) initWithParameters:(NSDictionary*)params {
    self = [super init];
    if (self) {
        [self setStatus:[params objectForKey:@"status"]];

        NSArray *productsJson = [params objectForKey:@"actualProducts"];
        NSMutableArray *productsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *product in productsJson)
            [productsArray addObject:[[UGProduct alloc] initWithParameters:product]];
        [self setActualProducts:productsArray];
        
        [self setOrderEntry:[params objectForKey:@"orderEntry"]];
        [self setDeliveryServicePhone:[params objectForKey:@"deliveryServicePhone"]];
        [self setMessage:[params objectForKey:@"message"]];
    }
    return self;
}

@end
