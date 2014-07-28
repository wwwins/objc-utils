//
//  SqlManager.h
//
//  Created by wwwins on 2014/7/25.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define DEFAULT_DB_FILE_NAME @"default.db"

@interface SqlManager : NSObject

+ (SqlManager *)sharedManager;

- (BOOL)openDatabaseWithPath:(NSString *)fileName;
- (FMResultSet *)queryWithStr:(NSString *)queryStr;
- (FMResultSet *)queryWithStr:(NSString *)queryStr withDbName:(NSString *)withDbName;

@end
