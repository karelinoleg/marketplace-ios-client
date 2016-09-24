//
//  UGLocatedItem.m
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGLocatedItem.h"

@implementation UGLocatedItem

@synthesize longitude;
@synthesize latitude;
@synthesize address;

- (instancetype) initWithParameters:(NSDictionary *)params {
    self = [super initWithParameters:params];
    if (self) {
        [self setLongitude:[[params objectForKey:@"longitude"] doubleValue]];
        [self setLatitude:[[params objectForKey:@"latitude"] doubleValue]];
        [self setAddress:[params objectForKey:@"address"]];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    UGLocatedItem *copy = [super copyWithZone:zone];
    [copy setLongitude:[self longitude]];
    [copy setLatitude:[self latitude]];
    [copy setAddress:[self address]];
    return copy;
}

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dict = [super toNSDictionary];
    [dict setObject:DTO_CLASS_LOCATED_ITEM forKey:DTO_CLASS_TAG];
    if (longitude > 0)
        [dict setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    if (latitude > 0)
        [dict setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    if (address != nil)
        [dict setObject:address forKey:@"address"];
    
    return dict;
}

@end
