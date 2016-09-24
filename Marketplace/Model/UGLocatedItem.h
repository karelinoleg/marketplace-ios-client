//
//  UGLocatedItem.h
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGFolderItem.h"

@interface UGLocatedItem : UGFolderItem

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic, strong) NSString *address;

@end
