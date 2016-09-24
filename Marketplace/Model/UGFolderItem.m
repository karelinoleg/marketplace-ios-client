//
//  UGFolder.m
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGFolderItem.h"

@implementation UGFolderItem

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:DTO_CLASS_FOLDER_ITEM forKey:DTO_CLASS_TAG];
    return dict;
}

@end
