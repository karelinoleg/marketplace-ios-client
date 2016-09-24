//
//  UGOrderConfirmedController.m
//  Marketplace
//
//  Created by Олег on 5/20/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrderRejectedController.h"
#import "UGSingleton.h"
#import "UGShoppingCart.h"
#import "UGActualProductCell.h"
#import "UGCartItem.h"
#import "UGOrderResponse.h"
#import "UGAppDelegate.h"

@implementation UGOrderRejectedController {

    UIBarButtonItem *reorderButton;
    NSDictionary *actualProductsMap;
}

@synthesize orderRequest;
@synthesize organizationName;
@synthesize oldProducts;
@synthesize actualProducts;

static NSString *rejectedViewIdentifier = @"OrderRejectedViewIdentifier";
static NSString *cellIdentifier = @"ActualProductCellIdentifier";
static UIColor *actualCostColor;
static UIColor *nonactualCostColor;
static UIColor *actualBackgroundColor;
static UIColor *nonactualBackgroundColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    actualCostColor = [[UGSingleton instance] colorGreen];
    nonactualCostColor = [UIColor whiteColor];
    actualBackgroundColor = [UIColor clearColor];
    nonactualBackgroundColor = [[UGSingleton instance] colorRed];
    
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (UGProduct *product in actualProducts)
        [map setObject:product forKey:[product identity]];
    actualProductsMap = map;
    
    for (UGProduct *oldProduct in oldProducts) {
        UGProduct *product = [actualProductsMap objectForKey:[oldProduct identity]];
        if (product == nil)
            [[UGShoppingCart instance] removeProduct:oldProduct];
        else
            [[UGShoppingCart instance] setProduct:product count:[[[orderRequest items] objectForKey:[product identity]] intValue]];
    }

    reorderButton = [[UIBarButtonItem alloc] initWithTitle:UGLocalizedString(@"Order") style:UIBarButtonItemStyleDone target:self action:@selector(toReorder:)];
    [[self navigationItem] setRightBarButtonItem:reorderButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload {
    [self cartViewRefresh];
}

- (void)cartViewRefresh {
    [reorderButton setEnabled:![[UGShoppingCart instance] isEmptyForOrganizationId:[orderRequest organizationId]]];
    
    [[[[self itemsTable] footerViewForSection:0] textLabel] setText:[self getFooterText]];
    [[[[self itemsTable] footerViewForSection:0] textLabel] sizeToFit];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [oldProducts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGActualProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UGProduct *oldProduct = [oldProducts objectAtIndex:[indexPath row]];
    UGProduct *actualProduct = [actualProductsMap objectForKey:[oldProduct identity]];
    if (actualProduct == nil) {
        // TODO
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[cell nameLabel] setText:[oldProduct name]];
        [[cell countLabel] setText:nil];
        [[cell priceLabel] setText:nil];
        [[cell sumLabel] setText:UGLocalizedString(@"NotAvailable")];
        [[cell nameLabel] setEnabled:NO];
        [[cell sumLabel] setEnabled:NO];
        return cell;
    }

    NSNumber *countNumber = [[orderRequest items] objectForKey:[oldProduct identity]];
    int count = [countNumber intValue];
    double price = [actualProduct getEffectivePrice];
    
    [[cell nameLabel] setEnabled:YES];
    [[cell sumLabel] setEnabled:YES];
    [[cell nameLabel] setText:[actualProduct name]];
    [[cell countLabel] setText:[NSString stringWithFormat:UGLocalizedString(@"%d pcs by"), count]];
    [[cell priceLabel] setText:COST(price)];
    [[cell sumLabel] setText:COST(price * count)];

    if ([oldProduct getEffectivePrice] == [actualProduct getEffectivePrice]) {
        [[cell priceLabel] setTextColor:actualCostColor];
        [[cell priceLabel] setBackgroundColor:actualBackgroundColor];
        [[cell sumLabel] setTextColor:actualCostColor];
        [[cell sumLabel] setBackgroundColor:actualBackgroundColor];
    } else {
        [[cell priceLabel] setTextColor:nonactualCostColor];
        [[cell priceLabel] setBackgroundColor:nonactualBackgroundColor];
        [[cell sumLabel] setTextColor:nonactualCostColor];
        [[cell sumLabel] setBackgroundColor:nonactualBackgroundColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGProduct *oldProduct = [oldProducts objectAtIndex:[indexPath row]];
    UGProduct *actualProduct = [actualProductsMap objectForKey:[oldProduct identity]];
    if (actualProduct == nil)
        return;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // TODO
    if ([cell accessoryType] == UITableViewCellAccessoryNone) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSNumber *count = [[orderRequest items] objectForKey:[actualProduct identity]];
        [[UGShoppingCart instance] setProduct:actualProduct count:[count intValue]];
    } else if ([cell accessoryType] == UITableViewCellAccessoryCheckmark) {
             [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[UGShoppingCart instance] removeProduct:actualProduct];
    }
    
    [self cartViewRefresh];
}

- (NSString *)getFooterText{
    UGShoppingCart *cart = [UGShoppingCart instance];
    return [NSString stringWithFormat:UGLocalizedString(@"Sum: %@"), COST([cart getSumForOrganizationId:[orderRequest organizationId]])];
}
     
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self getFooterText];
}

- (IBAction)toReorder:(id)sender {
    UGShoppingCart *cart = [UGShoppingCart instance];
    NSArray *orderItems = [cart getOrderForOrganizationId:[orderRequest organizationId]];
    [orderRequest setItems:[UGOrderRequest orderItemsDictionaryFromCartItemsArray:orderItems]];
    [orderRequest setSum:[cart getSumForOrganizationId:[orderRequest organizationId]]];
    
    [UGOrderRejectedController sendOrderRequest:orderRequest organizationName:[self organizationName] orderedProductsInfo:[UGOrderRejectedController productsFromCartItemsArray:orderItems] fromController:self loadingIndicator:[self indicatorView] contentView:[self contentView]];
}

+ (NSArray *)productsFromCartItemsArray:(NSArray *)orderItems {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (UGCartItem *cartItem in orderItems)
        [result addObject:[cartItem product]];
    return result;
}

+ (void) sendOrderRequest:(UGOrderRequest *)sendingRequest organizationName:(NSString *)organizationName orderedProductsInfo:(NSArray *)orderedProducts fromController:(UIViewController *)viewController loadingIndicator:(UIActivityIndicatorView *) loadingIndicator contentView:(UIView *) contentView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [contentView setHidden:YES];
    [loadingIndicator startAnimating];

    [UGSingleton sendPostRequest:[UGSingleton getURLForMakeOrder]
                        jsonData:[sendingRequest toJson]
               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                   
                   if (data.length > 0 && connectionError == nil)
                   {
                       NSError *err = nil;
                       NSDictionary *responseParams = [NSJSONSerialization JSONObjectWithData:data
                                                                                      options:kNilOptions
                                                                                        error:&err];
                       UGOrderResponse *response = [[UGOrderResponse alloc] initWithParameters:responseParams];
                       if ([[response status] isEqual: @"ACCEPTED"]) {
                           [[UGShoppingCart instance] clearCartForOrganizationId:[sendingRequest organizationId]];
                           if ([UGSingleton getOrganizationId] == nil)
                               [[UGAppDelegate dataController] storeCommonBuildOrganizationId:[sendingRequest organizationId] name:organizationName];
                       }

                       UINavigationController *nav = [viewController navigationController];
                       [nav popToRootViewControllerAnimated:NO];

                       if ([[response status] isEqual: @"ACCEPTED"]) {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UGLocalizedString(@"OrderAccepted") message:[response message] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           
                           UITabBarController *tabBarController = [nav tabBarController];
                           [UGAppDelegate goToOrdersTab:tabBarController forOrganizationId:[UGSingleton getOrganizationId] != nil ? nil : [sendingRequest organizationId]];
                       } else {
                           UGOrderRejectedController *rejectedViewController = [[nav storyboard] instantiateViewControllerWithIdentifier:rejectedViewIdentifier];
                           [rejectedViewController setOrderRequest:sendingRequest];
                           [rejectedViewController setOrganizationName:organizationName];
                           [rejectedViewController setOldProducts:orderedProducts];
                           [rejectedViewController setActualProducts:[response actualProducts]];
                           [nav pushViewController:rejectedViewController animated:YES];
                       }
                   } else {
                       [loadingIndicator stopAnimating];
                       [contentView setHidden:NO];
                   }
               }];
}

@end
