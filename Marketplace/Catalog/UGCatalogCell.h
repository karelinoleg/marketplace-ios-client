//
//  UGCatalogCell.h
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGProduct.h"

@interface UGCatalogCell : UITableViewCell

@property (nonatomic, strong) UGProduct *product;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *folderNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *folderDescriptionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic, strong) IBOutlet UILabel *oldPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIButton *toCartButton;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;

- (void)setCount:(int)count;

@end
