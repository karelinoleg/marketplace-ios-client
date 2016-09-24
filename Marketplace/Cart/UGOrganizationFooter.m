//
//  UGOrganizationFooter.m
//  Marketplace
//
//  Created by Oleg Karelin on 9/18/16.
//  Copyright © 2016 U-group. All rights reserved.
//

#import "UGOrganizationFooter.h"
#import "UGOrganizationButton.h"

@implementation UGOrganizationFooter {
    UILabel *titleLabel;
    UGOrganizationButton *footerButton;
}

- (instancetype)initForOrganization:(UGOrganization *)organization title:(NSString *)title {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake(10, 3, 200, 32)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self setTitle:title];
        [self addSubview:titleLabel];
        
        if (organization != nil) {
            footerButton = [UGOrganizationButton buttonWithType:UIButtonTypeRoundedRect];
            [footerButton setOrganization:organization];
            [footerButton setFrame:CGRectMake(210, 3, 100, 34)];
            [footerButton setTitle:UGLocalizedString(@"toOrder") forState:UIControlStateNormal];
            [footerButton setHidden:organization == nil];
            [self addSubview:footerButton];
        }
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    [titleLabel setText:title];
}

- (UIButton *)getButton {
    return footerButton;
}

@end
