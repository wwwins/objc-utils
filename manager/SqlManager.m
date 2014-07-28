//
//  SqlManager.m
//
//  Created by wwwins on 2014/7/25.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "SqlManager.h"


@interface SqlManager ()

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation SqlManager

+ (id)sharedManager {
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{
    instance = [self new];
  });
  return instance;
}

- (id)init
{
  if (self = [super init])
  {
    [self openDatabaseWithPath:DEFAULT_DB_FILE_NAME];
  }
  return self;
}

- (BOOL)openDatabaseWithPath:(NSString *)fileName
{
  if ([[_db.databasePath lastPathComponent] isEqualToString:fileName]) {
    return YES;
  }
  
  NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *dbPath = [documentsPath stringByAppendingPathComponent:fileName];
  NSLog(@"db path=%@",dbPath);
 
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:dbPath]) {
    NSLog(@"file dosen't exit.");
    return NO;
  }

  if ([_db open]) {
    [_db close];
  }
  
  _db = [FMDatabase databaseWithPath:dbPath];
  if (![_db open]) {
    NSLog(@"Could not open db.");
    return NO;
  }
  
  return YES;
}

- (FMResultSet *)queryWithStr:(NSString *)queryStr withDbName:(NSString *)withDbName;
{
  [self openDatabaseWithPath:withDbName];
  return [self queryWithStr:queryStr];
}

- (FMResultSet *)queryWithStr:(NSString *)queryStr
{
  return  [_db executeQuery:queryStr];
}

@end
