//
//  UGOrderConfirmedController.h
//  Marketplace
//
//  Created by Олег on 5/20/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGReloadable.h"
#import "UGOrderRequest.h"

@interface UGOrderRejectedController : UIViewController<UGReloadable, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet UITableView *itemsTable;

@property (nonatomic, strong) UGOrderRequest *orderRequest;
@property (nonatomic, strong) NSString *organizationName;
@property (nonatomic, strong) NSArray *oldProducts;
@property (nonatomic, strong) NSArray *actualProducts;

+ (NSArray *)productsFromCartItemsArray:(NSArray *)orderItems;

+ (void) sendOrderRequest:(UGOrderRequest *)sendingRequest organizationName:(NSString *)organizationName orderedProductsInfo:(NSArray *)orderedProducts fromController:(UIViewController *)viewController loadingIndicator:(UIActivityIndicatorView *) loadingIndicator contentView:(UIView *) contentView;

@end
