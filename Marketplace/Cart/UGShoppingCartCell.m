//
//  UGShoppingCartCell.m
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGShoppingCartCell.h"
#import "UGShoppingCart.h"
#import "UGConstants.h"

@implementation UGShoppingCartCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    int newValue = sender.value;
    [[UGShoppingCart instance] setProduct:product count:newValue];
    [self setCount:newValue];
    [[self cartRefreshDelegate] cartTotalsRefresh:[[self cartRefreshDelegate] getSectionForCell:self]];
}

- (void)setCount:(int)count {
    [[self countLabel] setText:[NSString stringWithFormat:@"%d", count]];
    [[self sumLabel] setText:COST([product getEffectivePrice] * count)];
}

@end
