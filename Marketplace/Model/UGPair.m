//
//  UGPair.m
//  Marketplace
//
//  Created by Олег on 5/20/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGPair.h"

@implementation UGPair

@synthesize key;
@synthesize value;

- (instancetype) initWithKey:(NSObject *)vKey value:(NSObject *)vValue {
    self = [super init];
    if (self) {
        [self setKey:vKey];
        [self setValue:vValue];
    }
    return self;
}

@end
