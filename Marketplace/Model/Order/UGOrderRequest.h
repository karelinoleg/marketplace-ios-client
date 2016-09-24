//
//  UGOrderRequest.h
//  Marketplace
//
//  Created by Олег on 4/22/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGOrderRequest : NSObject

@property (nonatomic, strong) NSString *organizationId;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSDictionary *items;
@property (nonatomic) double sum;
@property (nonatomic, strong) NSString *paymentType;
@property (nonatomic, strong) NSString *deliveryOption;
@property (nonatomic, strong) NSString *deliveryAddress;
@property (nonatomic, strong) NSString *pickupPointId;
@property (nonatomic, strong) NSString *gcmRecipientId;
@property (nonatomic, strong) NSString *clientType;
@property (nonatomic, strong) NSString *clientPackageName;

+ (instancetype) orderRequestForOrganization:(NSString *)organizationId deviceId:(NSString *)deviceId phone:(NSString *)phone customerName:(NSString *)customerName comment:(NSString *)comment orderItems:(NSDictionary *)items sum:(double)sum paymentType:(NSString *)paymentType deliveryOption:(NSString *)deliveryOption deliveryAddress:(NSString *)deliveryAddress pickupPointId:(NSString *)pickupPointId gcmRecipientId:(NSString *)gcmRecipientId clientType:(NSString *)clientType clientPackageName:(NSString *)clientPackageName;

+ (NSDictionary *)orderItemsDictionaryFromCartItemsArray:(NSArray *)cartItems;

- (NSData *)toJson;

@end
