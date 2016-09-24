//
//  OrderItem.h
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGOrderItem : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic) double cost;
@property (nonatomic) int count;

- (instancetype) initWithParameters:(NSDictionary*)params;

@end
