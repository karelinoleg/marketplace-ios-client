//
//  UGOrderController.m
//  Marketplace
//
//  Created by Олег on 5/9/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#define DELIVERY_OPTION_DELIVERY (@"DELIVERY")
#define DELIVERY_OPTION_PICKUP (@"PICKUP")

#define DELIVERY_DETAIL_TYPE_NAME (@"NAME")
#define DELIVERY_DETAIL_TYPE_PHONE (@"PHONE")
#define DELIVERY_DETAIL_TYPE_ADDRESS (@"ADDRESS")

#import "UGOrderController.h"
#import "UGOrderRejectedController.h"
#import "UGConstants.h"
#import "UGPair.h"
#import "UGSingleton.h"
#import "UGShoppingCart.h"
#import "UGAppDelegate.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLLocationManager.h>

@interface UGOrderController ()

@end

@implementation UGOrderController {
    UIBarButtonItem *orderButton;
    UITextField *activeTextField;

    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    BOOL forceRelocate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self reload];

    [[self organizationNameLabel] setText:[[self organization] name]];

    UGDataController *dataController = [UGAppDelegate dataController];
    [[self nameField] setText:[dataController loadDeliveryDetailForDetailType:DELIVERY_DETAIL_TYPE_NAME]];
    [[self phoneField] setText:[dataController loadDeliveryDetailForDetailType:DELIVERY_DETAIL_TYPE_PHONE]];
    [[self addressField] setText:[dataController loadDeliveryDetailForDetailType:DELIVERY_DETAIL_TYPE_ADDRESS]];
    UGDeliveryOptionMO *deliveryOptionMO = [dataController loadDeliveryOptionForOrganizationId:[[self organization] identity]];
    int storedPickupPointIndex = 0;
    NSString *storedDeliveryOption = nil;
    if (deliveryOptionMO != nil) {
        NSString *storedPickupPointId = [deliveryOptionMO pickupPointId];
        if (storedPickupPointId != nil)
            storedPickupPointIndex = [[self organization] getPickupPointIndexForIdentity:storedPickupPointId];
        if (storedPickupPointIndex == -1)
            storedPickupPointIndex = 0;
        storedDeliveryOption = [deliveryOptionMO deliveryOption];
    }

    BOOL pickupPickerEnabled = [[[self organization] pickupPoints] count] > 1;
    [[self pickupPicker] setUserInteractionEnabled:pickupPickerEnabled];
    [[self pickupPicker] setAlpha:pickupPickerEnabled ? 1 : 0.6];
    [[self pickupPicker] selectRow:storedPickupPointIndex inComponent:0 animated:NO];
    if (![[self organization] deliversToCustomer]) {
        [[self deliveryToggle] setSelectedSegmentIndex:1];
        [self hideView:[self deliveryToggle]];
    } else if (![[self organization] pickupsAtPoints]) {
        [[self deliveryToggle] setSelectedSegmentIndex:0];
        [self hideView:[self deliveryToggle]];
    } else if ([DELIVERY_OPTION_PICKUP isEqualToString:storedDeliveryOption])
        [[self deliveryToggle] setSelectedSegmentIndex:1];
    else if ([DELIVERY_OPTION_DELIVERY isEqualToString:storedDeliveryOption])
        [[self deliveryToggle] setSelectedSegmentIndex:0];
        
    [self deliveryOptionChanged:[self deliveryToggle]];

    if (![[self organization] paymentTypeCashSupport]) {
        [[self paymentTypeToggle] setSelectedSegmentIndex:1];
        [self hideView:[self paymentTypeToggle]];
    }
    // TODO
    //if (![[self organization] paymentTypeOnlineSupport]) {
    if (YES) {
        [[self paymentTypeToggle] setSelectedSegmentIndex:0];
        [self hideView:[self paymentTypeToggle]];
    }

    orderButton = [[UIBarButtonItem alloc] initWithTitle:UGLocalizedString(@"Order") style:UIBarButtonItemStyleDone target:self action:@selector(makeOrder:)];
    [[self navigationItem] setRightBarButtonItem:orderButton];
}

- (CLLocationManager *)getLocationManager {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter: kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [locationManager requestWhenInUseAuthorization];
    }

    return locationManager;
}

- (IBAction)relocate:(id)sender {
    forceRelocate = YES;
    [[self getLocationManager] startUpdatingLocation];
}

- (void) hideView:(UIView *)view {
    [view setHidden:YES];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) reload {
    [[self sumLabel] setText:COST([[UGShoppingCart instance] getSumForOrganizationId:[[self organization] identity]])];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)dealloc {
    // XXX workaround for http://stackoverflow.com/questions/15016348/set-delegates-to-nil-under-arc
    // Can be reproduced on iOS 8.1, 8.4.1
    [[self pickupPicker] setDataSource:nil];
    [[self pickupPicker] setDelegate:nil];
    [[self nameField] setDelegate:nil];
    [[self phoneField] setDelegate:nil];
    [[self commentField] setDelegate:nil];
    [[self addressField] setDelegate:nil];
    [self setPickupPicker:nil];
    [self setNameField:nil];
    [self setPhoneField:nil];
    [self setCommentField:nil];
    [self setAddressField:nil];
    activeTextField = nil;
    if (locationManager != nil) {
        [locationManager setDelegate:nil];
        locationManager = nil;
    }
    geocoder = nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[[self organization] pickupPoints] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[[[self organization] pickupPoints] objectAtIndex:row] name];
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    activeTextField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    activeTextField = nil;
}

- (void)keyboardDidShow:(NSNotification *)notfication {
    NSDictionary *info = [notfication userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [[self view] convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = [[self view] frame];
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin)) {
        [self.scrollView scrollRectToVisible:activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notfication {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)deliveryOptionChanged:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 1:
            // PICKUP
            [[self addressField] setHidden:YES];
            [[self locateButton] setHidden:YES];
            [[self pickupLabel] setHidden:NO];
            [[self pickupPicker] setHidden:NO];
            break;
        default:
            // DELIVERY
            [[self pickupPicker] setHidden:YES];
            [[self pickupLabel] setHidden:YES];
            [[self addressField] setHidden:NO];
            [[self locateButton] setHidden:NO];
            if (STR_EMPTY([[self addressField] text]))
                [self relocate:sender];
            break;
    }
}

- (IBAction)makeOrder:(id)sender {
    UGPair *error = nil;
    NSString *organizationId = [[self organization] identity];
    
    NSString *paymentType;
    switch ([[self paymentTypeToggle] selectedSegmentIndex]) {
        case 0:
            paymentType = @"CASH";
            break;
        case 1:
            paymentType = @"ONLINE";
            break;
        default:
            error = [[UGPair alloc] initWithKey:UGLocalizedString(@"PaymentTypeNotSpecified") value:UGLocalizedString(@"SpecifyPaymentType")];
            break;
    };

    NSString *deliveryOption;
    NSString *deliveryAddress;
    NSString *pickupPointId;
    if ([[self deliveryToggle] selectedSegmentIndex] == 1) {
        deliveryOption = @"PICKUP";
        deliveryAddress = nil;
        UGLocatedItem *pickupPoint = [[[self organization] pickupPoints] objectAtIndex:[[self pickupPicker] selectedRowInComponent:0]];
        pickupPointId = [pickupPoint identity];
    } else {
        deliveryOption = @"DELIVERY";
        pickupPointId = nil;
        deliveryAddress = [[self addressField] text];
        if (STR_EMPTY(deliveryAddress))
            error = [[UGPair alloc] initWithKey:UGLocalizedString(@"DeliveryAddressNotSpecified") value:UGLocalizedString(@"SpecifyDeliveryAddress")];
    }

    NSString *phone = [[self phoneField] text];
    if (STR_EMPTY(phone))
        error = [[UGPair alloc] initWithKey:UGLocalizedString(@"PhoneNumberNotSpecified") value:UGLocalizedString(@"SpecifyPhoneNumber")];

    if (error != nil) {
        [UGOrderController showAlert:(NSString *)[error key] message:(NSString *)[error value]];
        return;
    }
    
    [orderButton setEnabled:NO];
    
    UGShoppingCart *cart = [UGShoppingCart instance];
    NSArray *orderItems = [cart getOrderForOrganizationId:organizationId];
    NSDictionary *orderItemsDict =[UGOrderRequest orderItemsDictionaryFromCartItemsArray: orderItems];
    
    NSString *customerName = [[self nameField] text];
    
    NSString *devicePushToken = [[NSUserDefaults standardUserDefaults] objectForKey:PREFS_DEVICE_TOKEN_KEY];
    
    UGOrderRequest *orderRequest = [UGOrderRequest orderRequestForOrganization:organizationId deviceId:[UGSingleton getDeviceId] phone:phone customerName:customerName comment:[[self commentField] text] orderItems:orderItemsDict sum:[cart getSumForOrganizationId:organizationId] paymentType:paymentType deliveryOption:deliveryOption deliveryAddress:deliveryAddress pickupPointId:pickupPointId gcmRecipientId:devicePushToken clientType:CLIENT_TYPE clientPackageName:[UGSingleton getClientPackageName]];
    [UGOrderRejectedController sendOrderRequest:orderRequest organizationName:[[self organization] name] orderedProductsInfo:[UGOrderRejectedController productsFromCartItemsArray:orderItems] fromController:self loadingIndicator:[self indicatorView] contentView:[self scrollView]];
    [UGOrderController storeDeliveryOptions:deliveryOption pickupPointId:pickupPointId forOrganizationId:organizationId name:customerName phone:phone address:deliveryAddress];
}

+ (void) showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError : %@", error);
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSTimeInterval howRecent = [[location timestamp] timeIntervalSinceNow];
    if (howRecent < 15.0) {
        [manager stopUpdatingLocation];
        forceRelocate = NO;
        if (!geocoder)
            geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *addressString = placemark.thoroughfare ? [NSString stringWithFormat:@"%@", placemark.thoroughfare] : @"";
                addressString = [addressString stringByAppendingString:placemark.subThoroughfare ? [NSString stringWithFormat:@", %@", placemark.subThoroughfare] : @""];
                addressString = [addressString stringByAppendingString:placemark.locality ? [NSString stringWithFormat:@" [%@]", placemark.locality] : @""];
                if (!STR_EMPTY(addressString))
                    [[self addressField] setText:addressString];
            } else
                NSLog(@"%@", error.debugDescription);
        }];
    }
}

+ (void)storeDeliveryOptions:(NSString *)deliveryOption pickupPointId:(NSString *)pickupPointId forOrganizationId:(NSString *)organizationId name:(NSString *)name phone:(NSString *)phone address:(NSString *)address {
    UGDataController *dataController = [UGAppDelegate dataController];
    [dataController storeDeliveryDetail:name forDetailType:DELIVERY_DETAIL_TYPE_NAME];
    [dataController storeDeliveryDetail:phone forDetailType:DELIVERY_DETAIL_TYPE_PHONE];
    [dataController storeDeliveryDetail:address forDetailType:DELIVERY_DETAIL_TYPE_ADDRESS];
    
    [dataController storeDeliveryOption:deliveryOption pickupPointId:pickupPointId forOrganizationId:organizationId];
}

@end
