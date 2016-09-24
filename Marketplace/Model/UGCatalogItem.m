//
//  UGCatalogItem.m
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGCatalogItem.h"
#import "UGFolderItem.h"
#import "UGLocatedItem.h"
#import "UGCity.h"
#import "UGProduct.h"
#import "UGOrganization.h"

@implementation UGCatalogItem

@synthesize identity;
@synthesize version;
@synthesize name;
@synthesize description;
@synthesize smallImageHash;
@synthesize largeImageHash;
@synthesize comment;
@synthesize organizationId;

+ (instancetype) createByParameters:(NSDictionary*)params {
    NSString *className = [params objectForKey:DTO_CLASS_TAG];
    UGCatalogItem *result;
    if ([DTO_CLASS_PRODUCT isEqualToString:className]) {
        result = [[UGProduct alloc] initWithParameters:params];
    } else if ([DTO_CLASS_ORGANIZATION isEqualToString:className]) {
        result = [[UGOrganization alloc] initWithParameters:params];
    } else if ([DTO_CLASS_FOLDER_ITEM isEqualToString:className]) {
        result = [[UGFolderItem alloc] initWithParameters:params];
    } else if ([DTO_CLASS_CITY isEqualToString:className]) {
        result = [[UGCity alloc] initWithParameters:params];
    } else if ([DTO_CLASS_LOCATED_ITEM isEqualToString:className]) {
        result = [[UGLocatedItem alloc] initWithParameters:params];
    } else {
        @throw [NSException exceptionWithName:@"CatalogItem initialization"
                                       reason: [NSString stringWithFormat: @"Unknown DTO class: %@", className]
                                     userInfo:nil];
    }
    return result;
}

- (instancetype) initWithParameters:(NSDictionary*)params {
    self = [super init];
    if (self) {
        [self setIdentity:[params objectForKey:@"identity"]];
        [self setVersion:[[params objectForKey:@"version"] longValue]];
        [self setName:[params objectForKey:@"name"]];
        [self setDescription:[params objectForKey:@"description"]];
        [self setSmallImageHash:[params objectForKey:@"smallImageHash"]];
        [self setLargeImageHash:[params objectForKey:@"largeImageHash"]];
        [self setComment:[params objectForKey:@"comment"]];
        [self setOrganizationId:[params objectForKey:@"organizationId"]];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    UGCatalogItem *copy = [[[self class] allocWithZone:zone] init];
    [copy setIdentity:[self identity]];
    [copy setVersion:[self version]];
    [copy setName:[self name]];
    [copy setDescription:[self description]];
    [copy setSmallImageHash:[self smallImageHash]];
    [copy setLargeImageHash:[self largeImageHash]];
    [copy setComment:[self comment]];
    [copy setOrganizationId:[self organizationId]];
    
    return copy;
}

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:DTO_CLASS_CATALOG_ITEM forKey:DTO_CLASS_TAG];
    [dict setObject:identity forKey:@"identity"];
    [dict setObject:[NSNumber numberWithLong:version] forKey:@"version"];
    [dict setObject:name forKey:@"name"];
    if (description != nil)
        [dict setObject:description forKey:@"description"];
    if (smallImageHash != nil)
        [dict setObject:smallImageHash forKey:@"smallImageHash"];
    if (largeImageHash != nil)
        [dict setObject:largeImageHash forKey:@"largeImageHash"];
    if (comment != nil)
        [dict setObject:comment forKey:@"comment"];
    if (organizationId != nil)
        [dict setObject:organizationId forKey:@"organizationId"];
    return dict;
}

- (NSData *)toJsonData {
    NSError *error = nil;
    return [NSJSONSerialization dataWithJSONObject:[self toNSDictionary] options:kNilOptions error:&error];
}

@end
