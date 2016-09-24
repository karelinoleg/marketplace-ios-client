//
//  UGCatalogCell.m
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGCatalogCell.h"
#import "UGShoppingCart.h"

@implementation UGCatalogCell

@synthesize product;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [[[self countLabel] layer] setCornerRadius:7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [[[self countLabel] layer] setBackgroundColor:[[UIColor redColor] CGColor]];
}

- (IBAction)toCartAction:(id)sender {
    [[UGShoppingCart instance] increaseProductCount:product];
    [self setCount:[[UGShoppingCart instance] getProductCount:[product identity]]];
}

- (void)setCount:(int)count {
    [[self countLabel] setText:[NSString stringWithFormat:@"%d", count]];
}

@end
