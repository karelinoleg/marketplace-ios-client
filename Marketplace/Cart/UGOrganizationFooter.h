//
//  UGOrganizationFooter.h
//  Marketplace
//
//  Created by Oleg Karelin on 9/18/16.
//  Copyright © 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOrganization.h"

@interface UGOrganizationFooter : UIView

- (instancetype)initForOrganization:(UGOrganization *)forOrganization title:(NSString *)title ;

- (void)setTitle:(NSString *)title;

- (UIButton *)getButton;

@end
