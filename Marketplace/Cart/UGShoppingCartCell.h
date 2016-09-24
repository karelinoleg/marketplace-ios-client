//
//  UGShoppingCartCell.h
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGProduct.h"
#import "UGCartRefreshDelegate.h"

@interface UGShoppingCartCell : UITableViewCell

@property (nonatomic, assign) id<UGCartRefreshDelegate> cartRefreshDelegate;

@property (nonatomic, strong) UGProduct *product;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *sumLabel;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;

- (void)setCount:(int)count;

@end
