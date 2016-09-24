//
//  UGOrganization.h
//  Marketplace
//
//  Created by Олег on 3/25/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGLocatedItem.h"

@interface UGOrganization : UGLocatedItem

@property (nonatomic) double minOrderCost;
@property (nonatomic) double shippingPrice;
@property (nonatomic, strong) NSString *shippingInfo;
@property (nonatomic, strong) NSString *businessHours;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *webSite;
@property (nonatomic, strong) NSString *orderConfirmationDeliveryTemplate;
@property (nonatomic, strong) NSString *orderConfirmationPickupTemplate;
@property (nonatomic) BOOL deliversToCustomer;
@property (nonatomic) BOOL pickupsAtPoints;
@property (nonatomic, strong) NSArray *pickupPoints;

@property (nonatomic) BOOL paymentTypeCashSupport;
@property (nonatomic) BOOL paymentTypeOnlineSupport;

- (int)getPickupPointIndexForIdentity:(NSString *)identity;

@end
