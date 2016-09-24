//
//  NSObject+UGOrderEntryCell.h
//  Marketplace
//
//  Created by Oleg Karelin on 9/7/16.
//  Copyright © 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UGOrderEntryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderSumLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderTimeLabel;

@end
