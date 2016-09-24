//
//  UGFirstViewController.h
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGReloadable.h"

@interface UGCatalogController : UIViewController<UGReloadable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *catalogTable;

@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *parentName;
@property (nonatomic, strong) NSArray *catalogItems;

@end
