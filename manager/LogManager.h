//
//  LogManager.h
//
//  Created by wwwins on 2014/11/24.
//  Copyright (c) 2014年 f. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "LogMessage.h"

@interface LogManager : NSObject

@property (nonatomic, strong) NSString *memoryIdentifier;
@property (nonatomic, strong) RLMRealm *realm;

+ (LogManager *)sharedManager;

- (void)useMemoryRealm;
- (void)useDefaultRealm;
- (void)log:(NSString *)message;

@end
