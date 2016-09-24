//
//  UGDeliveryDetailMO.h
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UGDeliveryDetailMO : NSManagedObject

@property (nonatomic, strong) NSString *detailType;
@property (nonatomic, strong) NSString *detail;

@end
