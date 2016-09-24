//
//  UGOrderDetailsViewControlllerViewController.h
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGReloadable.h"

@interface UGOrderDetailsViewController : UIViewController<UGReloadable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UITableView *itemsTable;

@property (nonatomic, strong) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *customerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *customerPhoneLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderCommentLabel;
@property (nonatomic, strong) IBOutlet UILabel *deliveryAddressLabel;
@property (nonatomic, strong) IBOutlet UILabel *deliveryAddressCaptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *orderTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, strong) NSString *orderIdentity;

@end
