//
//  UIViewController+UGAboutController.m
//  Marketplace
//
//  Created by Oleg Karelin on 9/13/16.
//  Copyright © 2016 U-group. All rights reserved.
//

#import "UGAboutController.h"
#import "UGSingleton.h"

@interface UGAboutController() {
    UGOrganization *organization;
}

@end

@implementation UGAboutController {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self reload];
}

- (void)reload {
    [[self scrollView] setHidden:YES];
    [[self indicatorView] startAnimating];
    if (organization)
        [self setOrganizationData:organization];
    else {
        if (![self organizationId])
            [self setOrganizationId:[UGSingleton getOrganizationOrCommonBuildId]];
        NSURL *url = [UGSingleton getURLForCatalogByItemIds:[NSArray arrayWithObject:[self organizationId]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [UGSingleton sendAsyncRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data.length > 0 && connectionError == nil)
            {
                NSError *err = nil;
                NSArray *itemsJson = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&err];
                if ([itemsJson count] > 0) {
                    organization = [UGOrganization createByParameters:[itemsJson objectAtIndex:0]];
                    [self setOrganizationData:organization];
                }
            }
        }];
    }
}

- (void)setOrganizationData:(UGOrganization *)organizationData {
    [[self organizationNameView] setText:[organizationData name]];
    [[self descriptionView] setText:[organizationData description]];
    
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    if (!STR_EMPTY([organizationData phoneNumber]))
        [contacts addObject:[UGLocalizedString(@"phone:") stringByAppendingString:[organizationData phoneNumber]]];
    if (!STR_EMPTY([organizationData address]))
        [contacts addObject:[UGLocalizedString(@"address:") stringByAppendingString:[organizationData address]]];
    if (!STR_EMPTY([organizationData email]))
        [contacts addObject:[UGLocalizedString(@"e-mail:") stringByAppendingString:[organizationData email]]];
    if (!STR_EMPTY([organizationData webSite]))
        [contacts addObject:[UGLocalizedString(@"web:") stringByAppendingString:[organizationData webSite]]];
    if (!STR_EMPTY([organizationData businessHours]))
        [contacts addObject:[organizationData businessHours]];
    [[self contactsView] setText:[contacts componentsJoinedByString:@"\n\n"]];
    
    [[self deliversMark] setHidden:![organizationData deliversToCustomer]];
    [[self pickupsMark] setHidden:![organizationData pickupsAtPoints]];
    [[self cashPayMark] setHidden:![organizationData paymentTypeCashSupport]];
    [[self cardPayMark] setHidden:![organizationData paymentTypeOnlineSupport]];
    
    if ([organizationData largeImageHash])
        [UGSingleton loadImageHash:[organizationData largeImageHash] toImageView:[self imageView] withReloadingOf:[self imageView]];
    
    [[self indicatorView] stopAnimating];
    [[self scrollView] setHidden:NO];
}

@end
