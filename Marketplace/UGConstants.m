//
//  UGConstants.m
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGConstants.h"

@implementation UGConstants

NSString *const CLIENT_TYPE = @"IOS";

NSString *const DTO_CLASS_CATALOG_ITEM = @"com.u_grp.marketplace.api.dto.CatalogItem";
NSString *const DTO_CLASS_FOLDER_ITEM = @"com.u_grp.marketplace.api.dto.FolderItem";
NSString *const DTO_CLASS_LOCATED_ITEM = @"com.u_grp.marketplace.api.dto.LocatedItem";
NSString *const DTO_CLASS_CITY = @"com.u_grp.marketplace.api.dto.City";
NSString *const DTO_CLASS_PRODUCT = @"com.u_grp.marketplace.api.dto.Product";
NSString *const DTO_CLASS_ORGANIZATION = @"com.u_grp.marketplace.api.dto.Organization";

int const WEB_SERVICE_API_VERSION = 1;
NSString *const WEB_SERVICE_URL = @"http://192.168.0.101:8080/marketplaceweb/";
NSString *const WEB_SERVICE_URL_VERSION = @"version?applicationId=OrderClient";
NSString *const WEB_SERVICE_URL_CATALOG = @"catalog";
NSString *const WEB_SERVICE_URL_IMAGE = @"image";
NSString *const WEB_SERVICE_URL_ORDER = @"order";
NSString *const WEB_SERVICE_URL_ORDER_ENTRIES = @"order_entries";

NSString *const PREFS_DEVICE_TOKEN_KEY = @"MARKETPLACE_PREFERENCES";

@end
