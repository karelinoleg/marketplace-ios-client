//
//  UGDeliveryOptionMO.h
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UGDeliveryOptionMO : NSManagedObject

@property (nonatomic, strong) NSString *organizationId;
@property (nonatomic, strong) NSString *deliveryOption;
@property (nonatomic, strong) NSString *pickupPointId;

@end
