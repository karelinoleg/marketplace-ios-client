//
//  UGCartRefreshDelegate.h
//  Marketplace
//
//  Created by Oleg Karelin on 9/7/16.
//  Copyright © 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UGCartRefreshDelegate <NSObject>

@required
- (void)cartTotalsRefresh:(NSInteger)section;

- (NSInteger)getSectionForCell:(UITableViewCell *)cell;

@end

