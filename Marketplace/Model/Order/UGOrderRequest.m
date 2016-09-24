//
//  UGOrderRequest.m
//  Marketplace
//
//  Created by Олег on 4/22/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrderRequest.h"
#import "UGCartItem.h"

@implementation UGOrderRequest

@synthesize organizationId;
@synthesize deviceId;
@synthesize phone;
@synthesize customerName;
@synthesize comment;
@synthesize items;
@synthesize sum;
@synthesize paymentType;
@synthesize deliveryOption;
@synthesize deliveryAddress;
@synthesize pickupPointId;
@synthesize gcmRecipientId;
@synthesize clientType;
@synthesize clientPackageName;

+ (instancetype) orderRequestForOrganization:(NSString *)organizationId deviceId:(NSString *)deviceId phone:(NSString *)phone customerName:(NSString *)customerName comment:(NSString *)comment orderItems:(NSDictionary *)items sum:(double)sum paymentType:(NSString *)paymentType deliveryOption:(NSString *)deliveryOption deliveryAddress:(NSString *)deliveryAddress pickupPointId:(NSString *)pickupPointId gcmRecipientId:(NSString *)gcmRecipientId clientType:(NSString *)clientType clientPackageName:(NSString *)clientPackageName {
    UGOrderRequest *request = [[UGOrderRequest alloc] init];
    [request setOrganizationId:organizationId];
    [request setDeviceId:deviceId];
    [request setPhone:phone];
    [request setCustomerName:customerName];
    [request setComment:comment];
    [request setItems:items];
    [request setSum:sum];
    [request setPaymentType:paymentType];
    [request setDeliveryOption:deliveryOption];
    [request setDeliveryAddress:deliveryAddress];
    [request setPickupPointId:pickupPointId];
    [request setGcmRecipientId:gcmRecipientId];
    [request setClientType:clientType];
    [request setClientPackageName:clientPackageName];

    return request;
}

+ (NSDictionary *)orderItemsDictionaryFromCartItemsArray:(NSArray *)cartItems {
    NSMutableDictionary *itemsDict = [[NSMutableDictionary alloc] init];
    for (UGCartItem *item in cartItems)
        [itemsDict setObject:[NSNumber numberWithInt:[item count]] forKey:[[item product] identity]];
    return itemsDict;
}

- (NSData *)toJson {
    NSError *error = nil;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:organizationId forKey:@"organizationId"];
    [dict setObject:deviceId forKey:@"deviceId"];
    [dict setObject:phone forKey:@"phone"];
    if (customerName != nil)
        [dict setObject:customerName forKey:@"customerName"];
    if (comment != nil)
        [dict setObject:comment forKey: @"comment"];
    [dict setObject:items forKey:@"items"];
    [dict setObject:[NSNumber numberWithDouble:sum] forKey:@"sum"];
    [dict setObject:paymentType forKey:@"paymentType"];
    [dict setObject:deliveryOption forKey:@"deliveryOption"];
    if (deliveryAddress != nil)
        [dict setObject:deliveryAddress forKey:@"deliveryAddress"];
    if (pickupPointId != nil)
        [dict setObject:pickupPointId forKey:@"pickupPointId"];
    if (gcmRecipientId != nil)
        [dict setObject:gcmRecipientId forKey:@"gcmRecipientId"];
    [dict setObject:clientType forKey:@"clientType"];
    [dict setObject:clientPackageName forKey:@"clientPackageName"];
    
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
}

@end
