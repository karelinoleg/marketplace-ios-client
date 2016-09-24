//
//  UGConstants.h
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UGLocalizedString(key) NSLocalizedString(key, nil)

#define STR_EMPTY(str) \
    (str == nil || [str length] == 0 || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)

#define UIColorFromRGB(rgb) \
    [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgb & 0x00FF00) >>  8))/255.0 \
                     blue:((float)((rgb & 0x0000FF) >>  0))/255.0 \
                    alpha:1.0]

#define COST(doubleValue) ([NSString stringWithFormat: UGLocalizedString(@"CostTemplate"), doubleValue])

@interface UGConstants : NSObject

extern NSString *const CLIENT_TYPE;

extern NSString *const DTO_CLASS_CATALOG_ITEM;
extern NSString *const DTO_CLASS_FOLDER_ITEM;
extern NSString *const DTO_CLASS_LOCATED_ITEM;
extern NSString *const DTO_CLASS_CITY;
extern NSString *const DTO_CLASS_PRODUCT;
extern NSString *const DTO_CLASS_ORGANIZATION;

extern int const WEB_SERVICE_API_VERSION;

extern NSString *const WEB_SERVICE_URL;
extern NSString *const WEB_SERVICE_URL_VERSION;
extern NSString *const WEB_SERVICE_URL_CATALOG;
extern NSString *const WEB_SERVICE_URL_IMAGE;
extern NSString *const WEB_SERVICE_URL_ORDER;
extern NSString *const WEB_SERVICE_URL_ORDER_ENTRIES;

extern NSString *const PREFS_DEVICE_TOKEN_KEY;

@end
