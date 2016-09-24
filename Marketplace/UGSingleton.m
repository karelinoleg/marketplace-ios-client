//
//  UGSingleton.m
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import "UGSingleton.h"
#import "UGConstants.h"
#import "UGAppDelegate.h"
#import "UGOrderRequest.h"

@implementation UGSingleton {

    NSURL *webServiceURL;

    UIColor *colorGreen;
    UIColor *colorRed;
}

- (NSURL *) getWebServiceURL {
    if (webServiceURL == nil)
        webServiceURL = [UGAppDelegate requestServerURL];
   return webServiceURL;
}

+ (id) instance {
    static UGSingleton *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

+ (NSString *) getClientPackageName {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *) getOrganizationId {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UGOrganizationIdentifier"];
}

+ (NSString *)getOrganizationOrCommonBuildId {
    NSString *organizationId = [UGSingleton getOrganizationId];
    return organizationId != nil ? organizationId : [UGSingleton getCommonBuildOrganizationId];
}

+ (NSString *) getCommonBuildOrganizationId {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UGCommonBuildOrganizationIdentifier"];
}

+ (NSString *) getCommonBuildRootFolderId {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UGCommonBuildRootFolderIdentifier"];
}

+ (void) sendAsyncRequest:(NSURLRequest*) request
      completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler NS_AVAILABLE(10_7, 5_0) {
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:handler];
}

+ (void) sendPostRequest:(NSURL *)url
                jsonData:(NSData *)jsonData
      completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler NS_AVAILABLE(10_7, 5_0) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:handler];
}

+ (NSURL *) getURLForPath:(NSString *)path parameters:(NSString *)queryParameters {
    NSURL *pathURL = [NSURL URLWithString: [path stringByAppendingFormat:@"/%d", WEB_SERVICE_API_VERSION]relativeToURL:[[UGSingleton instance] getWebServiceURL]];
    if (queryParameters)
        return [NSURL URLWithString:[NSString stringWithFormat:@"?%@", queryParameters] relativeToURL:pathURL];
    return pathURL;
}

+ (NSURL *) getURLForPath:(NSString *)path {
    NSURL *r = [UGSingleton getURLForPath:path parameters:nil];
    return r;
}

+ (NSURL *) getURLForCatalogByParentId:(NSString *)parentId {
    if (!parentId)
        parentId = [UGSingleton getOrganizationId];
    if (!parentId)
        parentId = [UGSingleton getCommonBuildRootFolderId];
    return [UGSingleton getURLForPath:WEB_SERVICE_URL_CATALOG parameters: parentId ? [NSString stringWithFormat:@"parentId=%@", parentId] : @""];
}

+ (NSURL *) getURLForCatalogByItemIds:(NSArray *)itemIds {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *itemId in itemIds)
        [array addObject:[NSString stringWithFormat:@"itemId=%@", itemId]];

    NSString *params = [array componentsJoinedByString:@"&"];
    return [UGSingleton getURLForPath:WEB_SERVICE_URL_CATALOG parameters:params];
}

+ (NSURL *) getURLForOrderEntriesForOrganizationId:(NSString *)organizationId {
    return [UGSingleton getURLForPath:WEB_SERVICE_URL_ORDER_ENTRIES parameters:[NSString stringWithFormat:@"deviceId=%@&packageName=%@&organizationId=%@", [UGSingleton getDeviceId], [UGSingleton getClientPackageName], organizationId]];
}

+ (NSURL *) getURLForOrderEntryDetails:(NSString *)orderId {
    return [UGSingleton getURLForPath:WEB_SERVICE_URL_ORDER_ENTRIES parameters:[NSString stringWithFormat:@"deviceId=%@&packageName=%@&orderId=%@", [UGSingleton getDeviceId], [UGSingleton getClientPackageName], orderId]];
}

+ (NSURL *) getURLForMakeOrder {
    return [UGSingleton getURLForPath:WEB_SERVICE_URL_ORDER];
}

+ (NSURL *) getURLForImageByHash:(NSString *)hash {
    return [UGSingleton getURLForPath:WEB_SERVICE_URL_IMAGE parameters:[NSString stringWithFormat:@"hash=%@", hash]];
}

+ (void) loadImageHash: (NSString *)imageHash toCell:(UITableViewCell *)cell {
    [UGSingleton loadImageHash:imageHash toImageView:[cell imageView] withReloadingOf:cell];
}

+ (void) loadImageHash: (NSString *)imageHash toImageView:(UIImageView *)imageView ofCell:(UITableViewCell *)cell {
    [UGSingleton loadImageHash:imageHash toImageView:imageView withReloadingOf:cell];
}

+ (void) loadImageHash: (NSString *)imageHash toImageView:(UIImageView *)imageView withReloadingOf:(UIView *) reloadableView {
    
    if (imageHash == nil) {
        [imageView setImage: nil];
        [reloadableView setNeedsLayout];
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[UGSingleton getURLForImageByHash:imageHash]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data.length > 0 && connectionError == nil)
                               {
                                   UIImage *image = [UIImage imageWithData:data];
                                   [imageView setImage:image];
                                   [reloadableView setNeedsLayout];
                               }
                           }];
}

+ (NSString *) getDeviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (UIColor *)colorGreen {
    if (!colorGreen) {
        NSNumber *colorKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UGColorGreen"];
        colorGreen = colorKey ? UIColorFromRGB([colorKey intValue]) : UIColorFromRGB(0x4CD964);
    }
    return colorGreen;
}

- (UIColor *)colorRed {
    if (!colorRed) {
        NSNumber *colorKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UGColorRed"];
        colorRed = colorKey ? UIColorFromRGB([colorKey intValue]) : UIColorFromRGB(0xFF3B30);
    }
    return colorRed;
}

+ (void)decorateLabel:(UILabel *)label forOrderStatus:(NSString *)orderStatus {
    NSString *orderStatusKey = [NSString stringWithFormat:@"OrderStatus.%@", orderStatus];
    [label setText:UGLocalizedString(orderStatusKey)];
    [label setTextColor:([@"ISSUED" isEqualToString:orderStatus] ? [[UGSingleton instance] colorGreen] : [@"REJECTED" isEqualToString:orderStatus] || [@"NOT_ISSUED" isEqualToString:orderStatus] ? [[UGSingleton instance] colorRed] : [UIColor grayColor])];
}

+ (NSString *)formatDateTime:(NSDate *)dateTime {
    return [NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
}

@end
