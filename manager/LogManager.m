//
//  LogManager.m
//
//  Created by wwwins on 2014/11/24.
//  Copyright (c) 2014年 f. All rights reserved.
//

#import "LogManager.h"

@implementation LogManager

@synthesize memoryIdentifier = _memoryIdentifier;
@synthesize realm = _realm;

+ (id)sharedManager
{
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (id)init
{
  if (self = [super init])
  {
    // Ensure we start with an empty database
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    
    [self useDefaultRealm];
  }
  return self;
}

- (void)useDefaultRealm
{
  _realm = [RLMRealm defaultRealm];
}

- (void)log:(NSString *)message
{
  [_realm beginWriteTransaction];
  [LogMessage createInRealm:_realm withObject:@[[NSDate new], message]];
  [_realm commitWriteTransaction];
}

@end
