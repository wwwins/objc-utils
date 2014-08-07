//
//  PKPassManager.h
//
//  Created by wwwins on 2014/8/7.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PassKit/PassKit.h"

@interface PKPassManager : NSObject

@property (strong, nonatomic) PKPassLibrary *passLib;

+ (PKPassManager *)sharedManager;

- (void)showPassByIndex:(int)index;
- (void)showPassBySerialNumber:(NSString *)sn;
- (NSMutableArray *)getPassSerialNumberArrayExcludeWithArray:(NSArray *)excludeArray;

@end
