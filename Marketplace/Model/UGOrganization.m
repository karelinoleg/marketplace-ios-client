//
//  UGOrganization.m
//  Marketplace
//
//  Created by Олег on 3/25/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrganization.h"

@implementation UGOrganization

@synthesize minOrderCost;
@synthesize shippingPrice;
@synthesize shippingInfo;
@synthesize businessHours;
@synthesize phoneNumber;
@synthesize email;
@synthesize webSite;
@synthesize orderConfirmationDeliveryTemplate;
@synthesize orderConfirmationPickupTemplate;
@synthesize deliversToCustomer;
@synthesize pickupsAtPoints;
@synthesize pickupPoints;

@synthesize paymentTypeCashSupport;
@synthesize paymentTypeOnlineSupport;

- (instancetype) initWithParameters:(NSDictionary *)params {
    self = [super initWithParameters:params];
    if (self) {
        [self setMinOrderCost:[[params objectForKey:@"minOrderCost"] doubleValue]];
        [self setShippingPrice:[[params objectForKey:@"shippingPrice"] doubleValue]];
        [self setShippingInfo:[params objectForKey:@"shippingInfo"]];
        [self setBusinessHours:[params objectForKey:@"businessHours"]];
        [self setPhoneNumber:[params objectForKey:@"phoneNumber"]];
        [self setEmail:[params objectForKey:@"email"]];
        [self setWebSite:[params objectForKey:@"webSite"]];
        [self setOrderConfirmationDeliveryTemplate:[params objectForKey:@"orderConfirmationDeliveryTemplate"]];
        [self setOrderConfirmationPickupTemplate:[params objectForKey:@"orderConfirmationPickupTemplate"]];
        [self setDeliversToCustomer:[[params objectForKey:@"deliversToCustomer"] boolValue]];
        [self setPickupsAtPoints:[[params objectForKey:@"pickupsAtPoints"] boolValue]];

        NSArray *pickupPointsJson = [params objectForKey:@"pickupPoints"];
        NSMutableArray *pickupPointsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *point in pickupPointsJson)
            [pickupPointsArray addObject:[[UGLocatedItem alloc] initWithParameters:point]];
        [self setPickupPoints:pickupPointsArray];

        [self setPaymentTypeCashSupport:[[params objectForKey:@"paymentTypeCashSupport"] boolValue]];
        [self setPaymentTypeOnlineSupport:[[params objectForKey:@"paymentTypeOnlineSupport"] boolValue]];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    UGOrganization *copy = [super copyWithZone:zone];
    [copy setMinOrderCost:[self minOrderCost]];
    [copy setShippingPrice:[self shippingPrice]];
    [copy setShippingInfo:[self shippingInfo]];
    [copy setBusinessHours:[self businessHours]];
    [copy setPhoneNumber:[self phoneNumber]];
    [copy setEmail:[self email]];
    [copy setWebSite:[self webSite]];
    [copy setOrderConfirmationDeliveryTemplate:[self orderConfirmationDeliveryTemplate]];
    [copy setOrderConfirmationPickupTemplate:[self orderConfirmationPickupTemplate]];
    [copy setDeliversToCustomer:[self deliversToCustomer]];
    [copy setPickupsAtPoints:[self pickupsAtPoints]];
    [copy setPickupPoints:[self pickupPoints]];
    [copy setPaymentTypeCashSupport:[self paymentTypeCashSupport]];
    [copy setPaymentTypeOnlineSupport:[self paymentTypeOnlineSupport]];
    return copy;
}

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dict = [super toNSDictionary];
    [dict setObject:DTO_CLASS_ORGANIZATION forKey:DTO_CLASS_TAG];
    if (minOrderCost > 0)
        [dict setObject:[NSNumber numberWithDouble:minOrderCost] forKey:@"minOrderCost"];
    if (shippingPrice > 0)
        [dict setObject:[NSNumber numberWithDouble:shippingPrice] forKey:@"shippingPrice"];
    if (shippingInfo != nil)
        [dict setObject:shippingInfo forKey:@"shippingInfo"];
    if (businessHours != nil)
        [dict setObject:businessHours forKey:@"businessHours"];
    if (phoneNumber != nil)
        [dict setObject:phoneNumber forKey:@"phoneNumber"];
    if (email != nil)
        [dict setObject:email forKey:@"email"];
    if (webSite != nil)
        [dict setObject:webSite forKey:@"webSite"];
    if (orderConfirmationDeliveryTemplate != nil)
        [dict setObject:orderConfirmationDeliveryTemplate forKey:@"orderConfirmationDeliveryTemplate"];
    if (orderConfirmationPickupTemplate != nil)
        [dict setObject:orderConfirmationPickupTemplate forKey:@"orderConfirmationPickupTemplate"];
    [dict setObject:BOOLEAN_STRING(deliversToCustomer) forKey:@"deliversToCustomer"];
    [dict setObject:BOOLEAN_STRING(pickupsAtPoints) forKey:@"pickupsAtPoints"];
    if (pickupPoints != nil)
        [dict setObject:pickupPoints forKey:@"pickupPoints"];
    [dict setObject:BOOLEAN_STRING(paymentTypeCashSupport) forKey:@"paymentTypeCashSupport"];
    [dict setObject:BOOLEAN_STRING(paymentTypeOnlineSupport) forKey:@"paymentTypeOnlineSupport"];

    return dict;
}

- (int)getPickupPointIndexForIdentity:(NSString *)identity {
    for (int i=0; i<[pickupPoints count]; i++) {
        UGLocatedItem *pickupPoint = [pickupPoints objectAtIndex:i];
        if ([identity isEqualToString:[pickupPoint identity]])
            return i;
    }
    return -1;
}

@end
