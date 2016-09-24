//
//  UGOrderItemCell.h
//  Marketplace
//
//  Created by Олег on 4/28/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGOrderItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *sumLabel;

@end
