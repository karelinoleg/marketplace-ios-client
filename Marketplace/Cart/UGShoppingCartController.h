//
//  UGShoppingCartController.h
//  Marketplace
//
//  Created by Олег on 5/3/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGReloadable.h"
#import "UGCartRefreshDelegate.h"

@interface UGShoppingCartController : UITableViewController <UGReloadable, UGCartRefreshDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *itemsTable;

@end
