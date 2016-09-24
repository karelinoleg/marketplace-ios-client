//
//  UGCatalogItem.h
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#define DTO_CLASS_TAG (@"@class")

#define BOOLEAN_STRING(booleanValue) (booleanValue ? @"true" : @"false")

#import <Foundation/Foundation.h>
#import "UGConstants.h"

@interface UGCatalogItem : NSObject <NSCopying>

@property (nonatomic, strong) NSString *identity;
@property (nonatomic) long version;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;;
@property (nonatomic, strong) NSString *smallImageHash;
@property (nonatomic, strong) NSString *largeImageHash;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *organizationId;

+ (instancetype) createByParameters:(NSDictionary*)params;

- (instancetype) initWithParameters:(NSDictionary*)params;

- (NSMutableDictionary *)toNSDictionary;

- (NSData *)toJsonData;

@end
