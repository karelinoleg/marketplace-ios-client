//
//  UGOrderController.h
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UGReloadable.h"
#import "UGOrganization.h"

@interface UGOrderController : UIViewController<UGReloadable, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UILabel *organizationNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *sumLabel;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *phoneField;
@property (nonatomic, strong) IBOutlet UITextField *commentField;
@property (nonatomic, strong) IBOutlet UITextField *addressField;
@property (nonatomic, strong) IBOutlet UIButton *locateButton;
@property (nonatomic, strong) IBOutlet UILabel *pickupLabel;
@property (nonatomic, strong) IBOutlet UIPickerView *pickupPicker;
@property (nonatomic, strong) IBOutlet UISegmentedControl *deliveryToggle;
@property (nonatomic, strong) IBOutlet UISegmentedControl *paymentTypeToggle;

@property (nonatomic, strong) UGOrganization *organization;

@end
