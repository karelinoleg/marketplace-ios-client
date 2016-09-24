//
//  UGSecondViewController.h
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGReloadable.h"

@interface UGOrdersListController : UIViewController<UGReloadable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *ordersTable;
@property (nonatomic, strong) IBOutlet UIScrollView *toolbarScroll;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *orders;

- (void)setSelectedOrganizationId:(NSString *)newSelectedOrgId;

@end
