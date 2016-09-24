//
//  UGSingleton.h
//  Marketplace
//
//  Created by Олег on 3/6/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGOrganization.h"

@interface UGSingleton : NSObject

+ (id) instance;

+ (NSString *) getClientPackageName;

+ (NSString *) getOrganizationId;

+ (NSString *) getOrganizationOrCommonBuildId;

+ (NSString *) getCommonBuildOrganizationId;

+ (NSString *) getCommonBuildRootFolderId;

+ (void) sendAsyncRequest:(NSURLRequest*) request
      completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler NS_AVAILABLE(10_7, 5_0);

+ (void) sendPostRequest:(NSURL *)url
                jsonData:(NSData *)jsonData
       completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler NS_AVAILABLE(10_7, 5_0);

+ (NSURL *) getURLForCatalogByParentId:(NSString *)parentId;

+ (NSURL *) getURLForCatalogByItemIds:(NSArray *)itemIds;

+ (NSURL *) getURLForImageByHash:(NSString *)hash;

+ (NSURL *) getURLForOrderEntriesForOrganizationId:(NSString *)organizationId;

+ (NSURL *) getURLForOrderEntryDetails:(NSString *)orderId;

+ (NSURL *) getURLForMakeOrder;

+ (void) loadImageHash: (NSString *)imageHash toCell:(UITableViewCell *)cell;

+ (void) loadImageHash: (NSString *)imageHash toImageView:(UIImageView *)imageView ofCell:(UITableViewCell *)cell;

+ (void) loadImageHash: (NSString *)imageHash toImageView:(UIImageView *)imageView withReloadingOf:(UIView *) reloadableView;

+ (NSString *) getDeviceId;

- (UIColor *)colorGreen;

- (UIColor *)colorRed;

+ (void)decorateLabel:(UILabel *)label forOrderStatus:(NSString *)orderStatus;

+ (NSString *)formatDateTime:(NSDate *)dateTime;
@end
