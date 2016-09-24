//
//  UGAppDelegate.m
//  Marketplace
//
//  Created by Олег on 3/5/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGAppDelegate.h"
#import "UGConstants.h"
#import "UGSingleton.h"
#import "UGShoppingCart.h"
#import "UGOrdersListController.h"

@implementation UGAppDelegate

+ (NSURL *) requestServerURL {
    NSURL *url = [NSURL URLWithString: [WEB_SERVICE_URL stringByAppendingString: WEB_SERVICE_URL_VERSION ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;

    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    NSURL *webServiceURL = nil;
    if (data.length > 0 && error == nil)
    {
        NSDictionary *webApiInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:NULL];
        // TODO
        webServiceURL = [NSURL URLWithString:[[webApiInfo objectForKey:@"url"] stringByAppendingString:@"/"]];
    }

    return webServiceURL;
}

+ (UGDataController *)dataController {
    UGAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return [delegate dataController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UGDataController *dc = [[UGDataController alloc] init];
    [self setDataController:dc];
    [[UGShoppingCart instance] loadStoredCartContent:[dc loadStoredShoppingCartItems]];
    
    // Override point for customization after application launch.
    NSURLCache *urlCache = [[NSURLCache alloc]
                            initWithMemoryCapacity:4 * 1024 * 1024
                                        diskCapacity:50 * 1024 * 1024
                                            diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];

    [self registerForPushNotifications];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerForPushNotifications {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types
                                                        // TODO
                                                                                         categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if ([notificationSettings types] != UIUserNotificationTypeNone)
        [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *devTokenString = [self stringWithDeviceToken:deviceToken];
    //NSLog(@"My token is: %@", devTokenString);

    [[NSUserDefaults standardUserDefaults] setObject:devTokenString forKey:PREFS_DEVICE_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in APN registration: %@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    NSString *organizationId = [userInfo objectForKey:@"organizationId"];
    organizationId = [UGSingleton getOrganizationId] != nil ? nil : organizationId;
    UIViewController *viewController = [[application keyWindow] rootViewController];
    UITabBarController *tabBarViewController = [viewController isKindOfClass:[UITabBarController class]] ? (UITabBarController *)viewController : [viewController tabBarController];

    if ([application applicationState] != UIApplicationStateActive)
     [UGAppDelegate goToOrdersTab:tabBarViewController forOrganizationId:organizationId];
    else {
        UIViewController *presentedVC = [tabBarViewController presentedViewController];
        if (presentedVC != nil && [presentedVC isKindOfClass:[UIAlertController class]])
            return;
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:UGLocalizedString(@"Attention") message:[aps objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:UGLocalizedString(@"ToOrdersList") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [UGAppDelegate goToOrdersTab:tabBarViewController forOrganizationId:organizationId];
            }]];
        [alert addAction:[UIAlertAction actionWithTitle:UGLocalizedString(@"Ok") style:UIAlertActionStyleDefault handler:nil]];
        
        [tabBarViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    const char *devTokenBytes = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++)
        [token appendFormat:@"%02.2hhX", devTokenBytes[i]];
    
    return [token copy];
}

+ (void)goToOrdersTab:(UITabBarController *)tabBarViewController forOrganizationId:(NSString *)organizationId {
    [tabBarViewController setSelectedIndex:1];
    UINavigationController *ordersListNavigationController = [tabBarViewController selectedViewController];
    UIViewController *ordersListViewController = [ordersListNavigationController topViewController];
    if (organizationId != nil && [ordersListViewController isKindOfClass:[UGOrdersListController class]])
        [(UGOrdersListController *)ordersListViewController setSelectedOrganizationId:organizationId];
    if ([ordersListViewController conformsToProtocol:@protocol(UGReloadable)])
        [(UIViewController<UGReloadable> *)ordersListViewController reload];
}

@end
