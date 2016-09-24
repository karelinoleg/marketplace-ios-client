//
//  UGFirstViewController.m
//  Marketplace
//
//  Created by Oleg Karelin on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGCatalogController.h"
#import "UGConstants.h"
#import "UGSingleton.h"
#import "UGCatalogItem.h"
#import "UGFolderItem.h"
#import "UGProduct.h"
#import "UGProductDetailsViewController.h"
#import "UGCatalogCell.h"
#import "UGShoppingCart.h"

@interface UGCatalogController ()

@end

@implementation UGCatalogController {
    UIRefreshControl *refreshControl;
}

@synthesize parentId;
@synthesize parentName;
@synthesize catalogItems;

static NSString *cellIdentifier = @"CatalogCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:parentName == nil ? UGLocalizedString(@"Catalog") : parentName];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:UGLocalizedString(@"Loading")]];
    [refreshControl addTarget:self action:@selector(loadCatalogItems) forControlEvents:UIControlEventValueChanged];
    [[self catalogTable] addSubview:refreshControl];

    [self loadCatalogItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reload {
    [self loadCatalogItems];
}

- (void) loadCatalogItems {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [refreshControl beginRefreshing];

    NSURLRequest *request = [NSURLRequest requestWithURL:[UGSingleton getURLForCatalogByParentId:parentId]];
    [UGSingleton sendAsyncRequest:request
              completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                  [refreshControl endRefreshing];
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                  if (data.length > 0 && connectionError == nil)
                  {
                      NSError *err = nil;
                      NSArray *itemsJson = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&err];
                      NSMutableArray *items = [[NSMutableArray alloc] init];
                      for (NSDictionary *item in itemsJson)
                        [items addObject:[UGCatalogItem createByParameters:item]];
                      [self setCatalogItems:[items copy]];
                      [[self catalogTable] reloadData];
                   }
                }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [catalogItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UGCatalogItem *item = [self.catalogItems objectAtIndex:[indexPath row]];
    if ([item isKindOfClass:[UGProduct class]]) {
        [[cell folderNameLabel] setText:nil];
        [[cell folderDescriptionLabel] setText:nil];
        [[cell folderDescriptionLabel] setHidden:YES];
        [[cell folderNameLabel] setHidden:YES];
        [[cell nameLabel] setText:[item name]];
        [[cell descriptionLabel] setText:[item description]];
        [[cell nameLabel] setHidden:NO];
        [[cell descriptionLabel] setHidden:NO];
        UGProduct *product = (UGProduct *)item;
        [cell setProduct:product];
        [cell setCount:[[UGShoppingCart instance] getProductCount:[item identity]]];
        [[cell toCartButton] setHidden:NO];
        [[cell countLabel] setHidden:NO];
        double price;
        NSNumber *discountPrice = [product discountPrice];
        if (discountPrice == nil) {
            price = [[product price] doubleValue];
        } else {
//        TODO show for landscape orientation
//            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:COST([[product price] doubleValue]) attributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
//            [[cell oldPriceLabel] setAttributedText:attributedString];
            price = [discountPrice doubleValue];
        }
        [[cell oldPriceLabel] setText:nil];
        [[cell oldPriceLabel] setHidden:YES];
        [[cell priceLabel] setText: COST(price)];
        [[cell priceLabel] setHidden:NO];
    } else {
        [[cell countLabel] setHidden:YES];
        [[cell toCartButton] setHidden:YES];
        [[cell priceLabel] setHidden:YES];
        [[cell oldPriceLabel] setHidden:YES];
        [[cell nameLabel] setText:nil];
        [[cell descriptionLabel] setText:nil];
        [[cell descriptionLabel] setHidden:YES];
        [[cell nameLabel] setHidden:YES];
        [[cell folderNameLabel] setText:[item name]];
        [[cell folderDescriptionLabel] setText:[item description]];
        [[cell folderNameLabel] setHidden:NO];
        [[cell folderDescriptionLabel] setHidden:NO];
    }

    [UGSingleton loadImageHash:[item smallImageHash] toImageView:[cell itemImageView] ofCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGCatalogItem *item = [self.catalogItems objectAtIndex:[indexPath row]];
    if ([item isKindOfClass:[UGFolderItem class]]){
        UGCatalogController *newCatalogController = [[self storyboard] instantiateViewControllerWithIdentifier:@"CatalogViewIdentifier"];
        [newCatalogController setParentId:[item identity]];
        [newCatalogController setParentName:[item name]];
        [[self navigationController] pushViewController:newCatalogController animated:YES];
    } else if ([item isKindOfClass:[UGProduct class]]){
        NSMutableArray *products = [[NSMutableArray alloc] init];
        for (UGCatalogItem *cur in [self catalogItems])
            if ([cur isKindOfClass:[UGProduct class]])
                [products addObject:cur];
        UGProductDetailsViewController *detailsViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ProductDetailsViewIdentifier"];
        [detailsViewController setProducts:products];
        [detailsViewController setSelectedIndex:[indexPath row]];
        [[self navigationController] pushViewController:detailsViewController animated:YES];
    }
}

@end
