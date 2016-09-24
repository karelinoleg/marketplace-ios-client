//
//  UGProductDetailsViewController.m
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGProductDetailsViewController.h"
#import "UGProduct.h"
#import "UGConstants.h"
#import "UGSingleton.h"
#import "UGShoppingCart.h"

@interface UGProductDetailsViewController ()

@end

@implementation UGProductDetailsViewController

@synthesize products;
@synthesize selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[[self countLabel] layer] setCornerRadius:7];
    [[self pageControl] setNumberOfPages:[products count]];
    [[self pageControl] setCurrentPage:selectedIndex];
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCount:(int)count {
    [[self countLabel] setText:[NSString stringWithFormat:@"%d", count]];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    int newValue = sender.value;
    UGProduct *product = [products objectAtIndex:selectedIndex];
    [[UGShoppingCart instance] setProduct:product count:newValue];
    [self setCount:newValue];
}

- (void) reload {
    UGProduct *product = [products objectAtIndex:selectedIndex];
    
    [[self nameLabel] setText:[product name]];
    [[self descriptionView] setText:[product description]];
    int count = [[UGShoppingCart instance] getProductCount:[product identity]];
    [[self stepper] setValue:count];
    [self setCount:count];
    double price;
    NSNumber *discountPrice = [product discountPrice];
    if (discountPrice == nil) {
        [[self oldPriceLabel] setText:nil];
        price = [[product price] doubleValue];
        [[self oldPriceLabel] setHidden:YES];
    } else {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:COST([[product price] doubleValue]) attributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        [[self oldPriceLabel] setAttributedText:attributedString];
        price = [discountPrice doubleValue];
        [[self oldPriceLabel] setHidden:NO];
    }
    [[self priceLabel] setText: COST(price)];
    
    UIImageView *imageView = [self imageView];
    [UGSingleton loadImageHash:[product largeImageHash] toImageView:imageView withReloadingOf:imageView];
}

- (IBAction)changePage:(id)sender {
    selectedIndex = [[self pageControl] currentPage];
    [self reload];
}

@end
