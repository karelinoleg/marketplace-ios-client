//
//  DBManager.h
//  Marketplace
//
//  Created by Олег on 5/22/16.
//  Copyright (c) 2016 U-group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

+ (DBManager *)instance;

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@end
