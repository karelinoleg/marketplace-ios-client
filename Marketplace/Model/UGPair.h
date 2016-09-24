//
//  UGPair.h
//  Marketplace
//
//  Created by Олег on 5/20/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGPair : NSObject

@property (nonatomic, strong) NSObject *key;
@property (nonatomic, strong) NSObject *value;

- (instancetype) initWithKey:(NSObject *)key value:(NSObject *)value;

@end
