//
//  UGAppDelegate.h
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGDataController.h"

@interface UGAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UGDataController *dataController;

+ (NSURL *) requestServerURL;

+ (UGDataController *)dataController;

+ (void)goToOrdersTab:(UITabBarController *)tabBarController forOrganizationId:(NSString *)organizationId;

@end
