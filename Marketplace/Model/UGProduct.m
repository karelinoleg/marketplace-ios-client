//
//  UGProduct.m
//  Marketplace
//
//  Created by Олег on 3/7/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGProduct.h"

@implementation UGProduct

@synthesize price;
@synthesize discountPrice;
@synthesize specialOffer;

- (instancetype) initWithParameters:(NSDictionary *)params {
    self = [super initWithParameters:params];
    if (self) {
        [self setPrice:[params objectForKey:@"price"]];
        [self setDiscountPrice:[params objectForKey:@"discountPrice"]];
        [self setSpecialOffer:[[params objectForKey:@"specialOffer"] boolValue]];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    UGProduct *copy = [super copyWithZone:zone];
    [copy setPrice:[self price]];
    [copy setDiscountPrice:[self discountPrice]];
    [copy setSpecialOffer:[self specialOffer]];
    return copy;
}

- (double)getEffectivePrice {
    NSNumber *effectivePrice = discountPrice == nil ? price : discountPrice;
    return [effectivePrice doubleValue];
}

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dict = [super toNSDictionary];
    [dict setObject:DTO_CLASS_PRODUCT forKey:DTO_CLASS_TAG];
    if (price != nil)
        [dict setObject:price forKey:@"price"];
    if (discountPrice != nil)
        [dict setObject:discountPrice forKey:@"discountPrice"];
    [dict setObject:BOOLEAN_STRING(specialOffer) forKey:@"specialOffer"];
    
    return dict;
}

@end
