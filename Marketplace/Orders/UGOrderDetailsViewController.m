//
//  UGOrderDetailsViewControlllerViewController.m
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGOrderDetailsViewController.h"
#import "UGOrderEntry.h"
#import "UGOrderItem.h"
#import "UGOrderItemCell.h"
#import "UGSingleton.h"
#import "UGConstants.h"

@interface UGOrderDetailsViewController ()

@end

@implementation UGOrderDetailsViewController {
    NSArray *orderItems;
    double sum;
}

@synthesize orderIdentity;

static NSString *cellIdentifier = @"OrderItemCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reload {
    [[self contentView] setHidden:YES];
    [[self indicatorView] startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[UGSingleton getURLForOrderEntryDetails:orderIdentity]];
    [UGSingleton sendAsyncRequest:request
                completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [[self indicatorView] stopAnimating];
                    
                    if (data.length > 0 && connectionError == nil)
                    {
                        NSError *err = nil;
                        NSDictionary *orderJson = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:kNilOptions
                                                                                    error:&err];
                        UGOrderEntry *orderEntry = [[UGOrderEntry alloc] initWithParameters:orderJson];
                        
                        [self setOrderEntry:orderEntry];
                    }
                }];
}

- (void)setOrderEntry:(UGOrderEntry *)orderEntry {
    orderItems = [orderEntry items];
    sum = [orderEntry sum];
    
    [[self orderNumberLabel] setText:[orderEntry orderNumber]];
    [[self customerNameLabel] setText:[orderEntry customerName]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    NSAttributedString *phoneNumber = [[NSAttributedString alloc] initWithString:[orderEntry phone] attributes:attrsDictionary];
    [[self customerPhoneLabel] setAttributedText:phoneNumber];
    [[self orderCommentLabel] setText:[orderEntry comment]];
    [UGSingleton decorateLabel:[self orderStatusLabel] forOrderStatus:[orderEntry orderStatus]];
    [[self orderTimeLabel] setText:[UGSingleton formatDateTime:[orderEntry orderTime]]];
    if ([orderEntry endTime]) {
        [UGSingleton decorateLabel:[self endTimeLabel] forOrderStatus:[orderEntry orderStatus]];
        [[self endTimeLabel] setText:[UGSingleton formatDateTime:[orderEntry endTime]]];
        [[self endTimeLabel] setHidden:NO];
    } else
        [[self endTimeLabel] setHidden:YES];
    if ([[orderEntry deliveryOption] isEqual: @"DELIVERY"]) {
        [[self deliveryAddressCaptionLabel] setText:UGLocalizedString(@"DeliveryAddress:")];
        [[self deliveryAddressLabel] setText:[orderEntry deliveryAddress]];
    } else {
        [[self deliveryAddressCaptionLabel] setText:UGLocalizedString(@"PickupPoint:")];
        [[self deliveryAddressLabel] setText:[orderEntry pickupPointAddress]];
    }
    
    [[self itemsTable] reloadData];
    [[self contentView] setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UGOrderItem *item = [orderItems objectAtIndex:[indexPath row]];
    int count = [item count];
    [[cell nameLabel] setText:[item productName]];
    [[cell countLabel] setText:[NSString stringWithFormat:@"(%d)", count]];
    [[cell sumLabel] setText:COST([item cost] * count)];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [NSString stringWithFormat:UGLocalizedString(@"Sum: %@"), COST(sum)];
}

@end
