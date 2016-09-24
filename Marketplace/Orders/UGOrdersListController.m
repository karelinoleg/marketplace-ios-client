//
//  UGSecondViewController.m
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrdersListController.h"
#import "UGSingleton.h"
#import "UGOrderEntry.h"
#import "UGOrderDetailsViewController.h"
#import "UGOrderEntryCell.h"
#import "UGAppDelegate.h"
#import "UGOrganizationBarButtonItem.h"

@interface UGOrdersListController ()

@end

@implementation UGOrdersListController {
    UIRefreshControl *refreshControl;
    UILabel *placeholderLabel;
    NSString *selectedOrganizationId;
}

@synthesize orders;

static NSString *detailsViewIdentifier = @"OrderDetailsViewIdentifier";
static NSString *cellIdentifier = @"OrderListCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:UGLocalizedString(@"OrdersList")];

    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UGLocalizedString(@"Loading")]];
    [refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [[self ordersTable] addSubview:refreshControl];
    
    UILabel *placeholder = [[UILabel alloc] init];
    [placeholder setFont:[[placeholder font] fontWithSize:20]];
    [placeholder setNumberOfLines:0];
    [placeholder setText:UGLocalizedString(@"NoOrderEntries")];
    [placeholder setTextAlignment:NSTextAlignmentCenter];
    [placeholder setTextColor:[UIColor lightGrayColor]];
    [placeholder setHidden:YES];
    [[self ordersTable] addSubview:placeholder];
    placeholderLabel = placeholder;

    selectedOrganizationId = [UGSingleton getOrganizationId];

    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrganizationsToolbarHeight:(CGFloat)height {
    for (NSLayoutConstraint *constraint in [[self toolbarScroll] constraints])
        if ([@"toolbarScrollHeightConstraint" isEqualToString:[constraint identifier]])
            [constraint setConstant:height];
}

- (void)reloadOrganizations {
    NSDictionary *commonBuildOrganizations = [UGSingleton getOrganizationId] == nil ? [[UGAppDelegate dataController] loadCommonBuildOrganizations] : nil;

    if (commonBuildOrganizations == nil || [commonBuildOrganizations count] < 1)
        [self setOrganizationsToolbarHeight:0];
    else {
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        for (NSString *identity in [commonBuildOrganizations allKeys]) {
            if (selectedOrganizationId == nil)
                selectedOrganizationId = identity;
            NSString *organizationName = [commonBuildOrganizations objectForKey:identity];
            UGOrganizationBarButtonItem *button = [[UGOrganizationBarButtonItem alloc] initWithTitle:organizationName style:UIBarButtonItemStyleBordered target:self action:@selector(loadForOrganizationBarButtonItem:)];
            [button setOrganizationId:identity];
            [button setOrganizationName:organizationName];
            [barItems addObject: button];
        }
        [[self toolbar] setItems:barItems];
        CGFloat width = 0;
        for (UIBarButtonItem *item in barItems){
            UIView *itemView = [item valueForKey:@"view"];
            CGFloat itemWidth = itemView ? itemView.bounds.size.width + 12.0 : 0.0;
            width += itemWidth;
        }
        for (NSLayoutConstraint *constraint in [[self toolbar] constraints])
            if ([@"toolbarWidthConstraint" isEqualToString:[constraint identifier]])
                [constraint setConstant:width];
        [self setOrganizationsToolbarHeight:44];
    }
}

- (void)reload {
    if (!refreshControl)
        return;

    [self reloadOrganizations];

    if (!selectedOrganizationId) {
        [refreshControl endRefreshing];
        [placeholderLabel setHidden:NO];
        return;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self beginRefreshingTableView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[UGSingleton getURLForOrderEntriesForOrganizationId:selectedOrganizationId]];
    [UGSingleton sendAsyncRequest:request
                completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [refreshControl endRefreshing];
                    
                    if (data.length > 0 && connectionError == nil)
                    {
                        NSError *err = nil;
                        NSArray *ordersJson = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                                error:&err];
                        NSMutableArray *ordersArray = 	[[NSMutableArray alloc] init];
                        for (NSDictionary *orderParams in ordersJson)
                            [ordersArray addObject:[[UGOrderEntry alloc] initWithParameters:orderParams]];
                        [self setOrders:[ordersArray copy]];
                        [[self ordersTable] reloadData];
                    }
                    [placeholderLabel setHidden:[[self orders] count] > 0];
                }];
}

- (void)beginRefreshingTableView {
    [refreshControl beginRefreshing];
    
    if (fabs(self.ordersTable.contentOffset.y) < FLT_EPSILON) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            self.ordersTable.contentOffset = CGPointMake(0, -refreshControl.frame.size.height);
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)loadForOrganizationBarButtonItem:(UGOrganizationBarButtonItem *)organizationBarButtonItem {
    selectedOrganizationId = [organizationBarButtonItem organizationId];
    [self reload];
}

- (void)setSelectedOrganizationId:(NSString *)newSelectedOrgId {
    selectedOrganizationId = newSelectedOrgId;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [placeholderLabel setFrame:[[self ordersTable] bounds]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOrderEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    UGOrderEntry *orderEntry = [orders objectAtIndex:[indexPath row]];
    [[cell orderNumberLabel] setText:[orderEntry orderNumber]];
    [[cell orderSumLabel] setText:COST([orderEntry sum])];
    [[cell orderTimeLabel] setText:[UGSingleton formatDateTime:[orderEntry orderTime]]];
    [UGSingleton decorateLabel:[cell orderStatusLabel] forOrderStatus:[orderEntry orderStatus]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *orderIdentity = [[[self orders] objectAtIndex:[indexPath row]] orderIdentity];
    if (orderIdentity) {
        UGOrderDetailsViewController *detailsViewController = [[self storyboard] instantiateViewControllerWithIdentifier:detailsViewIdentifier];
        [detailsViewController setOrderIdentity:orderIdentity];
        [[self navigationController] pushViewController:detailsViewController animated:YES];
    }
}

@end