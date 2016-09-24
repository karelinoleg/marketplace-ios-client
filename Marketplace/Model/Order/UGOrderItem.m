//
//  OrderItem.m
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrderItem.h"

@implementation UGOrderItem

@synthesize productId;
@synthesize productName;
@synthesize cost;
@synthesize count;

- (instancetype) initWithParameters:(NSDictionary*)params {
    self = [super init];
    if (self) {
        [self setProductId:[params objectForKey:@"productId"]];
        [self setProductName:[params objectForKey:@"productName"]];
        [self setCost:[[params objectForKey:@"cost"] doubleValue]];
        [self setCount:[[params objectForKey:@"count"] intValue]];
    }
    return self;
}

@end
