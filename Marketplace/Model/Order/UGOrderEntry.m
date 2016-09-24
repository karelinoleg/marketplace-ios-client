//
//  UGOrderEntry.m
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrderEntry.h"
#import "UGOrderItem.h"

@implementation UGOrderEntry

@synthesize orderIdentity;
@synthesize orderNumber;
@synthesize orderStatus;
@synthesize paymentStatus;

@synthesize organizationId;
@synthesize shopId;
@synthesize scid;

@synthesize phone;
@synthesize customerName;

@synthesize comment;
@synthesize items;
@synthesize sum;

@synthesize deliveryOption;
@synthesize deliveryAddress;
@synthesize pickupPointId;
@synthesize pickupPointAddress;
@synthesize orderTime;
@synthesize endTime;

- (instancetype) initWithParameters:(NSDictionary *)params {
    self = [super init];
    if (self) {
        [self setOrderIdentity:[params objectForKey:@"orderIdentity"]];
        [self setOrderNumber:[params objectForKey:@"orderNumber"]];
        [self setOrderStatus:[params objectForKey:@"orderStatus"]];
        [self setPaymentStatus:[params objectForKey:@"paymentStatus"]];

        [self setOrganizationId:[params objectForKey:@"organizationId"]];
        [self setShopId:[[params objectForKey:@"shopId"] longValue]];
        [self setScid:[[params objectForKey:@"scid"] longValue]];

        [self setPhone:[params objectForKey:@"phone"]];
        [self setCustomerName:[params objectForKey:@"customerName"]];

        [self setComment:[params objectForKey:@"comment"]];

        NSArray *itemsJson = [params objectForKey:@"items"];
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *item in itemsJson)
            [itemsArray addObject:[[UGOrderItem alloc] initWithParameters:item]];
        [self setItems:itemsArray];
        
        [self setSum:[[params objectForKey:@"sum"] doubleValue]];

        [self setDeliveryOption:[params objectForKey:@"deliveryOption"]];
        [self setDeliveryAddress:[params objectForKey:@"deliveryAddress"]];
        [self setPickupPointId:[params objectForKey:@"pickupPointId"]];
        [self setPickupPointAddress:[params objectForKey:@"pickupPointAddress"]];
        long long orderTimeMillis = [[params objectForKey:@"orderTime"] longLongValue];
        [self setOrderTime:[NSDate dateWithTimeIntervalSince1970:orderTimeMillis/1000]];
        if ([params objectForKey:@"endTime"]) {
            long long endTimeMillis = [[params objectForKey:@"endTime"] longLongValue];
            [self setEndTime:[NSDate dateWithTimeIntervalSince1970:endTimeMillis/1000]];
        }
    }
    return self;
}

@end
