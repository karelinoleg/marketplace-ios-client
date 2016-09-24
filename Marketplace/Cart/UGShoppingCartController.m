//
//  UGShoppingCartController.m
//  Marketplace
//
//  Created by Олег on 5/3/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGShoppingCartController.h"
#import "UGShoppingCart.h"
#import "UGShoppingCartCell.h"
#import "UGSingleton.h"
#import "UGConstants.h"
#import "UGOrderController.h"
#import "UGCartItem.h"
#import "UGOrganizationFooter.h"

@interface UGShoppingCartController ()

@end

@implementation UGShoppingCartController {
    NSDictionary *carts;
    NSDictionary *organizations;
    NSDictionary *footerViews;
    UIBarButtonItem *orderButton;
    UIRefreshControl *refreshControl;
    UILabel *placeholderLabel;
}

static NSString *orderViewIdentifier = @"MakeOrderViewIdentifier";
static NSString *cellIdentifier = @"ShoppingCartCellIdentifier";

- (NSString *)organizationIdAtSection:(NSInteger)index {
    NSArray *keys = [carts allKeys];
    return [keys objectAtIndex:index];
}

- (NSArray *)cartAtSection:(NSInteger)index {
    return [carts objectForKey:[self organizationIdAtSection:index]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UGLocalizedString(@"Loading")]];
    [refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [[self itemsTable] addSubview:refreshControl];

    UILabel *placeholder = [[UILabel alloc] init];
    [placeholder setFont:[[placeholder font] fontWithSize:20]];
    [placeholder setNumberOfLines:0];
    [placeholder setText:UGLocalizedString(@"CartIsEmpty")];
    [placeholder setTextAlignment:NSTextAlignmentCenter];
    [placeholder setTextColor:[UIColor lightGrayColor]];
    [[self itemsTable] addSubview:placeholder];
    placeholderLabel = placeholder;

    NSString *singleOrganizationId = [UGSingleton getOrganizationId];
    if (singleOrganizationId != nil) {
        orderButton = [[UIBarButtonItem alloc] initWithTitle:UGLocalizedString(@"toOrder") style:UIBarButtonItemStyleDone target:self action:@selector(toOrder:)];
        [[self navigationItem] setRightBarButtonItem:orderButton];
        [orderButton setEnabled:![[UGShoppingCart instance] isEmptyForOrganizationId:singleOrganizationId]];
    }

    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reload {
    [placeholderLabel setHidden:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self beginRefreshingTableView];
    
    BOOL mutipleOrganizations = [UGSingleton getOrganizationId] == nil;
    if (mutipleOrganizations)
        carts = [[UGShoppingCart instance] getOrdersForOrganizations];
    else
        carts = [[UGShoppingCart instance] getOrdersFilteredByOrganizationId:[UGSingleton getOrganizationId]];
    
    if ([carts count] < 1) {
        [self cartTotalsRefresh:-1];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [refreshControl endRefreshing];
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[UGSingleton getURLForCatalogByItemIds:[carts allKeys]]];
    [UGSingleton sendAsyncRequest:request
                completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [refreshControl endRefreshing];

                    if (data.length > 0 && connectionError == nil)
                    {
                        NSError *err = nil;
                        NSArray *itemsJson = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:&err];
                        NSMutableDictionary *orgs = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *footers = [[NSMutableDictionary alloc] init];
                        for (NSDictionary *org in itemsJson) {
                            NSString *identity = [org objectForKey:@"identity"];
                            UGOrganization *organization = [UGOrganization createByParameters:org];
                            [orgs setObject:organization forKey:identity];
                            UGOrganizationFooter *footer = [[UGOrganizationFooter alloc] initForOrganization:(mutipleOrganizations ? organization : nil) title:[self getFooterTextForOrganizationId:identity]];
                            [[footer getButton] addTarget:self action:@selector(toOrder:) forControlEvents:UIControlEventTouchUpInside];
                            [footers setObject:footer forKey:identity];
                        }
                        organizations = [NSDictionary dictionaryWithDictionary:orgs];
                        footerViews = [NSDictionary dictionaryWithDictionary:footers];
                    }

                    [self cartTotalsRefresh:-1];
                }];
}

- (NSString *)getFooterTextForOrganizationId:(NSString *)organizationId {
    return [NSString stringWithFormat:UGLocalizedString(@"Sum: %@"), COST([[UGShoppingCart instance] getSumForOrganizationId:organizationId])];
}

- (void)cartTotalsRefresh:(NSInteger)section {
    if (orderButton)
        [orderButton setEnabled:![[UGShoppingCart instance] isEmptyForOrganizationId:[UGSingleton getOrganizationId]]];
    [placeholderLabel setHidden:[carts count] > 0];

    if (section < 0)
        [[self itemsTable] reloadData];
    else {
        [UIView setAnimationsEnabled:NO];
        [[self itemsTable] beginUpdates];
        NSString *organizationId = [self organizationIdAtSection:section];
        UGOrganizationFooter *footer = [footerViews objectForKey:organizationId];
        [footer setTitle:[self getFooterTextForOrganizationId:organizationId]];
        [[footer getButton] setEnabled:![[UGShoppingCart instance] isEmptyForOrganizationId:organizationId]];
        [[self itemsTable] endUpdates];
        [UIView setAnimationsEnabled:YES];
    }
}

- (void)beginRefreshingTableView {
    [refreshControl beginRefreshing];
    
    if (fabs(self.itemsTable.contentOffset.y) < FLT_EPSILON) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            self.itemsTable.contentOffset = CGPointMake(0, -refreshControl.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [placeholderLabel setFrame:[[self itemsTable] bounds]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [carts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self cartAtSection:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setCartRefreshDelegate:self];
    UGCartItem *cartItem = [[self cartAtSection:[indexPath section]] objectAtIndex:[indexPath row]];
    [cell setProduct:[cartItem product]];
    int count = [cartItem count];
    [[cell nameLabel] setText:[[cartItem product] name]];
    [[cell stepper] setValue: count];
    [cell setCount:count];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    UGOrganization *organization = [organizations objectForKey:[self organizationIdAtSection:section]];
    return [organization name];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [footerViews objectForKey:[self organizationIdAtSection:section]];
}

- (NSInteger)getSectionForCell:(UITableViewCell *)cell {
    return [[[self tableView] indexPathForCell:cell] section];
}

- (void)orderToOrganization:(UGOrganization *)organization {
    UIStoryboard *storyboard = [self storyboard];
    UGOrderController *orderController = [storyboard instantiateViewControllerWithIdentifier:orderViewIdentifier];
    [orderController setOrganization:organization];
    [[self navigationController] pushViewController:orderController animated:YES];
}

- (IBAction)toOrder:(id)sender {
    UGOrganization *organization;
    if ([UGSingleton getOrganizationId] == nil)
        organization = [sender organization];
    else
        organization = [organizations objectForKey:[UGSingleton getOrganizationId]];
    [self orderToOrganization:organization];
}

@end
