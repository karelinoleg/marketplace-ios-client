//
//  UIViewController+UGAboutController.h
//  Marketplace
//
//  Created by Oleg Karelin on 9/13/16.
//  Copyright © 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGReloadable.h"

@interface UGAboutController : UIViewController<UGReloadable>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) IBOutlet UIView *scrollView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *organizationNameView;
@property (nonatomic, strong) IBOutlet UITextView *descriptionView;
@property (nonatomic, strong) IBOutlet UITextView *contactsView;

@property (nonatomic, strong) IBOutlet UILabel *deliversMark;
@property (nonatomic, strong) IBOutlet UILabel *pickupsMark;
@property (nonatomic, strong) IBOutlet UILabel *cashPayMark;
@property (nonatomic, strong) IBOutlet UILabel *cardPayMark;

@property (nonatomic, strong) NSString *organizationId;

@end
