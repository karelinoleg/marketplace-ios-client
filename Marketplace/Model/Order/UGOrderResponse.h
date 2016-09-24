//
//  UGOrderResponse.h
//  Marketplace
//
//  Created by Олег on 5/19/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGOrderEntry.h"

@interface UGOrderResponse : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *actualProducts;
@property (nonatomic, strong) UGOrderEntry *orderEntry;
@property (nonatomic, strong) NSString *deliveryServicePhone;
@property (nonatomic, strong) NSString *message;

- (instancetype) initWithParameters:(NSDictionary*)params;

@end
