//
//  UGCommonBuildOrganizationMO.h
//  Marketplace
//
//  Created by Олег on 5/23/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UGCommonBuildOrganizationMO : NSManagedObject

@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *name;

@end
