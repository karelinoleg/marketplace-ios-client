//
//  UGProductDetailsViewController.h
//  Marketplace
//
//  Created by Олег on 4/21/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGReloadable.h"

@interface UGProductDetailsViewController : UIViewController<UGReloadable>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITextView *descriptionView;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *oldPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *products;
@property (nonatomic) int selectedIndex;

@end
