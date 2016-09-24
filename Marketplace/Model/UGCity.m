//
//  UGCity.m
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGCity.h"

@implementation UGCity

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:DTO_CLASS_CITY forKey:DTO_CLASS_TAG];
    return dict;
}

@end
