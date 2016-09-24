//
//  UGOrderEntry.h
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGOrderEntry : NSObject

@property (nonatomic, strong) NSString *orderIdentity;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *paymentStatus;

@property (nonatomic, strong) NSString *organizationId;
@property (nonatomic) long shopId;
@property (nonatomic) long scid;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *customerName;

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic) double sum;

@property (nonatomic, strong) NSString *deliveryOption;
@property (nonatomic, strong) NSString *deliveryAddress;
@property (nonatomic, strong) NSString *pickupPointId;
@property (nonatomic, strong) NSString *pickupPointAddress;

@property (nonatomic, strong) NSDate *orderTime;
@property (nonatomic, strong) NSDate *endTime;

- (instancetype) initWithParameters:(NSDictionary*)params;

@end
